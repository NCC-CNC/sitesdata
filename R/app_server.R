#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Init data ----
  order_manager <- shiny::reactiveVal(init_order_manager(product_tbl))
  user_data_manager <- shiny::reactiveVal(init_user_data())
  geojson_aoi <- shiny::reactiveVal(NULL)
  
  # Data Order ----
  mod_data_order_server("data_order_1", order_manager)
  
  # Map and User AOI ----
  mod_map_server("map_1", geojson_aoi)
  
  # User Data ----
  mod_user_data_server("user_data_1", user_data_manager)
  
  # Confirm Order ----
  mod_confirm_order_server("confirm_order_1", order_manager, user_data_manager, geojson_aoi, product_tbl)
  
  # Submit ----
  mod_submit_server("submit_1", app_db, order_manager, user_data_manager, geojson_aoi, product_tbl)
  
  # Enable/Disable Submit ----
  observe({
    if(
      # user data
      all(!is.na(user_data_manager()) & user_data_manager() != "") &&
      # order manager
      any(order_manager()$Order) &&
      # geojson_aoi
      !is.null(geojson_aoi())
    ) {
      shinyjs::enable("confirm_order_1-confirm_order")
    } else {
      shinyjs::disable("confirm_order_1-confirm_order")
    }
  })
  
  # Product cards ---
  
  ## Habitat
  mod_data_card_server("data_card_forest", order_manager, product = "Forest")
  mod_data_card_server("data_card_grassland", order_manager, product = "Grassland")
  mod_data_card_server("data_card_lakes", order_manager, product = "Lakes")
  mod_data_card_server("data_card_wetland", order_manager, product = "Wetland")
  mod_data_card_server("data_card_rivers", order_manager, product = "Rivers")
  mod_data_card_server("data_card_shoreline", order_manager, product = "Shoreline")
  
  ## Species
  mod_data_card_server("data_card_ch", order_manager, product = "ECCC SAR Critical Habitat")
  mod_data_card_server("data_card_sar", order_manager, product = "ECCC SAR Range Map Extents")
  mod_data_card_server("data_card_amph", order_manager, product = "IUCN AOH Amphibians")
  mod_data_card_server("data_card_bird_s1", order_manager, product = "IUCN AOH Birds (Resident)")
  mod_data_card_server("data_card_bird_s2", order_manager, product = "IUCN AOH Birds (Breeding)")
  mod_data_card_server("data_card_bird_s3", order_manager, product = "IUCN AOH Birds (Non-Breeding)")
  mod_data_card_server("data_card_mamm", order_manager, product = "IUCN AOH Mammals")
  mod_data_card_server("data_card_rept", order_manager, product = "IUCN AOH Reptiles")
  
  ## Carbon
  mod_data_card_server("data_card_carbon_p", order_manager, product = "Carbon Potential")
  mod_data_card_server("data_card_carbon_s", order_manager, product = "Carbon Storage")
  
  ## Climate
  mod_data_card_server("data_card_climate_c", order_manager, product = "Climate Centrality")
  mod_data_card_server("data_card_climate_e", order_manager, product = "Extreme Heat Events")
  mod_data_card_server("data_card_climate_r", order_manager, product = "Climate Refugia")
  
  ## Connectivity
  mod_data_card_server("data_card_connectivity", order_manager, product = "Connectivity")
  
  ## EServices
  mod_data_card_server("data_card_freshw", order_manager, product = "Freshwater Provision")
  mod_data_card_server("data_card_rec", order_manager, product = "Recreation")
  
  ## Pressures
  mod_data_card_server("data_card_hfi", order_manager, product = "Human Foorpint Index")  
  
  ## Protected Areas
  mod_data_card_server("data_card_pa", order_manager, product = "CPCAD")    
  
}
