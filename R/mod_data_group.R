#' data_group UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_group_ui <- function(id, section_id, title, ...) {
  ns <- NS(id)
  # Capture all data_card_ui(...) calls passed through ...
  data_cards <- list(...)  
  shiny::tagList(
    shiny::div(
      id = "data-group",
      shiny::p(title, id = section_id, class = "data-group-title"),
      bslib::layout_columns(
        col_widths = 12,
        do.call(tagList, data_cards)
      )
    )   
  )
}
    
#' data_group Server Functions
#'
#' @noRd 
mod_data_group_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_data_group_ui("data_group_1")
    
## To be copied in the server
# mod_data_group_server("data_group_1")
