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
        title =  bslib::tooltip(
          shiny::span(
          bsicons::bs_icon("info-circle"),
          "Map"
          ),
          "tooltip message",
          placement = "left"
        ), mod_map_ui("map_1")),
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
      bslib::nav_panel(
        title = "Affiliation", 
       shiny::radioButtons(
       inputId = ns("affiliation"),
       label = NULL,
       selected = character(0),
       choices = c("Nature Conservancy of Canada", "Other Conservation NGO", "Government", "Acemedimc", "Industry"),
     ))
    )
  )
}
    
#' user_data Server Functions
#'
#' @noRd 
mod_user_data_server <- function(id, user_data_manager){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # First name
    observeEvent(input$firstname, {
      current_data <- user_data_manager()  # Retrieve the current tibble
      current_data <- dplyr::mutate(current_data, first_name = input$firstname)  
      user_data_manager(current_data) 
    }, ignoreInit = TRUE, ignoreNULL = FALSE)
    
    # Last name
    observeEvent(input$lastname, {
      current_data <- user_data_manager()  # Retrieve the current tibble
      current_data <- dplyr::mutate(current_data, last_name = input$lastname)  
      user_data_manager(current_data) 
    }, ignoreInit = TRUE, ignoreNULL = FALSE)
    
    # Email
    observeEvent(input$email, {
      current_data <- user_data_manager()  # Retrieve the current tibble
      current_data <- dplyr::mutate(current_data, email = tolower(input$email))  
      user_data_manager(current_data) 
    }, ignoreInit = TRUE, ignoreNULL = FALSE)
    
    # Affiliation
    observeEvent(input$affiliation, {
      current_data <- user_data_manager()  # Retrieve the current tibble
      current_data <- dplyr::mutate(current_data, affiliation = input$affiliation)  
      user_data_manager(current_data) 
    }, ignoreInit = TRUE, ignoreNULL = FALSE)    
 
  })
}
    
## To be copied in the UI
# mod_user_data_ui("user_data_1")
    
## To be copied in the server
# mod_user_data_server("user_data_1")
