#' ValleyBike trips over 2018-2019
#'
#' This data set is an aggregated one-row-per-trip version of the original
#' point-in-time ValleyBike data for the years 2018 and 2019. Some raw by-day
#' .csv files were corrupted, so no trips from those days are included.
#'
#' @section Variables:
#' \itemize{
#'  \item route_id <chr>, the trip's unique route id (primary key)
#'  \item user_id <chr>, the rider's unique user id
#'  \item bike <chr> unique bike id
#'  \item start_time <dttm>, the trip's starting date-time (EDT)
#'  \item end_time <dttm>, the trip's ending date-time (EDT)
#'  \item start_station <chr>, the trip's starting station
#'  \item end_station <chr>, the trip's ending station
#'  \item start_latitude <dbl>, the trip's starting latitude
#'  \item start_longitude <dbl>, the trip's starting longitude
#'  \item end_latitude <dbl>, the trip's ending latitude
#'  \item end_longitude <dbl>, the trip's ending longitude
#'  \item duration <int>, the trip's duration (in seconds)
#' }
#'
#' @docType data
#' @name trips
#' @usage trips
#' @format A 118,848 x 12 data frame
#' @keywords datasets
NULL

#' ValleyBike stations (as of mid-2020)
#'
#' This data set is contains information on the 54 ValleyBike stations.
#'
#' @section Variables:
#' \itemize{
#'  \item serial_num <int>, the station's serial number (primary key)
#'  \item name <chr>, the station's name
#'  \item address <chr> the station's address
#'  \item city <chr>, the city in which the station is
#'  \item latitude <dbl>, the station'slatitude
#'  \item longitude <dbl>, the station's longitude
#'  \item docks <int>, the number of bike docks at the station
#'  \item display <chr>, display name for the station (usually name + city)
#' }
#'
#' @docType data
#' @name stations
#' @usage stations
#' @format A 54 x 8 data frame
#' @keywords datasets
NULL
