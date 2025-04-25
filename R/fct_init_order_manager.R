#' init_order_manager 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
init_order_manager <- function(product_df) {
  
  app_names <- product_df |>
    dplyr::pull(app_name)
  
  tibble::tibble(
    `Product` = app_names,
    `Order` = rep(FALSE, length(products))
  )
}
