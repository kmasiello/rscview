#' Get historical user table based on Connect API user table
#'
#' @param conn the Connect server connection details containing the server and API key
#' @param users_tbl  the Users Table via Connect API. By default the user table will be fetched via `get_users_tbl()`
#'
#' @return a tibble
#' @export
#'
get_user_historical_tbl <- function(conn = create_connection(), users_tbl = get_users_tbl(conn)) {
  users_tbl %>%
    dplyr::mutate(
      active_time = lubridate::as_date(active_time),
      days_since = active_time %--% lubridate::today() / days(),
      days_range = dplyr::case_when(
        days_since <= 7 ~ "1,Last 7 days",
        days_since <= 14 ~ "2,8 to 14 days",
        days_since <= 30 ~ "3,15 to 30 days",
        days_since <= 60 ~ "4,31 to 60 days",
        days_since <= 90 ~ "5,61 to 90 days",
        TRUE ~ "6,Over 90 days")) %>%
    tidyr::separate(days_range, c("days_sort", "days_range"), sep = ",") %>%
    dplyr::mutate(days_sort = as.numeric(days_sort)) %>%
    dplyr:: mutate(count_as_licensed_named_user = dplyr::case_when(
      lubridate::as_date(active_time) >= (lubridate::today() - lubridate::dyears(1)) & locked == FALSE ~ TRUE,
      TRUE ~ FALSE
    ))

}
