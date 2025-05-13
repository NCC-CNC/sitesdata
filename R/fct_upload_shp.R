#' upload_shp 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
upload_shp <- function(user_files) {
  # Get input file paths
  infiles <- user_files$datapath
  dir <- unique(dirname(infiles))
  outfiles <- file.path(dir, user_files$name)
  name <- strsplit(user_files$name[1], "\\.")[[1]][1]  # strip base name
  
  # Move uploaded files to match original filenames
  purrr::walk2(infiles, outfiles, ~file.rename(.x, .y))
  
  # Try reading the shapefile
  shp_path <- file.path(dir, paste0(name, ".shp"))
  x <- try(sf::read_sf(shp_path), silent = TRUE)
  
  # Return NULL on error
  if (inherits(x, "try-error")) {
    return(NULL)
  } else {
    return(x)
  }
}
