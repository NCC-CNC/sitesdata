#' Initialize Order Manager
#'
#' Creates an order management tibble from the product table, including only 
#' active and external (public) products. The returned tibble contains one row 
#' per product, with a logical column for tracking order selection.
#'
#' @param product_tbl A `data.frame`. `product_tbl` comes from the `Product` table 
#'   from the `transactional.sqlite` database. Must contain at least the 
#'   following columns:
#'   \describe{
#'     \item{active}{Logical. Whether the product is active.}
#'     \item{external}{Logical. Whether the product is external (public).}
#'     \item{legend_name}{Character. The display name of the product.}
#'   }
#'
#' @return A tibble with two columns:
#' \describe{
#'   \item{Product}{The `legend_name` values of active, external products.}
#'   \item{Order}{Logical, initialized to `FALSE` for all products.}
#' }
#'
#' @noRd
init_order_manager <- function(product_tbl) {
  
  # Filter for active and external (public) products only
  active_external_products <- product_tbl |>
    dplyr::filter(active == TRUE & external == TRUE)
  
  # Fetch legend names
  legend_names <- active_external_products  |>
    dplyr::pull(legend_name)
  
  # Structure order manager
  tibble::tibble(
    `Product` = legend_names,
    `Order` = rep(FALSE, nrow(active_external_products))
  )
}
