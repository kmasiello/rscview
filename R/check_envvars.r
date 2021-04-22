#' Check that CONNECT_SERVER and CONNECT_API_KEY environment variables are set
#'
#' @return
#' @export
#'
#' @examples

#KM - I'm not sure if the knit_exit portion needs to be removed yet. Still
#thinking through how final output as a flexdashboard will affect this.
#Also realize Kelly's original method would print the alert with HTML H4 style.

check_envvars <- function(){
  if(Sys.getenv('CONNECT_SERVER') == ''){
    cat("<h4>ERROR: You must set the CONNECT_SERVER environment variable</h4>\n")}
  if(Sys.getenv('CONNECT_API_KEY') == ''){
    cat("<h4>ERROR: You must set the CONNECT_API_KEY environment variable</h4>\n")}
  if(Sys.getenv('CONNECT_API_KEY') == '' || Sys.getenv('CONNECT_SERVER') == ''){
    knitr::knit_exit() }
}
