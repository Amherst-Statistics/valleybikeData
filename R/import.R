# =================================================================================================
# download_data
# =================================================================================================

#' Download raw data files
#'
#' Download all available .csv.gz raw trajectory data files for the years 2018-2020 into a specified
#' directory. Intended usage is for updating the files in inst/extdata to mirror those online.
#'
#' @title download_data
#'
#' @param path The path where to download the data files. Presumably, this will be inst/extdata.
#' @param overwrite Whether to overwrite the existing files at the destination path. Defaults to FALSE.
#'
#' @examples
#' \dontrun{
#' download_data(path = "inst/extdata", overwrite = TRUE)
#' }
#'
#' @export
download_data <- function(path, overwrite = FALSE) {

  if (!dir.exists(path)) {
    stop("Invalid destination path.")
  }

  root <- "https://nhorton.people.amherst.edu/valleybikes/"

  file_pattern <- "VB_Routes_Data_[0-9]{4}_[0-9]{2}_[0-9]{2}\\.csv(\\.gz){0,1}"

  file_names <- root %>%
    readLines() %>%
    stringr::str_extract_all(pattern = file_pattern) %>%
    unlist()

  existing_file_names <- list.files(path)

  if (overwrite) {
    existing_file_paths <- file.path(path, existing_file_names)
    file.remove(existing_file_paths)
  } else {
    file_names <- file_names[!(file_names %in% existing_file_names)]
  }

  if (length(file_names) == 0) {
    stop("Nothing to download: data is already up to date.")
  }

  file_urls <- paste0(root, file_names)

  destination_files <- file.path(path, file_names)

  confirmation <- paste0("Will download ", length(file_names), " files to ", path, ". Proceed? [y/n] ")

  stopifnot(readline(prompt = confirmation) == "y")

  mapply(download.file, file_urls, destination_files)

  # standardize extensions ------------------------------------------------------------------------
  csv_file_names <- list.files(path, pattern = ".csv$")

  csv_file_paths <- file.path(path, csv_file_names)

  overlap_pattern <- csv_file_names %>%
    paste0(".gz") %>%
    paste0(collapse = "|")

  overlap_gz_file_names <- list.files(path, pattern = overlap_pattern)

  overlap_gz_file_paths <- file.path(path, overlap_gz_file_names)

  file.remove(overlap_gz_file_paths)

  invisible(lapply(csv_file_paths, R.utils::gzip))
}

# =================================================================================================
# import_day
# =================================================================================================

#' Import trajectory data for one day.
#'
#' Import trajectory data for a specific day. The user can choose to import the raw data,
#' the clean data (i.e. the raw data minus any anomalous observations), or the anomalous data.
#'
#' @title import_day
#'
#' @param day The day for which to import the data (as a string of the form "YYYY-MM-DD").
#' @param return The type of data to return (one of "clean", "anomalous", "all). Defaults to "clean".
#' @param future_cutoff The next-day cutoff (in hours) past which observations are categorized as
#'                      "anomalous", since rides may last past midnight. Defaults to 24.0 hours.
#'
#' @return A tibble of available trajectory data for that specific day.
#'
#' @examples
#' data_22_may_2019 <- import_day("2019-05-22")
#'
#' @export
import_day <- function(day, return = c("clean", "anomalous", "all"), future_cutoff = 24) {

  day_string <- gsub("-", "_", day)

  filename <- paste0("VB_Routes_Data_", day_string, ".csv.gz")
  filepath <- system.file("extdata", filename, package = "valleybikeData")

  # check that system.file returned a valid existent file
  if (filepath == "") {
    message("ERROR: No available data for day ", day, ".\n",
            "Returning empty tibble.")
    return(tibble::tibble())
  }

  # check that the file isn't one of the corrupted ones
  if (file.info(filepath)$size <= 1000) {
    message("ERROR: Corrupt file. Data for ", day, " cannot be imported.\n",
            "Returning empty tibble.")
    return(tibble::tibble())
  }

  # suppress warnings for readr parsing failures
  suppressWarnings({

    data <- data.table::fread(filepath, skip = 2, colClasses = "character") %>%
      janitor::clean_names() %>%
      dplyr::select(route_id, user_id, bike, time = date, longitude, latitude) %>%
      dplyr::mutate(
        route_id = readr::parse_character(route_id),
        user_id = readr::parse_character(user_id),
        bike = as.character(readr::parse_number(bike)),
        time = fasttime::fastPOSIXct(time),
        longitude = readr::parse_number(longitude),
        latitude = readr::parse_number(latitude)
      ) %>%
      dplyr::distinct() %>%
      tibble::as_tibble()
  })

  if (return[1] == "all") {
    return(data)
  }

  day_POSIXct <- fasttime::fastPOSIXct(day)

  data_clean <- data %>%
    na.omit() %>%
    dplyr::rowwise() %>%
    dplyr::filter(
      # allow observations at most 24 hours in the future (for rides lasting past midnight)
      difftime(time, day_POSIXct, units = "hours") %>%
        as.numeric() %>%
        dplyr::between(0, 24 + future_cutoff),
      trunc(longitude) == -72,
      trunc(latitude) == 42
    )

  if (return[1] == "clean") {
    return(data_clean)
  }

  data_anomalous <- dplyr::anti_join(data, data_clean, by = c("route_id", "time"))

  return(data_anomalous)
}

# =================================================================================================
# import_month
# =================================================================================================

#' Import trajectory data for one month.
#'
#' Import trajectory data for a specific month. The user can choose to import the raw data,
#' the clean data (i.e. the raw data minus any anomalous observations), or the anomalous data.
#'
#' @title import_month
#'
#' @param month The month for which to import the data (as a string of the form "YYYY-MM").
#' @param ... Further parameters to pass to `import_day()` (e.g. `return` or `future_cutoff`).
#'
#' @return A tibble of available trajectory data for that specific month.
#'
#' @export
import_month <- function(month, ...) {

  padded_days <- formatC(1:31, width = 2, format = "d", flag = "0")
  days <- paste0(month, "-", padded_days)

  clust <- parallel::makeCluster(parallel::detectCores())
  parallel::clusterExport(clust, c("import_day", "%>%"))

  data <- parallel::parLapply(clust, days, import_day, ...) %>%
    data.table::rbindlist() %>%
    dplyr::distinct() %>%
    tibble::as_tibble()

  parallel::stopCluster(clust)

  return(data)
}

# =================================================================================================
# import_full
# =================================================================================================

#' Import full trajectory data (raw)
#'
#' Import all available trajectory data for the years 2018-2020, in raw format.
#'
#' @title import_full
#'
#' @return A 65,975,278 x 6 tibble of all available trajectory data.
#'
#' @examples
#' \dontrun{
#' full_data <- import_full()
#' }
#'
#' @export
import_full <- function() {

  clust <- parallel::makeCluster(parallel::detectCores())

  path <- system.file("extdata", package = "valleybikeData")

  all_files <- paste0(path, "/", list.files(path, pattern = ".csv.gz$"))

  files <- all_files[file.info(all_files)$size > 1000]

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

#' Aggregate trip data.
#'
#' Create a one-row-per-trip dataset from the output of `import_full`.
#'
#' @title aggregate_trips
#'
#' @param full_data The full trajectory data (as output by `import_full`).
#'
#' @return A tibble of all available trip data.
#'
#' @examples
#' \dontrun{
#' full_data <- import_full()
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
#' full_data <- import_full()
#' trip_data <- aggregate_trips(full_data)
#' user_data <- aggregate_trips(trip_data)
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
