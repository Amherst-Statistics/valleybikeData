#' Import full trajectory data (raw)
#'
#' Import all available trajectory data for the years 2018-2020, in raw format.
#'
#' @title import_full
#'
#' @return A 60,910,226 x 6 data frame of all available trajectory data.
#'
#' @examples
#' \dontrun{
#' full_data <- import_full()
#' }
#' 
#' @export
import_full <- function() {
  
  clust <- parallel::makeCluster(parallel::detectCores())
  
  all_files <- paste0("data-raw/", list.files(path = "data-raw/", pattern = "*.csv.gz"))
  
  files <- all_files[file.info(all_files)$size > 1000]

  full_data <- parallel::parLapply(clust, files, data.table::fread, skip = 2) %>%
    data.table::rbindlist() %>%
    janitor::clean_names()
  
  return(full_data)
}

#' Import trajectory data for one day.
#'
#' Import trajectory data for a specific day. The user can choose to import the raw data, 
#' the clean data (i.e. the raw data minus any anomalous observations), or the anomalous data.
#'
#' @title import_day
#' 
#' @param day The day for which to import the data (as a string of the form "YYYY-MM-DD")
#' @param return The type of data to return (one of "all", "clean", "anomalous"). Defaults to "all"
#'
#' @return A data frame of available trajectory data for that specific day.
#'
#' @examples
#' data_22_may_2019 <- import_day("2019-05-22", return = "clean")
#' 
#' @export
import_day <- function(day, return = c("all", "clean", "anomalous")) {
  
  suppressWarnings({
    
    day_string <- gsub("-", "_", day)
    
    filepath <- paste0("data-raw/VB_Routes_Data_", day_string, ".csv.gz")
    
    data <- fread(filepath, skip = 2, colClasses = "character") %>%
      clean_names() %>%
      select(route_id, user_id, bike, time = date, longitude, latitude) %>%
      mutate(
        route_id = parse_character(route_id),
        user_id = parse_character(user_id),
        bike = as.character(parse_number(bike)),
        time = parse_datetime(time),
        longitude = parse_number(longitude),
        latitude = parse_number(latitude)
      )
    
    data_clean <- data %>%
      na.omit() %>%
      filter(
        format(time, "%Y-%m-%d") == day,
        trunc(longitude) == -72,
        trunc(latitude) == 42
      )
    
    data_anomalous <- anti_join(data, data_clean, by = c("route_id", "time"))
    
    message(nrow(data_anomalous), " anomalous observations found, from a total of ", nrow(data))
    
    if (return == "all") {
      return(data)
    } else if (return == "clean") {
      return(data_clean)
    } else {
      return(data_anomalous)
    }
  })
}

#' Import trajectory data for one month.
#'
#' Import trajectory data for a specific month. The user can choose to import the raw data, 
#' the clean data (i.e. the raw data minus any anomalous observations), or the anomalous data.
#'
#' @title import_month
#' 
#' @param month The month for which to import the data (as a string of the form "YYYY-MM")
#' @param return The type of data to return (one of "all", "clean", "anomalous"). Defaults to "all"
#'
#' @return A data frame of available trajectory data for that specific month.
#'
#' @examples
#' data_may_2019 <- import_month("2019-05", return = "clean")
#' 
#' @export
import_month <- function(month, return = c("all", "clean", "anomalous")) {
  
  suppressWarnings({
    
    day_string <- gsub("-", "_", day)
    
    filepath <- paste0("data-raw/VB_Routes_Data_", day_string, ".csv.gz")
    
    data <- fread(filepath, skip = 2, colClasses = "character") %>%
      clean_names() %>%
      select(route_id, user_id, bike, time = date, longitude, latitude) %>%
      mutate(
        route_id = parse_character(route_id),
        user_id = parse_character(user_id),
        bike = as.character(parse_number(bike)),
        time = parse_datetime(time),
        longitude = parse_number(longitude),
        latitude = parse_number(latitude)
      )
    
    data_clean <- data %>%
      na.omit() %>%
      filter(
        format(time, "%Y-%m-%d") == day,
        trunc(longitude) == -72,
        trunc(latitude) == 42
      )
    
    data_anomalous <- anti_join(data, data_clean, by = c("route_id", "time"))
    
    message(nrow(data_anomalous), " anomalous observations found, from a total of ", nrow(data))
    
    if (return == "all") {
      return(data)
    } else if (return == "clean") {
      return(data_clean)
    } else {
      return(data_anomalous)
    }
  })
}