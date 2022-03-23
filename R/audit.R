#####To do
# Audit functions to be used as part of a scheduled job
#   audit_access - alert if content has an access permission
#                 level outside of defined acceptable range. i.e., content set to access=all. can
#                 refine to apply only to content with specific tag(s), or maybe other things
#                 too. Needs to be permissions-level or against a specific permissions list
#   audit_self_add - alert if an admin has self-added to content
#

#'
#' @export
audit_access <- function(pin_name = NULL,
                         tagname = NULL,
                         permissions = NULL,
                         access_type = c("all", "acl", "logged_in")) {

  access_type <- match.arg(access_type)

  if (!is.null(pin_name)) {

    content_tbl <-
      pins::pin_read(
        board = pins::board_rsconnect(),
        name = pin_name,
        version = pin_version()
      )

  } else {

    client <- connectapi::connect()

    content_tbl <- suppressWarnings(connectapi::get_content(client, limit = Inf))
  }

  if (!is.null(tagname)) {
    content_tbl <-
      get_content_by_tag(
        content = content_tbl,
        tagname = tagname
      )
  }

  access_all <-
    content_tbl %>%
    dplyr::filter(access_type == "all") %>%
    dplyr::select(guid, name, title, description, content_url)
}

get_content_by_tag <- function(content, tagname) {

  tagname <- as.list(tagname)
  content %>%
    dplyr::filter(
      purrr::map_lgl(content$tags, function(x) any(tagname %in% x$name))
    )
}


