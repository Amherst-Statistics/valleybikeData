# =================================================================================================
# get_full_data
# =================================================================================================
#
#' Get the full trajectory data (raw)
#'
#' Get all available trajectory data for the years 2018-2020, in raw format.
#'
#' @title get_full_data
#'
#' @return A 65,975,278 x 6 tibble of all available trajectory data.
#'
#' @examples
#' \dontrun{
#' full_data <- get_full_data()
#' }
#'
#' @export
get_full_data <- function() {

  root <- "https://nhorton.people.amherst.edu/valleybikes/"

  file_pattern <- "VB_Routes_Data_[0-9]{4}_[0-9]{2}_[0-9]{2}\\.csv\\.gz"

  files <- root %>%
    readLines() %>%
    stringr::str_extract_all(pattern = file_pattern) %>%
    unlist()

  file_urls <- paste0(root, files)

  clust <- parallel::makeCluster(parallel::detectCores())

  full_data <- parallel::parLapply(clust, files, data.table::fread, skip = 2,
                                   colClasses = c("character", "character", "character",
                                                  "numeric", "numeric", "character")) %>%
    data.table::rbindlist() %>%
    janitor::clean_names() %>%
    dplyr::distinct() %>%
    tibble::as_tibble()

  parallel::stopCluster(clust)

  return(full_data)
}

# =================================================================================================
# aggregate_trips
# =================================================================================================
#
#' Aggregate trip data.
#'
#' Create a one-row-per-trip dataset from the output of `get_full_data`.
#'
#' @title aggregate_trips
#'
#' @param full_data The full trajectory data (as output by `get_full_data`).
#'
#' @return A tibble of all available trip data.
#'
#' @examples
#' \dontrun{
#' full_data <- get_full_data()
#' trips <- aggregate_trips(full_data)
#' }
#'
#' @export
aggregate_trips <- function(full_data) {

  # using data.table for efficiency
  data.table::setDT(full_data)

  full_data[, date := fasttime::fastPOSIXct(date)]

  full_data_clean <- na.omit(full_data)

  full_data_clean <- full_data_clean[data.table::between(date, as.POSIXct("2018-06-28"), Sys.Date())]

  trips <- full_data_clean[, list(user_id = data.table::first(user_id),
                                  bike = data.table::first(bike),
                                  start_time = data.table::first(date),
                                  end_time = data.table::last(date),
                                  start_latitude = data.table::first(latitude),
                                  start_longitude = data.table::first(longitude),
                                  end_latitude = data.table::last(latitude),
                                  end_longitude = data.table::last(longitude)),
                           by = route_id]

  trips[, duration := as.numeric(end_time) - as.numeric(start_time)]

  station_locations <- dplyr::select(valleybikeData::stations, name, latitude, longitude)

  trips <- trips %>%
    fuzzyjoin::geo_left_join(
      station_locations,
      by = c("start_latitude" = "latitude", "start_longitude" = "longitude"),
      method = "haversine",
      unit = "km",
      max_dist = 0.05
    ) %>%
    fuzzyjoin::geo_left_join(
      station_locations,
      by = c("end_latitude" = "latitude", "end_longitude" = "longitude"),
      method = "haversine",
      unit = "km",
      max_dist = 0.05
    ) %>%
    dplyr::select(
      route_id,
      user_id,
      bike,
      start_time,
      end_time,
      start_station = name.x,
      start_latitude,
      start_longitude,
      end_station = name.y,
      end_latitude,
      end_longitude,
      duration
    ) %>%
    tibble::as_tibble()

  return(trips)
}

# =================================================================================================
# aggregate_users
# =================================================================================================
#
#' Aggregate user data.
#'
#' Create a one-row-per-user dataset from the output of `aggregate_trips`.
#'
#' @title aggregate_users
#'
#' @param trip_data The one-row-per-trip data (as output by `aggregate_trips`).
#'
#' @return A tibble of all available user data.
#'
#' @examples
#' \dontrun{
#' full_data <- get_full_data()
#' trips <- aggregate_trips(full_data)
#' users <- aggregate_users(trips)
#' }
#'
#' @export
aggregate_users <- function(trip_data) {

  users <- trip_data %>%
    dplyr::group_by(user_id) %>%
    dplyr::summarize(
      trips = dplyr::n(),
      min_trip_duration = min(duration, na.rm = TRUE),
      mean_trip_duration = mean(duration, na.rm = TRUE),
      median_trip_duration = median(duration, na.rm = TRUE),
      max_trip_duration = max(duration, na.rm = TRUE),
      first_trip_time = min(start_time, na.rm = TRUE),
      last_trip_time = max(start_time, na.rm = TRUE),
      top_start_station = names(which.max(table(start_station))) %>%
        {ifelse(is.null(.), NA, .)},
      top_start_station_trips = max(table(start_station)) %>%
        {ifelse(. == -Inf, NA, .)},
      top_end_station = names(which.max(table(end_station))) %>%
        {ifelse(is.null(.), NA, .)},
      top_end_station_trips = max(table(end_station)) %>%
        {ifelse(. == -Inf, NA, .)}
    )

  return(users)
}
