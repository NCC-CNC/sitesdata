#' data_section_climate UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_section_climate_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # CLIMATE
    shiny::div(
      id = "section_climate",
      shiny::p("Climate", class = "section-title"),
      bslib::layout_columns(
        col_widths = 12,
        bslib::card(
          mod_data_card_ui("data_card_climate_c", "Climate Centrality"),
          mod_data_card_ui("data_card_climate_e", "Extreme Heat Events"),
          mod_data_card_ui("data_card_climate_r", "Climate Refugia")
         )
       )
    )
  )
}
    
#' data_section_climate Server Functions
#'
#' @noRd 
mod_data_section_climate_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
  })
}
    
## To be copied in the UI
# mod_data_section_climate_ui("data_section_climate_1")
    
## To be copied in the server
# mod_data_section_climate_server("data_section_climate_1")
