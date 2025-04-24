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
mod_submit_server <- function(id, order_manager, user_data_manager, geojson_aoi){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    shiny::observeEvent(input$submit, {
      
      browser()
      
      # connect to db
      test_db_path <- "C:/Github/sitesdata-backend/test-db.sqlite"
      con <- DBI::dbConnect(RSQLite::SQLite(), test_db_path)
      
      # DIM_CUSTOMER ----
      ## check if email exists
      if (email_exists(con, user_data_manager()$email)) {
        ### update customer data
        update_customer(con, user_data_manager) # fct_update_customer.R
      } else {
        ### insert new customer
        DBI::dbWriteTable(con, "dim_customer", user_data_manager(), append = TRUE, row.names = FALSE)
      }
      
      # DIM_ORDER ----
      ## get customer_id
      customer_id <- DBI::dbGetQuery(con, "
      SELECT customer_id FROM dim_customer WHERE email = ?
      ", params = list(user_data_manager()$email)
      )
      
      ## insert order
      UTC <- as.character(lubridate::now(tzone = "UTC"))
      DBI::dbExecute(con, "
      INSERT INTO fact_order (customer_id, order_date, geojson_aoi)
      VALUES (?, ?, ?);
      ", params = list(as.numeric(customer_id), UTC, geojson_aoi())
      )
    })
})}
    
## To be copied in the UI
# mod_submit_ui("submit_1")
    
## To be copied in the server
# mod_submit_server("submit_1")
