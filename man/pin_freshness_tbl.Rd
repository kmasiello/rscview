% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pin_freshness.R
\name{pin_freshness_tbl}
\alias{pin_freshness_tbl}
\title{Pin Freshness Tibble}
\usage{
pin_freshness_tbl(board = pins::board_rsconnect(), pin_names = pins_used)
}
\arguments{
\item{board}{the connect board}

\item{pin_names}{vector of full path ("username/pin-name") pin names on server}
}
\value{
a tibble of pin name and create date
}
\description{
Pin Freshness Tibble
}
