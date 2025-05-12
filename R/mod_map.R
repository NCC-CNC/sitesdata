#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::div(class = "spinner"),
    mapgl::maplibreOutput(ns("map"), height = "275px"),
    bslib::layout_columns(
      class = "shp-input-row",
      col_widths = c(10,2),
      shiny::p(bsicons::bs_icon("upload", fill = "primary"), "Upload Polygon"),
      bslib::tooltip(
      shiny::actionButton(ns("erase_shp"), bsicons::bs_icon("eraser", fill = "primary")),
      "Clear polygon."
      )
    ),
    shiny::div(class = "shp-input",
    bslib::tooltip(
    shiny::fileInput(
      inputId = ns("shp"), 
      label = NULL, 
      multiple = TRUE,
      accept = c(".shp", ".shx", ".dbf", ".prj", ".sbn", ".sbx", ".cpg")
      ),
     ".shp, .shx, .dbf, and .prj files are required."
     ),
    shiny::div(class = "shp-required", "Required")
    )
  )
}
    
#' map Server Functions
#'
#' @noRd 
mod_map_server <- function(id, geojson_aoi){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # set validation ui
    shinyjs::runjs(
      "document.querySelector('.form-control').classList.add('is-invalid');"
    )
    
    # init map
    output$map <- mapgl::renderMaplibre({
      mapgl::maplibre(
        style = mapgl::carto_style("positron"),
        center = c(-100, 40)
      )
    })
    
    shiny::observeEvent(input$shp, {
      # update progress bar
      shinyjs::runjs(
       "document.querySelector('.shp-required').textContent = 'Validating Polyogn';
       document.querySelector('.progress-bar').textContent = '... Uploading';
       document.querySelector('.progress-bar').style.backgroundColor = '#33862B';
       const spinner = document.querySelector('.spinner');
       spinner.style.display = 'block'"
      )   
    })
    
    # Get path
    path <- reactive({input$shp})
    
    # add layer 
    shiny::observeEvent(path(), {
      
      # convert shp to sf object
      shp <- upload_shp(path)
      
      # catch any error
      if (is.null(shp())) {
        # set validation ui
        shinyjs::runjs(
        "document.querySelector('.form-control').classList.add('is-invalid');
         document.querySelector('.shp-required').textContent = 'Something went wrong';
         document.querySelector('.progress-bar').textContent = 'Error';
         document.querySelector('.progress-bar').style.backgroundColor = '#c10000';
         const spinner = document.querySelector('.spinner');
         spinner.style.display = 'none'"
        )
        return()
      }

      # make sure aoi is polygon
      if (!all(sf::st_geometry_type(shp()) %in% c("POLYGON", "MULTIPOLYGON"))) {
        # set validation ui
        shinyjs::runjs(
        "document.querySelector('.form-control').classList.add('is-invalid');
         document.querySelector('.shp-required').textContent = 'Not a polygon';
         document.querySelector('.progress-bar').textContent = 'Error';
         document.querySelector('.progress-bar').style.backgroundColor = '#c10000';
         const spinner = document.querySelector('.spinner');
         spinner.style.display = 'none'"
        )
        return()
      }
      
      # AOI should not exceed 5 polygons, will ask user to dissolve their poygon
      if (nrow(shp()) > 5) {
        # set validation ui
        shinyjs::runjs(
         "document.querySelector('.form-control').classList.add('is-invalid');
          document.querySelector('.shp-required').textContent = 'Please dissolve your polygon';
          document.querySelector('.progress-bar').textContent = 'Error';
          document.querySelector('.progress-bar').style.backgroundColor = '#c10000';
          const spinner = document.querySelector('.spinner');
          spinner.style.display = 'none'"
        )
        return()
      }
      
      # check number of planing units
      shp_canada_albers <- sf::st_transform(shp(), crs = sf::st_crs(ncc_1km))
      ncc_1km_masked <- terra::mask(ncc_1km, shp_canada_albers )
      n_cells <- sum(terra::values(ncc_1km_masked) > 0, na.rm = TRUE)
      
      if (n_cells > 750000) {
        # set validation ui
        shinyjs::runjs(
        "document.querySelector('.form-control').classList.add('is-invalid');
         document.querySelector('.shp-required').textContent = 'Planning units exceed 750,000';
         document.querySelector('.progress-bar').textContent = 'Error';
         document.querySelector('.progress-bar').style.backgroundColor = '#c10000';
         const spinner = document.querySelector('.spinner');
         spinner.style.display = 'none'"
        )
        return()
      }
      
      if (n_cells == 0) {
        # set validation ui
        shinyjs::runjs(
        "document.querySelector('.form-control').classList.add('is-invalid');
         document.querySelector('.shp-required').textContent = 'No planning units intersect polygon';
         document.querySelector('.progress-bar').textContent = 'Error';
         document.querySelector('.progress-bar').style.backgroundColor = '#c10000';
         const spinner = document.querySelector('.spinner');
         spinner.style.display = 'none'"
        )
        return()
      }
      
      # translate to WGS 84 for display
      shp_wgs <- sf::st_transform(shp(), crs = 4326)
      
      # update progress bar
      shinyjs::runjs(
      "document.querySelector('.progress-bar').textContent = '... Mapping Polygon';")   
      
      # update map
      map_proxy <- mapgl::maplibre_proxy("map_1-map")
      map_proxy |>
        mapgl::fit_bounds(shp_wgs) |>
        mapgl::add_fill_layer(
          id = "shp_user",
          source = shp_wgs,
          fill_outline_color = "#000",
          fill_color = "#AAA",
          fill_opacity = 0.7
        )
      
      # convert sf to geojson for order table (only need geometry)
      shp_wgs_geom_only <- shp_wgs |> dplyr::select(geometry)
      geojson_aoi(geojsonsf::sf_geojson(shp_wgs_geom_only))
      
      # update progress bar
      shinyjs::runjs(
      "document.querySelector('.progress-bar').textContent = 'Upload Complete';
       document.querySelector('.progress-bar').style.backgroundColor = '33862B';"
      )
      
      # set validation ui
      shinyjs::runjs(
      "document.querySelector('.form-control').classList.remove('is-invalid');
       document.querySelector('.shp-required').textContent = '';"
      )
      
      ## remove map spinner
      shinyjs::runjs(
       "const spinner = document.querySelector('.spinner');
        spinner.style.display = 'none'"
      )
      
    })
    
    # clear layer
    shiny::observeEvent(input$erase_shp, {
      
      # reset file input input
      shinyjs::reset("shp")
      # rest geojoson_aoi
      geojson_aoi(NULL)

      # clear layer
      map_proxy <- mapgl::maplibre_proxy("map_1-map")
      map_proxy |>
        mapgl::clear_layer("shp_user")
      
      # set validation ui
      shinyjs::runjs(
        "document.querySelector('.form-control').classList.add('is-invalid');
         document.querySelector('.shp-required').textContent = 'Required';"
      )      
    })    
    
  })
}
    
## To be copied in the UI
# mod_map_ui("map_1")
    
## To be copied in the server
# mod_map_server("map_1")
