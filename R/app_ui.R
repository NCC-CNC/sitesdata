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
      tags$link(rel="stylesheet", type="text/css", href="www/main-styles.css")
    ),
    bslib::page_sidebar(
      id = "sitesdata",
      title = "Sites Data",
      #side bar
      sidebar =  bslib::sidebar(
        id = "sidebar-menu",
        shiny::div(class="sidebar-menu__links",
          shiny::actionLink(inputId = "link_home", label = "Home"),
          shiny::actionLink(inputId = "link_spp", label = "Species"),
          shiny::actionLink(inputId = "link_hab", label = "Habitat"),
          shiny::actionLink(inputId = "link_climate", label = "Climate"),
          shiny::actionLink(inputId = "link_eservice", label = "Ecosystem Services"),
          shiny::actionLink(inputId = "link_threats", label = "Threats"),
          shiny::actionLink(inputId = "link_wtw", label = "Where To Work")
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
