#' Get current user table
#'
#' @param conn the Connect server connection details containing the server and API key
#' @param user_historical_tbl  the Historical Users Table
#'
#' @return a tibble
#' @export
#'
get_user_current_tbl <- function(conn = create_connection(), user_historical_tbl = get_user_historical_tbl()) {
  user_historical_tbl %>%
    filter(count_as_licensed_named_user == TRUE)

}
