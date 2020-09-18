import_full <- function() {
  
  clust <- parallel::makeCluster(parallel::detectCores())
  
  all_files <- paste0("data-raw/files/", list.files(path = "data-raw/", pattern = "*.csv.gz"))
  
  files <- all_files[file.info(all_files)$size > 1000]

  full_data <- parallel::parLapply(clust, files, data.table::fread, skip = 2) %>%
    data.table::rbindlist() %>%
    janitor::clean_names()
  
  return(full_data)
}

import_day <- function(day, return = c("all", "clean", "anomalous")) {
  
  suppressWarnings({
    
    day_string <- gsub("-", "_", day)
    
    filepath <- paste0("files/VB_Routes_Data_", day_string, ".csv.gz")
    
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