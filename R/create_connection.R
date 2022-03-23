#' Create connection to Connect server
#'
#' The `create_connection()` function is used to create a connection to your
#' Connect server via the **connectapi** package.
#'
#' @param server Connect server address.
#' @param key Administrator API key.
#'
#' @return An RStudio Connect object that can be passed along to methods.
#'
#' @export
create_connection <- function(
    server = Sys.getenv("CONNECT_SERVER"),
    key = Sys.getenv("CONNECT_API_KEY")
) {

  connectapi::connect(server = server, api_key = key)
}
