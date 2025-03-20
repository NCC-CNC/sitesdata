#' init_order_manager 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
init_order_manager <- function() {
  
  products <- c(
    "SAR Critical Habitat", "SAR Range Map Extents", 
    "AOH Amphibians", "AOH Birds", "AOH Mammals", "AOH Reptiles"
  )
  
  tibble::tibble(
    `Product` = products,
    `Order` = rep(FALSE, length(products)),
    `Path` = rep("", length(products)),
  )
}
