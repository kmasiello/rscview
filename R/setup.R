#' Access to settings for the **rscview** package
#'
#' @description
#' Access to settings for the **rscview** package.
#'
#' @param admin_username The Connect username which has admin privileges.
#' @param file The filename for the YAML settings file.
#'
#' @export
rscview_settings <- function(
    admin_username,
    file = "rscview_settings.yml"
) {

  # Get the



  yaml_list <-
    list(
      admin_username = admin_username
    )

  # Write the YAML to the working directory (for now)
  # TODO: Explore using rappdirs https://github.com/r-lib/rappdirs for better
  # portability and standardization
  yaml::write_yaml(yaml_list, file = file)
}

# TODO: when the application setting directory is available then just
# look at the first YAML file in the directory; provide an error if directory
# or file is not available
get_rsc_admin_username <- function(file) {

  yaml_list <- yaml::read_yaml(file = file)

  yaml_list$admin_username
}
