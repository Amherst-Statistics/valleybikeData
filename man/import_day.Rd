% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import.R
\name{import_day}
\alias{import_day}
\title{import_day}
\usage{
import_day(day, return = c("clean", "anomalous", "all"), future_cutoff = 24)
}
\arguments{
\item{day}{The day for which to import the data (as a string of the form "YYYY-MM-DD").}

\item{return}{The type of data to return (one of "clean", "anomalous", "all). Defaults to "clean".}

\item{future_cutoff}{The next-day cutoff (in hours) past which observations are categorized as
"anomalous", since rides may last past midnight. Defaults to 24.0 hours.}
}
\value{
A tibble of available trajectory data for that specific day.
}
\description{
Import trajectory data for one day.
}
\details{
Import trajectory data for a given day. The user can choose to import the raw data,
the clean data (i.e. the raw data minus any anomalous observations), or the anomalous data.
}
\examples{
\dontrun{
june_28_2018 <- import_day("2018-06-28", return = "all")
}

}
