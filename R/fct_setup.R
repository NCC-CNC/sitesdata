#' setup 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
setup <- function() {
  
  toml <- "setup.toml"
  configs <- RcppTOML::parseTOML(toml)
  is_docker <- file.exists("/.dockerenv")
  
  if (is_docker) {
    db <- configs$docker$db
  } else {
    db <- configs$local$db
  }
  
  return(list(
    db = db
    )
  )
}
