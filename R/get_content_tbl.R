#' Get the Content table from the Connect server via `connectapi`
#'
#' @param conn the Connect server connection details containing the server and API key
#'
#' @return a tibble
#' @export
get_content_tbl <- function(conn = create_connection()) {
  connectapi::get_content(conn, limit = Inf)
}
