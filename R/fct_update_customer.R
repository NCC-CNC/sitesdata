#' update_customer 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
update_customer <- function(con, user_data_manager) {
  DBI::dbExecute(con, "
    UPDATE Customers
    SET 
      first_name = ?,
      last_name = ?,
      affiliation = ?
    WHERE email = ?;
  ", params = list(
    user_data_manager()$first_name, 
    user_data_manager()$last_name, 
    user_data_manager()$affiliation, 
    user_data_manager()$email
    )
  )
}
