#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shinyjs::useShinyjs(),
    # HTML 
    shiny::tags$head(
      tags$link(rel="stylesheet", type="text/css", href="www/main-styles.css")
    ),
    bslib::page_sidebar(
      id = "sitesdata",
      title = "Sites Data",
      class = "p-0",
      fillable = TRUE,
      # Side bar
      sidebar =  bslib::sidebar(
        width = "225px",
        id = "left-sidebar-menu",
        shiny::div(class = "left-sidebar-menu__links",
          # Themes ----
          shiny::div(class = "sidebar-section",
          shiny::p("Themes", class = "sidebar-section-title"),
            shiny::a(id="link_hab", href="#habitat", "Habitat"),
            shiny::a(id="link_spp", href="#species", "Species"),       
          ),
          # Weights ----
          shiny::div(class = "sidebar-section",
          shiny::p("Weights", class = "sidebar-section-title"),
          shiny::a(id="link_carbon", href="#carbon", "Carbon"),
          shiny::a(id="link_climate", href="#climate", "Climate"),
          shiny::a(id="link_climate", href="#connectivity", "Connectivity"),
          shiny::a(id="link_eservice", href="#eservice", "Ecosystem Services"),
          shiny::a(id="link_hfi", href="#pressures", "Pressures")
          ),
          # Includes ----
          shiny::div(class = "sidebar-section",
          shiny::p("Includes", class = "sidebar-section-title"),
            shiny::a(id="link_pa", href="#pa", "Protected Areas")
          )
        )
      ),
      
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          position = "right",
          width = "500px",
          mod_data_order_ui("data_order_1", product_tbl),
          mod_user_data_ui("user_data_1"),
          mod_confirm_order_ui("confirm_order_1")
        ),
        # Main content section
        shiny::div(
          shiny::hr(),
          class = "main-content",
          mod_page_home_ui("home"),
          shiny::hr(),
          
          # Data Groupings ----
          ## Habitat
          mod_data_group_ui(
            id = "data_group_habitat",
            section_id = "habitat",
            title = "Habitat",
            mod_data_card_ui("data_card_forest", "Forest"),
            mod_data_card_ui("data_card_grassland", "Grassland"),
            mod_data_card_ui("data_card_lakes", "Lakes"),
            mod_data_card_ui("data_card_wetland", "Wetland"),
            mod_data_card_ui("data_card_rivers", "Rivers"),
            mod_data_card_ui("data_card_shoreline", "Shoreline")
          ),              
          ## Species
          mod_data_group_ui(
            id = "data_group_spp",
            section_id = "species",
            title = "Species",
            mod_data_card_ui("data_card_ch", "ECCC SAR Critical Habitat"),
            mod_data_card_ui("data_card_sar", "ECCC SAR Range Map Extents"),
            mod_data_card_ui("data_card_amph", "IUCN AOH Amphibians"),
            mod_data_card_ui("data_card_bird_s1", "IUCN AOH Birds (Resident)"),
            mod_data_card_ui("data_card_bird_s2", "IUCN AOH Birds (Breeding)"),
            mod_data_card_ui("data_card_bird_s3", "IUCN AOH Birds (Non-Breeding)"),
            mod_data_card_ui("data_card_mamm", "IUCN AOH Mammals"),
            mod_data_card_ui("data_card_rept", "IUCN AOH Reptiles")
          ),
          ## Carbon
          mod_data_group_ui(
            id = "data_group_carbon",
            section_id = "carbon",
            title = "Carbon",
            mod_data_card_ui("data_card_carbon_p", "Carbon Potential"),
            mod_data_card_ui("data_card_carbon_s", "Carbon Storage")
          ),          
          ## Climate
          mod_data_group_ui(
            id = "data_group_climate",
            section_id = "climate",
            title = "Climate",
            mod_data_card_ui("data_card_climate_c", "Climate Centrality"),
            mod_data_card_ui("data_card_climate_e", "Extreme Heat Events"),
            mod_data_card_ui("data_card_climate_r", "Climate Refugia")
          ),
          ## Connectivity
          mod_data_group_ui(
            id = "data_group_connectivity",
            section_id = "connectivity",
            title = "Connectivity",
            mod_data_card_ui("data_card_connectivity", "Connectivity")
          ),
          ## Ecosystem Services
          mod_data_group_ui(
            id = "data_group_eservice",
            section_id = "eservice",
            title = "Ecosystem Services",
            mod_data_card_ui("data_card_freshw", "Freshwater Provision"),
            mod_data_card_ui("data_card_rec", "Recreation")
          ),
          ## Pressures
          mod_data_group_ui(
            id = "data_group_pressures",
            section_id = "pressures",
            title = "Pressures",
            mod_data_card_ui("data_card_hfi", "Human Foorpint Index")
          ),
          ## Protected Areas
          mod_data_group_ui(
            id = "data_group_pa",
            section_id = "pa",
            title = "Protected Areas",
            mod_data_card_ui("data_card_pa", "CPCAD")
          )
        )
        
      )
      
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  
  tags$head(
    # favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "sitesdata"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
