#' data_order UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_order_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyWidgets::virtualSelectInput(
      inputId = ns("data_order"),
      label = NULL,
      choices = list(
        "Species" = c(
          "SAR Critical Habitat", "SAR Range Map Extents", 
          "AOH Amphibians", "AOH Birds", "AOH Mammals", "AOH Reptiles"
          ),
        "Habitat" = c(
          "Grassland", "Forest", "Wetlands"
        )
      ),
      showValueAsTags = TRUE,
      search = FALSE,
      multiple = TRUE
  ),
  
  shiny::textInput(
    inputId = ns("firstname"),
    label = "First Name",
    placeholder = "Dan"
  ),
  shiny::textInput(
    inputId = ns("last"),
    label = "Last Name",
    placeholder = "Wismer"
  ),
  shiny::textInput(
    inputId = ns("email"),
    label = "Email",
    placeholder = "Dan.Wismer@natureconservancy.ca"
  ),
  shiny::actionButton(
    inputId = ns("submit"),
    label = "Submit"
  )
  
 )
}
    
#' data_order Server Functions
#'
#' @noRd 
mod_data_order_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_data_order_ui("data_order_1")
    
## To be copied in the server
# mod_data_order_server("data_order_1")
