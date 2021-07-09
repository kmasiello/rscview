#' Check that CONNECT_SERVER and CONNECT_API_KEY environment variables are set
#'
#' @return
#' @export

check_envvars <- function(){
  if(Sys.getenv('CONNECT_SERVER') == ''){
    cat("<h4>ERROR: You must set the CONNECT_SERVER environment variable</h4>\n")}
  if(Sys.getenv('CONNECT_API_KEY') == ''){
    cat("<h4>ERROR: You must set the CONNECT_API_KEY environment variable</h4>\n")}
  if(Sys.getenv('CONNECT_API_KEY') == '' || Sys.getenv('CONNECT_SERVER') == ''){
    knitr::knit_exit() }
}
