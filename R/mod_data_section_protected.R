#' data_section_protected UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_section_protected_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Protected
    shiny::div(
      id = "section_pa",
      shiny::p("Protected Areas", class = "section-title"),
      bslib::layout_columns(
        col_widths = 12,
        bslib::card(
          mod_data_card_ui("data_card_cpcad", "CPCAD")
        )
      )
    ) 
  )
}
    
#' data_section_protected Server Functions
#'
#' @noRd 
mod_data_section_protected_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_data_section_protected_ui("data_section_protected_1")
    
## To be copied in the server
# mod_data_section_protected_server("data_section_protected_1")
