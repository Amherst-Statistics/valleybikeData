% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-monthly-dataset.R
\name{get_monthly_dataset}
\alias{get_monthly_dataset}
\title{get_monthly_dataset}
\usage{
get_monthly_dataset(month, year)
}
\arguments{
\item{month}{The month of the year for which to get the trajectory dataset
(as an integer or as a string).}

\item{year}{The year for which to get the trajectory dataset (as an integer or as a string).}
}
\value{
The trajectory dataset for that specific month-year combination (as a tibble).
}
\description{
Get the trajectory dataset for one month using numeric parameters for the month and year.
}
\details{
Get the trajectory dataset for one month using numeric parameters for the month and year.
The \code{month} parameter can be any number from 4 to 11 (since ValleyBike doesn't run during the
winter months), and the \code{year} parameter can be any valid year during which ValleyBike was
active (i.e., 2018, 2019, 2020, 2021).
}
\examples{
\dontrun{
get_monthly_dataset(month = 7, year = 2018)
}

}
