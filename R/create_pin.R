
#' Create pin on Connect
#'
#' @param server Connect server address
#' @param key Administrator API key
#'
#' @return
#' @export

# KM note - will want to update this with the dev version of pins at some point.
create_pin <- function(x, name = deparse(substitute(x)), description = deparse(substitute(x)), server = Sys.getenv("CONNECT_SERVER"), key = Sys.getenv("CONNECT_API_KEY")) {
  pins::board_register_rsconnect(
    key = key,
    server = server)

  pins::pin(x, name = name, description = description, board = "rsconnect")
}
