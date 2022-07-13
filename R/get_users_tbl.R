#' Get the Users Table via the Connect API
#'
#' @description
#' This provides a tibble that relates to all users on Connect. It has the
#' following columns:
#'
#' - email:
#' - username:
#' - first_name:
#' - last_name:
#' - user_role:
#' - created_time:
#' - updated_time:
#' - active_time:
#' - confirmed:
#' - locked:
#' - guid:
#'
#' @param conn the Connect server connection details containing the server and
#' API key.
#'
#' @return a tibble
#' @export
get_users_tbl <- function(conn = create_connection()) {

  # Get the users table table through the Connect API
  connectapi::get_users(src = conn, limit = Inf)
}
