#' submit UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_submit_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::actionButton(ns("submit"), "Submit")
  )
}
    
#' submit Server Functions
#'
#' @noRd 
mod_submit_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_submit_ui("submit_1")
    
## To be copied in the server
# mod_submit_server("submit_1")
