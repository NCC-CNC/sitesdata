#' setup 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
setup <- function() {
  
  toml <- system.file("app", "setup.toml", package = "sitesdata")
  configs <- RcppTOML::parseTOML(toml)
  is_docker <- file.exists("/.dockerenv")
  
  if (is_docker) {
    print ("docker")
    db <- configs$docker$db
  } else {
    print("local")
    db <- configs$local$db
  }
  
  return(list(
    db = db
    )
  )
}
