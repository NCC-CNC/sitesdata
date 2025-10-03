#' page_home UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_page_home_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::div(id = "home_section",
    bslib::layout_columns(
      col_widths = 12,
      bslib::card(
        id = "home_card",
        shiny::p("Sites Data", class = "card-title"),
        shiny::p(shinipsum::random_text(nwords = 50), class = "card-description")
      )
    ),
    bslib::layout_column_wrap(
      width = 1/3,
      bslib::card(
        shiny::p("Themes", class = "card-title"),
        shiny::p(shinipsum::random_text(nwords = 25), class = "card-description")
      ),
      bslib::card(
        shiny::p("Weights", class = "card-title"),
        shiny::p(shinipsum::random_text(nwords = 25), class = "card-description")
      ),
      bslib::card(
        shiny::p("Includes", class = "card-title"),
        shiny::p(shinipsum::random_text(nwords = 25), class = "card-description")
      )
  )
)
)}
    
#' page_home Server Functions
#'
#' @noRd 
mod_page_home_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_page_home_ui("page_home_1")
    
## To be copied in the server
# mod_page_home_server("page_home_1")
