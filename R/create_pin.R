#' Create pin on Connect
#'
#' @param server Connect server address
#' @param key Administrator API key
#'
#' @export
create_pin <- function(x,
                       name = deparse(substitute(x)),
                       description = deparse(substitute(x)),
                       server = Sys.getenv("CONNECT_SERVER"),
                       key = Sys.getenv("CONNECT_API_KEY")) {

  # TODO: When the next version of `pins` is released on CRAN,
  # use the new implementation

  pins::board_register_rsconnect(
    server = server,
    key = key
  )

  pins::pin(x, name = name, description = description, board = "rsconnect")
}
