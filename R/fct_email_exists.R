#' email_exists 
#'
#' @description Check if a customer email already exists in the dim_customer table.
#'
#' @return `TRUE` or `FALSE`
#'
#' @noRd
email_exists <- function(con, email) {
  result <- DBI::dbGetQuery(con, "
    SELECT EXISTS (
      SELECT 1 FROM Customers WHERE email = ?
    ) AS email_found
  ", params = list(email))
  
  return(as.logical(result$email_found))
}
