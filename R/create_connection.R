
#' Create connection to Connect server
#'
#' @param server Connect server address
#' @param key Administrator API key
#'
#' @return An RStudio Connect R6 object that can be passed along to methods
#' @export
#'
create_connection <- function(server = Sys.getenv("CONNECT_SERVER"),
                              key = Sys.getenv("CONNECT_API_KEY")) {
  connectapi::connect(
    server = server,
    api_key = key
  )
}
