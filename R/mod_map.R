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
    shiny::textOutput(ns("shp_display_name"), inline = TRUE),
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
    
    # Get user polygon
    path <- reactive({input$shp})
    shp <- upload_shp(path)
    shp_name <- reactive({ path()$name[grepl("\\.shp$", path()$name)] })
    
    # add layer 
    shiny::observeEvent(path(), {

      if (shiny::isTruthy(shp())) {
        # translate to WGS 84 for display
        shp_display <- sf::st_transform(shp(), crs=4326)

        # update map
        map_proxy <- mapgl::maplibre_proxy("map_1-map")
         map_proxy |>
           mapgl::fit_bounds(shp_display) |>
           mapgl::add_fill_layer(
             id = "shp_user",
             source = shp_display,
             fill_outline_color = "#000",
             fill_color = "#AAA",
             fill_opacity = 0.7
           )
         
         # convert to geojson for order
         geojson_text <- sf::st_as_text(sf::st_geometry(shp()))
         geojson_aoi(geojson_text)
         
         # set validation ui
         shinyjs::runjs(
           "document.querySelector('.form-control').classList.remove('is-invalid');
            document.querySelector('.shp-required').textContent = '';"
         )
      }
    })
    
    # display shapefile name
    shiny::observeEvent(shp_name(), {
      output$shp_display_name <- shiny::renderText({
        shp_name()
      })
    })
    
    # clear layer
    shiny::observeEvent(input$erase_shp, {
      # reset file input input
      shinyjs::reset("shp")
      # rest geojoson_aoi
      geojson_aoi(NULL)
      # clear shp name
      output$shp_display_name <- shiny::renderText({""})
      
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
