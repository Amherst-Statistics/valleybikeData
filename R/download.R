# =================================================================================================
# download_files
# =================================================================================================
#
#' Download raw data files
#'
#' Download all available .csv.gz raw trajectory data files for the years 2018-2020 into a specified
#' directory.
#'
#' @title download_files
#'
#' @param path The path where to download the data files.
#' @param overwrite Whether to overwrite the existing files at the given path. Defaults to \code{FALSE}.
#'
#' @examples
#' \dontrun{
#' download_files(path = "~/Desktop/raw-data")
#' }
#'
#' @export
download_files <- function(path, overwrite = FALSE) {

  if (!dir.exists(path)) {
    stop("Invalid destination path.")
  }

  root <- "https://nhorton.people.amherst.edu/valleybikes/"

  file_pattern <- "VB_Routes_Data_[0-9]{4}_[0-9]{2}_[0-9]{2}\\.csv(\\.gz){0,1}"

  files <- root %>%
    readLines() %>%
    stringr::str_extract_all(pattern = file_pattern) %>%
    unlist()

  existing_files <- list.files(path)

  if (!overwrite) {
    files <- files[!(files %in% existing_files)]
  }

  if (length(files) == 0) {
    stop("Nothing new to download.")
  }

  urls <- paste0(root, files)

  destination_files <- file.path(path, files)

  confirmation <- paste0("Will download ", length(files), " files to ", path, ". Proceed? [y/n] ")

  if (readline(prompt = confirmation) != "y") {
    stop("Download aborted.")
  }

  mapply(download.file, urls, destination_files)
}
