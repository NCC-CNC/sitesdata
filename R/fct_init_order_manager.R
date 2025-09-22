#' init_order_manager 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
init_order_manager <- function(product_tbl) {
  
  # Fetch legend names from Product table
  legend_names <- product_tbl |>
    dplyr::pull(legend_name)
  
  # Structure order manager
  tibble::tibble(
    `Product` = legend_names,
    `Order` = rep(FALSE, nrow(product_tbl))
  )
  
}
