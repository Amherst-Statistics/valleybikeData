#' Get trajectory data
#'
#' Get trajectory data for a specific timerange, route ID, user_id, or bike. Arguments can
#' be mixed and matched. Not specifying any arguments will return all of the 2018-2019
#' trajectory data (400 Mb).
#'
#' @title get_trajectory_data
#'
#' @param start_time The start time of the queried range (as a string of the form "YYYY-MM-DD HH:MM:SS")
#' @param end_time The end time of the queried range (as a string of the form "YYYY-MM-DD HH:MM:SS")
#' @param route_id A route ID to filter by (as a string)
#' @param user_id A user ID to filter by (as a string)
#' @param bike A bike number to filter by (as a string)
#'
#' @return A data frame of trajectory data, filtered according to the user's specifications.
#'
#' @examples
#' data <- get_trajectory_data(start_time = "2018-06-01 00:00:00", end_time = "2018-06-29 05:04:44",
#'                             user_id = "72491657-3115-4497-879d-000830f2352b")
#' @export
get_trajectory_data <- function(start_time = "2018-06-01 00:00:00", end_time = "2019-11-30 23:59:59",
                                route_id, user_id, bike) {

  message("Getting your data. This might take a while...")

  indices <- c("june2018" = "2018-06", "july2018" = "2018-07", "august2018" = "2018-08",
               "september2018" = "2018-09", "october2018" = "2018-10", "november2018" = "2018-11",
               "april2019" = "2019-04", "may2019" = "2019-05", "june2019" = "2019-06",
               "july2019" = "2019-07", "august2019" = "2019-08", "september2019" = "2019-09",
               "october2019" = "2019-10", "november2019" = "2019-11")

  start_month <- substr(start_time, 1, 7)
  end_month <- substr(end_time, 1, 7)

  months <- names(subset(indices, indices >= start_month & indices <= end_month))
  data(list = months, envir = environment()) # takes a while

  data <- data.table::rbindlist(lapply(months, function(month) eval(parse(text = month))))

  data <- subset(data, time >= as.POSIXct(start_time) & time <= as.POSIXct(end_time))

  args <- as.list(match.call())

  if (!missing(route_id)) {
    data <- data[data$route_id == args$route_id, ]
  }

  if (!missing(user_id)) {
    data <- data[data$user_id == args$user_id, ]
  }

  if (!missing(bike)) {
    data <- data[data$bike == args$bike, ]
  }

  return(data)
}

#' Get duration of trip
#'
#' Get the duration of some trip, based on its route ID.
#'
#' @title get_duration
#'
#' @param route_id The route ID (as a string)
#'
#' @return The duration of the route ID's corresponding trip (as a numeric constant)
#'
#' @examples
#' get_duration("route_04_2019@@01253ad9-cfb8-44a5-9218-bff8109e4880")
#'
#' @export
get_duration <- function(route_id) {

  data("trips", envir = environment())

  duration <- as.numeric(trips[trips$route_id == route_id, "duration"])

  if (length(duration) == 0) {
    stop("No trip with that route ID was found. Try again with a valid route ID.")
  }

  return(duration)
}

#' Get distance of trip
#'
#' Get the distance of some trip, based on its route ID.
#'
#' @title get_distance
#'
#' @param route_id The route ID (as a string)
#'
#' @return The distance of the route ID's corresponding trip (as a numeric constant)
#'
#' @examples
#' get_distance("route_04_2019@@01253ad9-cfb8-44a5-9218-bff8109e4880")
#'
#' @export
get_distance <- function(route_id) {
  # INCOMPLETE
}

#' Get stops in a trip
#'
#' Get the stops in a trip, based on its route ID.
#'
#' @title get_stops
#'
#' @param route_id The route ID (as a string)
#'
#' @return A data frame of all stops in the given trip (with latitude, longitude, and time)
#'
#' @examples
#' get_stops("route_04_2019@@01253ad9-cfb8-44a5-9218-bff8109e4880")
#'
#' @export
get_stops <- function(route_id) {
  # INCOMPLETE
  # Use DBSCAN algorithm
}
