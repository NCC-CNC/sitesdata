#' user_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_user_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    
    bslib::navset_card_underline(
      bslib::nav_panel(
        title = "Name", 
        shiny::textInput(
          inputId = ns("firstname"),
          label = "First Name",
          placeholder = "Dan"
        ),
        shiny::textInput(
          inputId = ns("lastname"),
          label = "Last Name",
          placeholder = "Wismer"
        )
      ),
      bslib::nav_panel(
        title = "Email",
        shiny::textInput(
          inputId = ns("email"),
          label = "Email",
          placeholder = "Dan.Wismer@natureconservancy.ca"
        )
      ),
      bslib::nav_panel(title = "Affiliation", p("Affiliation")),
      bslib::nav_panel(title = "Map", mod_map_ui("map_1"))
    )
  )
}
    
#' user_data Server Functions
#'
#' @noRd 
mod_user_data_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_user_data_ui("user_data_1")
    
## To be copied in the server
# mod_user_data_server("user_data_1")
