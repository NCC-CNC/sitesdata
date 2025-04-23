#' init_order_manager 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
init_order_manager <- function(dim_products) {
  
  app_names <- dim_products |>
    dplyr::pull(app_name)
  
  tibble::tibble(
    `Product` = app_names,
    `Order` = rep(FALSE, length(products)),
    `Path` = rep("", length(products)),
  )
}
