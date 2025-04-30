app_global <- quote({
  
  # product table
  product_df <- read.csv(system.file("app", "product.csv", package = "sitesdata"))
  
})