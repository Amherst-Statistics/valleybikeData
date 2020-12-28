# =================================================================================================
# get_monthly_dataset
# =================================================================================================
#
#' Get the trajectory dataset for one month using numeric parameters for the month and year.
#'
#' Get the trajectory dataset for one month using numeric parameters for the month and year.
#' The \code{month} parameter can be any number from 4 to 11 (since ValleyBike doesn't run during the
#' winter months), and the \code{year} parameter can be any valid year during which ValleyBike was
#' active (i.e., 2018, 2019, 2020).
#'
#' @title get_monthly_dataset
#'
#' @param month The month of the year for which to get the trajectory dataset
#'              (as an integer or as a string).
#' @param year The year for which to get the trajectory dataset (as an integer or as a string).
#'
#' @return The trajectory dataset for that specific month-year combination (as a tibble).
#'
#' @examples
#' \dontrun{
#' get_monthly_dataset(month = 7, year = 2018)
#' }
#'
#' @export
get_monthly_dataset <- function(month, year) {

  if (is.character(month)) {
    tryCatch({
      month <- readr::parse_integer(month)
    }, warning = function(w) stop("Invalid month format. Must be an integer."))
  }

  month_name <- tolower(month.name[month])
  dataset_name <- paste0(month_name, year)

  env <- new.env()
  tryCatch({
    name <- data(list = dataset_name, envir = env)[1]
  }, warning = function(w) stop("No data available for ", month.name[month], " ", year))
  data <- env[[name]]

  return(data)
}
