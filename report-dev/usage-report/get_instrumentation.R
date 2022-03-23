library(connectapi)
conn <-
  connectapi::connect(
    host = Sys.getenv("CONNECT_SERVER"),
    api_key = Sys.getenv("CONNECT_API_KEY")
  )
content <- connectapi::get_content(conn, limit = Inf)
filename <- paste0("content_", lubridate::today(), ".rds")
readr::write_rds(content, file = filename)

days_back <- 90
report_from <- lubridate::today() - lubridate::ddays(days_back)

shiny <- get_usage_shiny(
  conn,
  from = report_from,
  limit = Inf
)
filename <- paste0("shiny_", lubridate::today(), ".rds")
readr::write_rds(shiny, file = filename)

static <- get_usage_static(
  conn,
  from = report_from,
  limit = Inf
)
filename <- paste0("static_", lubridate::today(), ".rds")
readr::write_rds(static, file = filename)
