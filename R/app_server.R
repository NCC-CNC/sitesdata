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
  order_manager <- shiny::reactiveVal(init_order_manager(product_df))
  # user data 
  user_data_manager <- shiny::reactiveVal(init_user_data())
  # geojson aoi
  geojson_aoi <- shiny::reactiveVal(NULL)
  
  # product cards
  ## species
  mod_data_card_server("data_card_ch", order_manager, product = "SAR Critical Habitat")
  mod_data_card_server("data_card_sar", order_manager, product = "SAR Range Map Extents")
  mod_data_card_server("data_card_amph", order_manager, product = "AOH Amphibians")
  mod_data_card_server("data_card_bird_s1", order_manager, product = "AOH Birds (Resident)")
  mod_data_card_server("data_card_bird_s2", order_manager, product = "AOH Birds (Breeding)")
  mod_data_card_server("data_card_bird_s3", order_manager, product = "AOH Birds (Non-Breeding)")
  mod_data_card_server("data_card_mamm", order_manager, product = "AOH Mammals")
  mod_data_card_server("data_card_rept", order_manager, product = "AOH Reptiles")
  ## climate
  mod_data_card_server("data_card_climate_c", order_manager, product = "Climate Centrality")
  mod_data_card_server("data_card_climate_e", order_manager, product = "Extreme Heat Events")
  mod_data_card_server("data_card_climate_r", order_manager, product = "Climate Refugia")
  ## protected areas
  mod_data_card_server("data_card_cpcad", order_manager, product = "CPCAD")
  
  # data order
  mod_data_order_server("data_order_1", order_manager)
  
  # map and user aoi
  mod_map_server("map_1", geojson_aoi)
  
  # user data
  mod_user_data_server("user_data_1", user_data_manager)
  
  # submit
  mod_submit_server("submit_1", order_manager, user_data_manager, geojson_aoi, product_df)
  
  # enable/disable submit
  observe({
    if(
      # user data
      all(!is.na(user_data_manager()) & user_data_manager() != "") &&
      # order manager
      any(order_manager()$Order) &&
      # geojson_aoi
      !is.null(geojson_aoi())
    ) {
      shinyjs::enable("submit_1-submit")
    } else {
      shinyjs::disable("submit_1-submit")
    }
  })
  
}
