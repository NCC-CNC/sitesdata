#' data_section_spp UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_section_spp_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::div(id = "section_spp",
    shiny::p("Species", class = "section-title"),
    bslib::layout_columns(
      col_widths = 12,
      bslib::card(
        mod_data_card_ui("data_card_ch", "ECCC SAR Critical Habitat"),
        mod_data_card_ui("data_card_sar", "ECCC SAR Range Map Extents"),
        mod_data_card_ui("data_card_amph", "IUCN AOH Amphibians"),
        mod_data_card_ui("data_card_bird_s1", "IUCN AOH Birds (Resident)"),
        mod_data_card_ui("data_card_bird_s2", "IUCN AOH Birds (Breeding)"),
        mod_data_card_ui("data_card_bird_s3", "IUCN AOH Birds (Non-Breeding)"),
        mod_data_card_ui("data_card_mamm", "IUCN AOH Mammals"),
        mod_data_card_ui("data_card_rept", "IUCN AOH Reptiles"),
      )
    )
  )
  )  
}
    
#' data_section_spp Server Functions
#'
#' @noRd 
mod_data_section_spp_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_data_section_spp_ui("data_section_spp_1")
    
## To be copied in the server
# mod_data_section_spp_server("data_section_spp_1")
