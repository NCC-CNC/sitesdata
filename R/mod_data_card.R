#' data_card UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_card_ui <- function(id, data_title) {
  ns <- NS(id)
  tagList(
    shiny::div(id = "data_card",
     bslib::layout_columns(
       col_widths = 12,
         bslib::card(
           bslib::layout_columns(
             class = "data-columns",
             col_widths = c(2,8,2),
             shiny::p(data_title, class = "data-title"),
             shiny::p(shinipsum::random_text(nwords = 25), class = "data-short-description"),
             shiny::div(class = "data-order-checkbox",
             shiny::checkboxInput(ns("checkbox"), "Add to Order"))
           ),
          bslib::layout_columns(
            col_widths = 12,
            bslib::accordion(
              open = FALSE,
              id = "data-details",
              bslib::accordion_panel(
                title = "Details",
                value = "details-panel",
                shiny::p(shinipsum::random_text(nwords = 25), class = "data-details")
              )
            )
         )
     )
     )
    )
  )}
    
#' data_card Server Functions
#'
#' @noRd 
mod_data_card_server <- function(id, order_manager, product){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    

    shiny::observeEvent(order_manager(), {
      
      # Get TRUE orders
      virtual_select <- order_manager() |>
        dplyr::filter(Product == product) |>
        dplyr::pull(Order)
      
      # update virtual selection:
      shiny::updateCheckboxInput(
        inputId = "checkbox",
        value = virtual_select
      )
      
    }, ignoreInit = TRUE)
    
    
    shiny::observeEvent(input$checkbox, {
      current_data <- order_manager()  # Retrieve the current tibble
      current_data$Order[current_data$Product == product] <- input$checkbox  
      order_manager(current_data)  # Save the modified tibble back to reactiveVal
    }, ignoreInit = TRUE)
    
  })
}
    
## To be copied in the UI
# mod_data_card_ui("data_card_1")
    
## To be copied in the server
# mod_data_card_server("data_card_1")
