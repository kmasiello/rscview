#' Pin Freshness Tibble
#'
#' @description
#'
#' @param board the connect board
#' @param pin_names vector of full path ("username/pin-name") pin names on
#' server.
#'
#' @return a tibble of pin name and create date
#' @export
#'
pin_freshness_tbl <- function(
    board = pins::board_rsconnect(),
    pin_names
) {
  # TODO: name me better

  purrr::map_df(pin_names, .f = function(x) {
    meta <- board %>% pins::pin_meta(x)
    dplyr::tibble(name = x, created = meta$created)
    })
}

#' Pin Freshness String
#'
#' @param pin_freshness_tbl tibble of pin names and created date
#' @param pin_names if not NULL, subset of pin names from freshness tbl to extract into a string
#'
#' @return a string of pin names and timestamps
#' @export
#'
pin_freshness_str <- function(pin_freshness_tbl, pin_names = NULL){

  if (!is.null(pin_names)) {
    pin_freshness_tbl <- pin_freshness_tbl %>% dplyr::filter(pin_names %in% name)
  }

  pin_freshness_tbl %>%
    dplyr::mutate(str = paste0("\"", name, "\" (dated ", created, ")")) %>%
    dplyr::pull(str) %>%
    paste(collapse = ", ")
}
