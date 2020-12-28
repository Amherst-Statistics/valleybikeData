#' ValleyBike trips over 2018-2020
#'
#' This data set is an aggregated one-row-per-trip version of the original
#' point-in-time ValleyBike data for the years 2018, 2019, and 2020.
#'
#' @section Variables:
#' \itemize{
#'  \item route_id (character), the trip's unique route id (primary key)
#'  \item user_id (character), the rider's unique user id
#'  \item bike (character), unique bike id
#'  \item start_time (datetime), the trip's starting date-time (EDT)
#'  \item end_time (datetime), the trip's ending date-time (EDT)z
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
#' @usage trips
#' @format A tibble
#' @keywords datasets
NULL

#' ValleyBike user statistics over 2018-2019
#'
#' This dataset is contains anonymous statistics for ValleyBike users in 2018, 2019, and 2020.
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
#' @usage users
#' @format A tibble
#' @keywords datasets
NULL

#' ValleyBike stations (as of 2020)
#'
#' This dataset is contains information on the 54 ValleyBike stations.
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
#' @usage stations
#' @format A tibble
#' @keywords datasets
NULL

#' Monthly trajectory data
#'
#' The monthly datasets contain month-by-month trajectory data for all the months that ValleyBike has
#' been in active operation (normally April-November each year). The point data (latitude, longitude)
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
"june2018"
#' @rdname monthly
"july2018"
#' @rdname monthly
"august2018"
#' @rdname monthly
"september2018"
#' @rdname monthly
"october2018"
#' @rdname monthly
"november2018"
#' @rdname monthly
"april2019"
#' @rdname monthly
"may2019"
#' @rdname monthly
"june2019"
#' @rdname monthly
"july2019"
#' @rdname monthly
"august2019"
#' @rdname monthly
"september2019"
#' @rdname monthly
"october2019"
#' @rdname monthly
"november2019"
#' @rdname monthly
"june2020"
#' @rdname monthly
"july2020"
#' @rdname monthly
"august2020"
#' @rdname monthly
"september2020"
#' @rdname monthly
"october2020"
