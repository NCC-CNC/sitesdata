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
mod_submit_server <- function(id, order_manager, user_data_manager, geojson_aoi, product_df){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    shiny::observeEvent(input$submit, {
      
      # connect to db
      transaction_db <- "C:/Github/sitesdata-backend/TEST_TransactionDB.sqlite"
      con <- DBI::dbConnect(RSQLite::SQLite(), transaction_db)
      
      # CUSTOMER ----
      ## check if email exists
      if (email_exists(con, user_data_manager()$email)) {
        ### update customer data
        update_customer(con, user_data_manager) # fct_update_customer.R
      } else {
        ### insert new customer
        DBI::dbWriteTable(con, "Customers", user_data_manager(), append = TRUE, row.names = FALSE)
      }
      
      # Order Tbl ----
      ## get customer_id
      customer_id <- DBI::dbGetQuery(con, "
      SELECT customer_id FROM Customers WHERE email = ?
      ", params = list(user_data_manager()$email)
      )
      ## insert order
      UTC <- as.character(lubridate::now(tzone = "UTC"))
      DBI::dbExecute(con, "
      INSERT INTO Orders (customer_id, order_date, geojson_aoi, order_status)
      VALUES (?, ?, ?, ?);
      ", params = list(as.numeric(customer_id), UTC, geojson_aoi(), "pending")
      )
      
      # OrderDetails Tbl ----
      ## get order_id
      order_id <- DBI::dbGetQuery(con, "
      SELECT order_id FROM Orders WHERE order_date = ?
      ", params = list(UTC)
      )
      ## get order details (products user selected)
      order_details <- order_manager() |>
        dplyr::filter(Order == TRUE) |>
        dplyr::mutate(order_id = as.numeric(order_id)) |>
        dplyr::left_join(product_df, by = c("Product" = "legend_name")) |>
        dplyr::select(order_id, product_id)
      ## insert to order items
      DBI::dbAppendTable(con, "OrderDetails", order_details)
      
      # Disconnect from DB
      DBI::dbDisconnect(con)
      
    })
})}
    
## To be copied in the UI
# mod_submit_ui("submit_1")
    
## To be copied in the server
# mod_submit_server("submit_1")
