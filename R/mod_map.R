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
    mapgl::maplibreOutput(ns("map"), height = "200px"),
    bslib::layout_columns(
      class = "shp-input-row",
      col_widths = c(10,2),
      shiny::p(bsicons::bs_icon("upload", fill = "primary"), "Upload Polygon"),
      shiny::actionButton("erase_shp", bsicons::bs_icon("eraser", fill = "primary")),
    ),
    shiny::div(class = "shp-input",
    shiny::fileInput(ns("file"), label = NULL, accept = c(".csv", ".xlsx"))
    )
  )
}
    
#' map Server Functions
#'
#' @noRd 
mod_map_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$map <- mapgl::renderMaplibre({
      mapgl::maplibre(style = mapgl::carto_style("positron"))
    })
 
  })
}
    
## To be copied in the UI
# mod_map_ui("map_1")
    
## To be copied in the server
# mod_map_server("map_1")
