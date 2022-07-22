#' Get the Content table via the Connect API
#'
#' @description
#' This provides a tibble that relates to all content on Connect. It has the
#' following columns:
#'
#' - guid:
#' - name:
#' - title:
#' - description:
#' - access_type:
#' - connection_timeout:
#' - read_timeout:
#' - init_timeout:
#' - idle_timeout:
#' - max_processes:
#' - min_processes:
#' - max_conns_per_process:
#' - load_factor:
#' - created_time:
#' - last_deployed_time:
#' - bundle_id:
#' - app_mode:
#' - content_category:
#' - parameterized:
#' - cluster_name:
#' - image_name:
#' - r_version:
#' - py_version:
#' - quarto_version:
#' - run_as:
#' - run_as_current_user:
#' - owner_guid:
#' - content_url:
#' - dashboard_url:
#' - app_role:
#' - id:
#' - owner:
#' - tags:
#'
#' @param conn the Connect server connection details containing the server and
#' API key.
#'
#' @return a tibble
#' @export
get_content_tbl <- function(conn = create_connection()) {

  connectapi::get_content(conn, limit = Inf)
}
