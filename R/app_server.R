#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # set upload size to 100mb max
  options(shiny.maxRequestSize = 100 * 1024^2)
  
  # order manager
  order_manager <- shiny::reactiveVal(init_order_manager())
  
  mod_data_card_server("data_card_ch", order_manager, product = "SAR Critical Habitat")
  mod_data_card_server("data_card_sar", order_manager, product = "SAR Range Map Extents")
  mod_data_card_server("data_card_amph", order_manager, product = "AOH Amphibians")
  mod_data_card_server("data_card_bird", order_manager, product = "AOH Birds")
  mod_data_card_server("data_card_mamm", order_manager, product = "AOH Mammals")
  mod_data_card_server("data_card_rept", order_manager, product = "AOH Reptiles")
  mod_data_order_server("data_order_1", order_manager)
  
  mod_map_server("map_1")
}
