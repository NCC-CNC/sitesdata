app_global <- quote({
  
  # Set upload size to 100mb max
  options(shiny.maxRequestSize = 100 * 1024^2)
  
  # Configure app set up
  source("R/fct_setup.R")
  configs <- setup()
  app_db <- configs$db$transaction_db
  
  # Read-in product table
  con <- DBI::dbConnect(RSQLite::SQLite(), app_db)
  product_tbl <- DBI::dbReadTable(con, "Products")
  DBI::dbDisconnect(con)  

  # NCC grid (all call values are 1)
  ncc_1km <- terra::rast(system.file("app", "const.tif", package = "sitesdata"))
  
})