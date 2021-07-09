#' Get Users by role
#'
#' @param users_tbl Current Users table
#' @param role user role to filter
#'
#' @return a tibble
#' @export
#'

get_users_role <- function(users_tbl, role) {
  users_tbl %>% dplyr::filter(user_role == role)
}
