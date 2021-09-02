# =================================================================================================
# import_day
# =================================================================================================
#
#' Import trajectory data for one day.
#'
#' Import trajectory data for a given day. The user can choose to import the raw data,
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
#' \dontrun{
#' june_28_2018 <- import_day("2018-06-28", return = "all")
#' }
#'
#' @export
import_day <- function(day, return = c("clean", "anomalous", "all"), future_cutoff = 24) {

  root <- "https://nhorton.people.amherst.edu/valleybikes/"

  day_string <- gsub("-", "_", day)

  filename <- paste0("VB_Routes_Data_", day_string, ".csv.gz")

  url <- paste0(root, filename)

  # check that the daily file exists
  data_raw <- tryCatch({
    data.table::fread(url, skip = 2, colClasses = "character")
  }, error = function(e) tibble::tibble())

  if (nrow(data_raw) == 0) {
    message("ERROR: No available data for day ", day, ".\n", "Returning empty tibble.")
    return(data_raw)
  }

  # suppress warnings for readr parsing failures
  suppressWarnings({
    data_parsed <- data_raw %>%
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
      dplyr::distinct()
  })

  if (return[1] == "all") {
    return(tibble::as_tibble(data_parsed))
  }

  day_POSIXct <- fasttime::fastPOSIXct(day)

  data_clean <- data_parsed %>%
    stats::na.omit() %>%
    dplyr::rowwise() %>%
    dplyr::filter(
      # allow observations at most 24 hours in the future (for rides lasting past midnight)
      dplyr::between((as.numeric(time) - as.numeric(day_POSIXct)) / 3600, 0, 24 + future_cutoff),
      trunc(longitude) == -72,
      trunc(latitude) == 42
    )

  if (return[1] == "clean") {
    return(tibble::as_tibble(data_clean))
  }

  data_anomalous <- dplyr::anti_join(data_parsed, data_clean, by = c("route_id", "time"))

  return(tibble::as_tibble(data_anomalous))
}

# =================================================================================================
# import_month
# =================================================================================================
#
#' Import trajectory data for one month.
#'
#' Import trajectory data for a specific month. The user can choose to import the raw data,
#' the clean data (i.e. the raw data minus any anomalous observations), or the anomalous data.
#'
#' @title import_month
#'
#' @param month The month for which to import the data (as a string of the form "YYYY-MM").
#' @param ... Further parameters to pass to \code{import_day} (e.g. \code{return} or \code{future_cutoff}).
#'
#' @return A tibble of available trajectory data for that specific month.
#'
#' @examples
#' \dontrun{
#' june2018 <- import_month("2018-06")
#' }
#'
#' @export
import_month <- function(month, ...) {

  padded_days <- formatC(1:31, width = 2, format = "d", flag = "0")
  days <- paste0(month, "-", padded_days)

  clust <- parallel::makeCluster(parallel::detectCores())
  parallel::clusterExport(clust, c("import_day", "%>%"))

  data <- parallel::parLapply(clust, days, import_day, ...) %>%
    lapply(function(df) if (nrow(df) == 0) NULL else df) %>%
    data.table::rbindlist() %>%
    dplyr::distinct() %>%
    tibble::as_tibble()

  parallel::stopCluster(clust)

  return(data)
}
