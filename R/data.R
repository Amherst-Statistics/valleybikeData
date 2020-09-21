#' ValleyBike trips over 2018-2020
#'
#' This data set is an aggregated one-row-per-trip version of the original
#' point-in-time ValleyBike data for the years 2018, 2019, and 2020. Some raw by-day
#' .csv files were corrupted, so trips from those days are not documented. Many
#' trips also show up with either a very low duration (e.g. 0-3 seconds) or an
#' impossibly high one (e.g. 900 hours). They have been left in the data set to
#' give people the opportunity of exploring them further.
#'
#' @section Variables:
#' \itemize{
#'  \item route_id <chr>, the trip's unique route id (primary key)
#'  \item user_id <chr>, the rider's unique user id
#'  \item bike <chr>, unique bike id
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
#' @format A 118,839 x 12 data frame
#' @keywords datasets
NULL

#' ValleyBike user statistics over 2018-2019
#'
#' This data set is contains anonymous statistics for ValleyBike users in
#' 2018, 2019, and 2020.
#'
#' @section Variables:
#' \itemize{
#'  \item user_id <chr>, the user's unique id (primary key)
#'  \item num_trips <int>, the total number of trips taken by the user
#'  \item first_trip <dttm> the date-time of the user's first recorded trip
#'  \item last_trip <dttm> the date-time of the user's last recorded trip
#'  \item mean_trip_duration <dbl>, the user's mean trip duration
#'  \item median_trip_duration <dbl>, the user's median trip duration
#'  \item most_freq_start_station <chr>, the station at which the user most
#'        frequently starts a trip
#'  \item num_starting_there <int>, the number of trips starting at the user's
#'        most frequent start station
#'  \item most_freq_end_station <chr>, the station at which the user most
#'        frequently ends a trip
#'  \item num_ending_there <int>, the number of trips ending at the user's
#'        most frequent end station
#' }
#'
#' @docType data
#' @name users
#' @usage users
#' @format A 12,553 x 10 data frame
#' @keywords datasets
NULL

#' ValleyBike stations (as of 2020)
#'
#' This data set is contains information on the 54 ValleyBike stations.
#'
#' @section Variables:
#' \itemize{
#'  \item serial_num <int>, the station's serial number (primary key)
#'  \item name <chr>, the station's name
#'  \item address <chr> the station's address
#'  \item city <chr>, the city in which the station is
#'  \item latitude <dbl>, the station's latitude
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

#' By-month trajectory data
#'
#' The by-month data sets (for 2018-2020) contain monthly trajectory data
#' (latitude, longitude) collected during every trip, at 5-second intervals.
#' These datasets are quite large (a few million entries), so they might lag
#' your R session.
#'
#' @section Variables:
#' \itemize{
#'  \item route_id <chr>, the trip's unique route id (primary key)
#'  \item user_id <chr>, the rider's unique user id
#'  \item bike <chr>, unique bike id
#'  \item time <dttm>, the time at which the location was recorded (down to seconds)
#'  \item longitude <dbl>, the longitude of the bike at that point in time
#'  \item latitude <dbl>, the latitude of the bike at that point in time
#' }
#'
#' @docType data
#' @name byMonth
#' @keywords datasets
NULL

#' @rdname byMonth
"june2018"
#' @rdname byMonth
"july2018"
#' @rdname byMonth
"august2018"
#' @rdname byMonth
"september2018"
#' @rdname byMonth
"october2018"
#' @rdname byMonth
"november2018"
#' @rdname byMonth
"april2019"
#' @rdname byMonth
"may2019"
#' @rdname byMonth
"june2019"
#' @rdname byMonth
"july2019"
#' @rdname byMonth
"august2019"
#' @rdname byMonth
"september2019"
#' @rdname byMonth
"october2019"
#' @rdname byMonth
"november2019"
#' @rdname byMonth
"june2020"
#' @rdname byMonth
"july2020"
#' @rdname byMonth
"august2020"
