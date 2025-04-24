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
    mapgl::maplibreOutput(ns("map"), height = "250px"),
    bslib::layout_columns(
      class = "shp-input-row",
      col_widths = c(10,2),
      shiny::p(bsicons::bs_icon("upload", fill = "primary"), "Upload Polygon"),
      shiny::actionButton(ns("erase_shp"), bsicons::bs_icon("eraser", fill = "primary")),
    ),
    shiny::div(class = "shp-input",
    shiny::fileInput(
      inputId = ns("shp"), 
      label = NULL, 
      multiple = TRUE,
      accept = c(".shp", ".shx", ".dbf", ".prj", ".sbn", ".sbx", ".cpg")
      )
    )
  )
}
    
#' map Server Functions
#'
#' @noRd 
mod_map_server <- function(id, geojson_aoi){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
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
      }
    })
    
    # clear layer
    shiny::observeEvent(input$erase_shp, {
      # reset file input input
      shinyjs::reset("map_1-shp", asis = TRUE)
      # clear layer
      map_proxy <- mapgl::maplibre_proxy("map_1-map")
      map_proxy |>
        mapgl::clear_layer("shp_user")
    })    
    
  })
}
    
## To be copied in the UI
# mod_map_ui("map_1")
    
## To be copied in the server
# mod_map_server("map_1")
