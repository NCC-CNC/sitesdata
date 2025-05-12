app_global <- quote({
  
  # product table
  product_df <- read.csv(system.file("app", "product.csv", package = "sitesdata"))
  
  # NCC grid (all call values are 1)
  ncc_1km <- terra::rast(system.file("app", "const.tif", package = "sitesdata"))
  
})