#' Get Users that have been active in the last `daysback` days
#'
#' @param users_tbl Current Users table
#' @param daysback number of days back from today
#'
#' @return a tibble
#' @export
#'

get_users_daysback <- function(users_tbl, daysback) {
  users_tbl %>% dplyr::filter(active_time >= lubridate::today() - daysback)

}
