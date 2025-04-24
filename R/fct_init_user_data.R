#' init_user_data 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
init_user_data <- function() {
  tibble::tibble(
    `first_name` = NA_character_,
    `last_name` = NA_character_,
    `email` = NA_character_,
    `affiliation` = NA_character_
  )
}
