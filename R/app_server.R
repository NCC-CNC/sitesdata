#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # set upload size to 100mb max
  options(shiny.maxRequestSize = 100 * 1024^2)
  
  # product table
  dim_product <- read.csv(file.path("inst", "app", "csv", "dim_product.csv"))
  # order manager
  order_manager <- shiny::reactiveVal(init_order_manager(dim_product))
  # user data 
  user_data_manager <- shiny::reactiveVal(init_user_data())
  # geojson aoi
  geojson_aoi <- shiny::reactiveVal(NA_character_)
  
  # product cards
  mod_data_card_server("data_card_ch", order_manager, product = "SAR Critical Habitat")
  mod_data_card_server("data_card_sar", order_manager, product = "SAR Range Map Extents")
  mod_data_card_server("data_card_amph", order_manager, product = "AOH Amphibians")
  mod_data_card_server("data_card_bird", order_manager, product = "AOH Birds")
  mod_data_card_server("data_card_mamm", order_manager, product = "AOH Mammals")
  mod_data_card_server("data_card_rept", order_manager, product = "AOH Reptiles")
  mod_data_order_server("data_order_1", order_manager)
  
  # map and user aoi
  mod_map_server("map_1", geojson_aoi)
  
  # user data
  mod_user_data_server("user_data_1", user_data_manager)
  
  # submit
  mod_submit_server("submit_1", order_manager, user_data_manager, geojson_aoi)
}
