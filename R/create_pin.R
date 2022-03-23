#' Create a pin on Connect
#'
#' Helper function used internally to pin audit data in a consistent manner.
#'
#' @param x An R object (e.g., data frame, list, etc.).
#' @param server Connect server address.
#' @param key Administrator API key.
#'
#' @noRd
create_pin <- function(
    x,
    name = deparse(substitute(x)),
    description = deparse(substitute(x)),
    server = Sys.getenv("CONNECT_SERVER"),
    key = Sys.getenv("CONNECT_API_KEY"),
    metadata = list("server_audit" = TRUE)
) {

  board <-
    pins::board_rsconnect(
      auth = "manual",
      server = server,
      key = key
    )

  pins::pin_write(board, x, name = name, metadata = metadata)
}
