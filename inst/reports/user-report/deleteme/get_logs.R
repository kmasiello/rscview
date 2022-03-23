conn <-
  connectapi::connect(
    host = Sys.getenv("CONNECT_SERVER"),
    api_key = Sys.getenv("CONNECT_API_KEY")
  )
logs <- connectapi::get_audit_logs(conn, limit = Inf)
filename <- paste0("logs_", lubridate::today(), ".rds")
readr::write_rds(logs, file = filename)
