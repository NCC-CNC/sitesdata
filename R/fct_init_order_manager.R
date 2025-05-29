#' init_order_manager 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
init_order_manager <- function(product_df) {
  
  legend_names <- product_df |>
    dplyr::pull(legend_name)
  
  tibble::tibble(
    `Product` = legend_names,
    `Order` = rep(FALSE, nrow(product_df))
  )
}
