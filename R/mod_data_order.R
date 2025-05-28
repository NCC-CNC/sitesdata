#' data_order UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_order_ui <- function(id, product_df) {
  ns <- NS(id)
  
  # Species
  product_species <- product_df |>
    dplyr::filter(category == "species") |>
    dplyr::pull(app_name)
  
  # Climate
  product_climate <- product_df |>
    dplyr::filter(category == "climate") |>
    dplyr::pull(app_name)
  
  # Protected Areas
  product_pa <- product_df |>
    dplyr::filter(category == "protected areas") |>
    dplyr::pull(app_name)  
  
  # Virtual Selection
  tagList(
    shinyWidgets::virtualSelectInput(
      inputId = ns("data_order"),
      label = shiny::p(bsicons::bs_icon("cart4", size = "1.2em"), "Data Order", class = "data-order-label"),
      choices = list(
        "Species" = product_species,
        "Climate" = product_climate,
        "Protected Areas" = product_pa
      ),
      showValueAsTags = TRUE,
      search = FALSE,
      multiple = TRUE
  )
 )
}
    
#' data_order Server Functions
#'
#' @noRd 
mod_data_order_server <- function(id, order_manager){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    
    observeEvent(input$data_order, {
      current_data <- order_manager()  # Retrieve the current tibble
      current_data <- dplyr::mutate(current_data, Order = Product %in% input$data_order)  
      order_manager(current_data) 
    }, ignoreInit = TRUE, ignoreNULL = FALSE)
    
    observeEvent(order_manager(), {
      
      virtual_select <- order_manager() |>
        dplyr::filter(Order == TRUE) |>
        dplyr::pull(Product)
      
      # update virtual selection:
      shinyWidgets::updateVirtualSelect(
        inputId = "data_order",
        selected = virtual_select
      )
      
    }, ignoreInit = TRUE)
    
  })
}
    
## To be copied in the UI
# mod_data_order_ui("data_order_1")
    
## To be copied in the server
# mod_data_order_server("data_order_1")
