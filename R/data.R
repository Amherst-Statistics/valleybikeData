#' ValleyBike trips over 2018-2021
#'
#' This data set is an aggregated one-row-per-trip version of the original
#' point-in-time ValleyBike data for the years 2018, 2019, 2020, and 2021.
#'
#' @section Variables:
#' \itemize{
#'  \item route_id (character), the trip's unique route id (primary key)
#'  \item user_id (character), the rider's unique user id
#'  \item bike (character), unique bike id
#'  \item start_time (datetime), the trip's starting date-time (EDT)
#'  \item end_time (datetime), the trip's ending date-time (EDT)
#'  \item start_station (character), the trip's starting station
#'  \item start_latitude (double), the trip's starting latitude
#'  \item start_longitude (double), the trip's starting longitude
#'  \item end_station (character), the trip's ending station
#'  \item end_latitude (double), the trip's ending latitude
#'  \item end_longitude (double), the trip's ending longitude
#'  \item duration (double), the trip's duration (in seconds)
#' }
#'
#' @docType data
#' @name trips
#' @usage data("trips")
#' @format A tibble
#' @keywords datasets
NULL

#' ValleyBike user statistics over 2018-2021
#'
#' This dataset contains anonymous statistics for ValleyBike users in 2018, 2019, 2020, and 2021.
#'
#' @section Variables:
#' \itemize{
#'  \item user_id (character), the user's unique id (primary key)
#'  \item trips (integer), the total number of trips taken by the user
#'  \item min_trip_duration (double), the user's minimum trip duration
#'  \item mean_trip_duration (double), the user's mean trip duration
#'  \item median_trip_duration (double), the user's median trip duration
#'  \item max_trip_duration (double), the user's maximum trip duration
#'  \item first_trip_time (datetime), the datetime of the user's first recorded trip
#'  \item last_trip_time (datetime), the datetime of the user's last recorded trip
#'  \item top_start_station (character), the station at which the user most frequently starts a trip
#'  \item top_start_station_trips (integer), the number of trips starting at the top start station
#'  \item top_end_station (character), the station at which the user most frequently ends a trip
#'  \item top_end_station_trips (integer), the number of trips ending at the top end station
#' }
#'
#' @docType data
#' @name users
#' @usage data("users")
#' @format A tibble
#' @keywords datasets
NULL

#' ValleyBike stations (as of 2020)
#'
#' This dataset is contains information on 54 ValleyBike stations.
#'
#' @section Variables:
#' \itemize{
#'  \item serial_num (integer), the station's serial number (primary key)
#'  \item name (character), the station's name
#'  \item address (character) the station's address
#'  \item city (character), the city in which the station is
#'  \item latitude (double), the station's latitude
#'  \item longitude (double), the station's longitude
#'  \item docks (integer), the number of bike docks at the station
#'  \item display (character), display name for the station (usually name + city)
#' }
#'
#' @docType data
#' @name stations
#' @usage data("stations")
#' @format A tibble
#' @keywords datasets
NULL

#' Monthly trajectory data
#'
#' The monthly datasets contain month-by-month trajectory data for all the months that ValleyBike has
#' been in active operation. The point data (latitude, longitude)
#' was collected during every trip, at 5-second intervals.
#'
#' @section Variables:
#' \itemize{
#'  \item route_id (character), the trip's unique route id (primary key)
#'  \item user_id (character), the rider's unique user id
#'  \item bike (character), unique bike id
#'  \item time (datetime), the time at which the location was recorded (down to seconds)
#'  \item longitude (double), the longitude of the bike at that point in time
#'  \item latitude (double), the latitude of the bike at that point in time
#' }
#'
#' @docType data
#' @name monthly
#' @keywords datasets
NULL

#' @rdname monthly
#' @usage data("june2018")
"june2018"
#' @rdname monthly
#' @usage data("july2018")
"july2018"
#' @rdname monthly
#' @usage data("august2018")
"august2018"
#' @rdname monthly
#' @usage data("september2018")
"september2018"
#' @rdname monthly
#' @usage data("october2018")
"october2018"
#' @rdname monthly
#' @usage data("november2018")
"november2018"
#' @rdname monthly
#' @usage data("april2019")
"april2019"
#' @rdname monthly
#' @usage data("may2019")
"may2019"
#' @rdname monthly
#' @usage data("june2019")
"june2019"
#' @rdname monthly
#' @usage data("july2019")
"july2019"
#' @rdname monthly
#' @usage data("august2019")
"august2019"
#' @rdname monthly
#' @usage data("june2018")
"september2019"
#' @rdname monthly
#' @usage data("october2019")
"october2019"
#' @rdname monthly
#' @usage data("november2019")
"november2019"
#' @rdname monthly
#' @usage data("june2020")
"june2020"
#' @rdname monthly
#' @usage data("july2020")
"july2020"
#' @rdname monthly
#' @usage data("august2020")
"august2020"
#' @rdname monthly
#' @usage data("september2020")
"september2020"
#' @rdname monthly
#' @usage data("october2020")
"october2020"
#' @rdname monthly
#' @usage data("november2020")
"november2020"
#' @rdname monthly
#' @usage data("december2020")
"december2020"
#' @rdname monthly
#' @usage data("january2021")
"january2021"
#' @rdname monthly
#' @usage data("february2021")
"february2021"
#' @rdname monthly
#' @usage data("march2021")
"march2021"
#' @rdname monthly
#' @usage data("april2021")
"april2021"
#' @rdname monthly
#' @usage data("may2021")
"may2021"
