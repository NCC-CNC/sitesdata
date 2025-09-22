#' confirm_order UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_confirm_order_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tagList(
      shiny::actionButton(ns("confirm_order"), "Confirm Order")
    )
  )
}
    
#' confirm_order Server Functions
#'
#' @noRd 
mod_confirm_order_server <- function(id, order_manager, user_data_manager, geojson_aoi, product_tbl){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    observeEvent(input$confirm_order, {
      
      # enable submit button
      shinyjs::enable("submit_1-submit")
      
      # build order table for display
      order_table_df <- order_manager() |>
        dplyr::filter(Order == TRUE) |>
        dplyr::left_join(product_tbl, by = c("Product" = "legend_name")) |>
        dplyr::select(type, category, Product) |>
        dplyr::rename(
          `Type` = type,
          `Category` = category,
          `Product` = Product
        )
      
      # DT table
      output$order_table <- DT::renderDT({
        DT::datatable(
          order_table_df,
          extensions = 'FixedHeader',
          options = list(
            dom = 't',
            paging = FALSE,
            ordering = FALSE,
            columnDefs = list(list(className = 'dt-center', targets = "_all")),
            autoWidth = FALSE,
            scrollX = FALSE,
            scrollY = "300px",
            fixedHeader = TRUE
          )
        )
      })
      
      # Confirm order modal 
      shiny::showModal(
        shiny::modalDialog(
        title = "Confrim and submit order:",
        shiny::p(
          class="confrim-customer", 
          paste(user_data_manager()$first_name, user_data_manager()$last_name, "|",  user_data_manager()$email)
        ),
        DT::DTOutput(ns("order_table")),
        easyClose = TRUE,
        footer = shiny::tagList(
          shiny::div(class="order-submitted-wrapper", 
          shiny::tags$p(class="order-submitted", "Order Submitted!"),
          shiny::tags$p(class="order-confrim-email", "Confrimation will be sent to:"),
          shiny::tags$p(class="order-confrim-email" , user_data_manager()$email)
          ),
          mod_submit_ui("submit_1"),
          shiny::span(shiny::modalButton("Cancel"))),
        size = "l"
      ))
    })
 
  })
}
    
## To be copied in the UI
# mod_confirm_order_ui("confirm_order_1")
    
## To be copied in the server
# mod_confirm_order_server("confirm_order_1")
