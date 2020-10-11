download_data <- function(destination_path, overwrite = FALSE) {

  if (!dir.exists(destination_path)) {
    stop("Invalid destination path.")
  }

  root <- "https://nhorton.people.amherst.edu/valleybikes/"

  file_pattern <- "VB_Routes_Data_[0-9]{4}_[0-9]{2}_[0-9]{2}\\.csv(\\.gz){0,1}"

  file_names <- root %>%
    readLines() %>%
    stringr::str_extract_all(pattern = file_pattern) %>%
    unlist()

  existing_file_names <- list.files(destination_path)

  if (overwrite) {
    existing_file_paths <- file.path(destination_path, existing_file_names)
    file.remove(existing_file_paths)
  } else {
    file_names <- file_names[!(file_names %in% existing_file_names)]
  }

  if (length(file_names) == 0) {
    stop("Nothing to download: data is already up to date.")
  }

  file_urls <- paste0(root, file_names)

  destination_files <- file.path(destination_path, file_names)

  confirmation <- paste0("Will download ", length(file_names), " files to ",
                         destination_path, ". Proceed? [y/n] ")

  stopifnot(readline(prompt = confirmation) == "y")

  mapply(download.file, file_urls, destination_files)

  # standardize extensions ------------------------------------------------------------------------
  csv_file_names <- list.files(destination_path, pattern = ".csv$")

  csv_file_paths <- file.path(destination_path, csv_file_names)

  overlap_pattern <- csv_file_names %>%
    paste0(".gz") %>%
    paste0(collapse = "|")

  overlap_gz_file_names <- list.files(destination_path, pattern = overlap_pattern)

  overlap_gz_file_paths <- file.path(destination_path, overlap_gz_file_names)

  file.remove(overlap_gz_file_paths)

  invisible(lapply(csv_file_paths, R.utils::gzip))
}

# =================================================================================================
# =================================================================================================
# =================================================================================================

#' Import full trajectory data (raw)
#'
#' Import all available trajectory data for the years 2018-2020, in raw format.
#'
#' @title import_full
#'
#' @return A 60,910,226 x 6 tibble of all available trajectory data.
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

  full_data <- parallel::parLapply(clust, files, data.table::fread, skip = 2) %>%
    data.table::rbindlist() %>%
    janitor::clean_names() %>%
    dplyr::distinct() %>%
    tibble::as_tibble()

  parallel::stopCluster(clust)

  return(full_data)
}

# =================================================================================================
# =================================================================================================
# =================================================================================================

#' Import trajectory data for one day.
#'
#' Import trajectory data for a specific day. The user can choose to import the raw data,
#' the clean data (i.e. the raw data minus any anomalous observations), or the anomalous data.
#'
#' @title import_day
#'
#' @param day The day for which to import the data (as a string of the form "YYYY-MM-DD").
#' @param return The type of data to return (one of "all", "clean", "anomalous"). Defaults to "all".
#' @param future_cutoff The next-day cutoff (in hours) past which observations are categorized as
#'                      "anomalous", since rides may last past midnight. Defaults to 24.0 hours.
#'
#' @return A tibble of available trajectory data for that specific day.
#'
#' @examples
#' data_22_may_2019 <- import_day("2019-05-22", return = "clean")
#'
#' @export
import_day <- function(day, return = c("all", "clean", "anomalous"), future_cutoff = 24) {

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
        time = readr::parse_datetime(time),
        longitude = readr::parse_number(longitude),
        latitude = readr::parse_number(latitude)
      ) %>%
      dplyr::distinct() %>%
      tibble::as_tibble()
  })

  if (return[1] == "all") {
    return(data)
  }

  day_POSIXct <- readr::parse_datetime(day)

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
# =================================================================================================
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
