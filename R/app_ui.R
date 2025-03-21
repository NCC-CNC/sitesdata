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
    # HTML 
    shiny::tags$head(
      tags$link(rel="stylesheet", type="text/css", href="www/main-styles.css"),
      # Add smooth scrolling behavior
      tags$script(HTML("
        document.addEventListener('DOMContentLoaded', function() {
          document.querySelectorAll('.sidebar-menu__links a').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
              e.preventDefault();
              const targetId = this.getAttribute('href').substring(1);
              document.getElementById(targetId).scrollIntoView({
                behavior: 'smooth'
              });
            });
          });
        });
      "))
    ),
    bslib::page_sidebar(
      id = "sitesdata",
      title = "Sites Data",
      class = "p-0",
      fillable = TRUE,
      # Side bar
      sidebar =  bslib::sidebar(
        id = "left-sidebar-menu",
        shiny::div(class = "left-sidebar-menu__links",
          shiny::a(id="link_home", href="#home_section", "Top of Page"),
          shiny::a(id="link_spp", href="#section_spp", "Species"),
          shiny::a(id="link_hab", href="#section_hab", "Habitat"),
          shiny::a(id="link_climate", href="#section_climate", "Climate"),
          shiny::a(id="link_eservice", href="#section_eservice", "Ecosystem Services"),
          shiny::a(id="link_cons", href="#section_parks", "Conservation"),
          shiny::a(id="link_hfi", href="#section_pressures", "Pressures"),
          shiny::a(id="link_hfi", href="#section_acknowledgments", "Details"),
          shiny::a(id="link_hfi", href="#section_acknowledgments", "Acknowledgments"),
          # shiny::actionLink(inputId = "link_wtw", label = "Where To Work")
        )
      ),
      
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          position = "right",
          width = "375px",
          # shiny::p("Data Order", class = "title-data-order"),
          mod_data_order_ui("data_order_1"),
          mod_user_data_ui("user_data_1"),
          mod_submit_ui("submit_1")
        ),
        # Main content section
        shiny::div(
          shiny::hr(),
          class = "main-content",
          mod_page_home_ui("home"),
          shiny::hr(),
          mod_data_section_spp_ui("data_section_spp")
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
