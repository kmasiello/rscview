#' Get Locking event history from audit logs
#'
#' @param audit_logs audit logs
#'
#' @return a tibble
#' @export
#'
get_lock_history_tbl <- function(audit_logs) {
  audit_logs %>%
    dplyr::filter(action == "update_lock_user") %>%
    dplyr::select(time, event_description) %>%
    tidyr::separate(event_description, into = c(NA, "user_w_lock_state"), sep = "Updated lock for user") %>%
    dplyr::mutate("user_w_lock_state" = str_trim(user_w_lock_state)) %>%
    tidyr::separate(user_w_lock_state, into = c("user", "lock_state"), sep = ": ") %>%
    tidyr::separate(user, into = c(NA, "username", NA), sep = "[\\(\\)]") %>%
    dplyr::mutate(event = case_when(lock_state == "true" ~ "locked",
                             lock_state == "false" ~ "unlocked")) %>%
    dplyr::select(-lock_state) %>%
    dplyr::rename("event_time" = time)
}
