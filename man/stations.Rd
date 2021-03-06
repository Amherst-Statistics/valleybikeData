% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{stations}
\alias{stations}
\title{ValleyBike stations (as of 2020)}
\format{
A tibble
}
\usage{
stations
}
\description{
This dataset is contains information on 54 ValleyBike stations.
}
\section{Variables}{

\itemize{
 \item serial_num (integer), the station's serial number (primary key)
 \item name (character), the station's name
 \item address (character) the station's address
 \item city (character), the city in which the station is
 \item latitude (double), the station's latitude
 \item longitude (double), the station's longitude
 \item docks (integer), the number of bike docks at the station
 \item display (character), display name for the station (usually name + city)
}
}

\keyword{datasets}
