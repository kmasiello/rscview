#' Get the Users Table via Connect API
#'
#' @param conn the Connect server connection details containing the server and API key
#'
#' @return a tibble
#'
#' @export
get_users_tbl <- function(conn = create_connection()){
  users_tbl_raw <- connectapi::get_users(src = conn, limit = Inf)

  users_tbl_raw %>%
    dplyr::filter(confirmed == TRUE) %>%
    filter(!is.na(active_time)) %>%
    dplyr::mutate(days_since_active = as.numeric(lubridate::today() - lubridate::as_date(active_time))) %>%
    dplyr::mutate(count_as_licensed_named_user = dplyr::case_when(
      lubridate::as_date(active_time) >= (lubridate::today() - lubridate::dyears(1)) & locked == FALSE ~ TRUE,
      TRUE ~ FALSE
    ))
}
