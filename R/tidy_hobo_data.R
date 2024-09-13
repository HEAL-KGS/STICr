#' tidy_hobo_data
#'
#' @description This function loads raw HOBO STIC CSV files and cleans up columns and headers
# to produce a tidy data frame and/or saved CSV output.
#'
#' @param infile filename (including path or URL if needed) for a raw CSV file exported from HOBOware.
#' @param outfile filename (including path if needed) to save the tidied data frame. Defaults to \code{FALSE}, in which case tidied data will not be saved.
#' @param convert_utc a logical argument indicating whether the user would like to convert from the time zone associated with their CSV to UTC
#'
#' @return a tidied data frame with the following column names: \code{datetime}, \code{condUncal}, \code{tempC}.
#' @export
#' @import stringr
#' @import dplyr
#' @import lubridate
#' @importFrom utils read.csv write.csv
#'
#' @examples
#' clean_data <-
#'   tidy_hobo_data(
#'   infile = "https://samzipper.com/data/raw_hobo_data.csv",
#'   outfile = FALSE, convert_utc = TRUE)
#' head(clean_data)
#'

tidy_hobo_data <- function(infile, outfile = FALSE, convert_utc = TRUE) {

  # bind variables
  datetime <- wetdry <- SpC <- condUncal <- tempC <- NULL

  # read in file
  raw_data <- read.csv(infile, skip = 1)

  # get numeric version of number of hours to add from datetime column name
  utc_time_offset <-
    raw_data |>
    dplyr::select(contains("Time")) |>
    colnames() |>
    stringr::str_sub(start = -5, end = -4) |>
    as.numeric()

  raw_data$datetime <- NA

  time_string <- paste0("Time..GMT.0", utc_time_offset, ".00")

  date_time_string <- paste0("Date.Time..GMT.0", utc_time_offset, ".00")

  if ("Date" %in% names(raw_data)) {
    raw_data$datetime <- lubridate::mdy_hms(paste0(raw_data$Date, " ", raw_data[,time_string]))
  } else {
    raw_data$datetime <- lubridate::mdy_hms(raw_data[,date_time_string])
  }

  if (any(str_detect(names(raw_data), "lum"))) {

    tidy_data <-
      raw_data |>
      dplyr::rename_with(.cols = contains("Temp"),
                         .fn = function(x){"tempC"}) |>
      dplyr::rename_with(.cols = contains("Intensity"),
                         .fn = function(x){"condUncal"}) |>
      dplyr::select(datetime, condUncal, tempC) |>
      dplyr::mutate(tempC = as.numeric(tempC),
                    condUncal = gsub(",", "", condUncal),
                    condUncal = as.numeric(condUncal)) |>
      dplyr::mutate(tempC = (tempC - 32) * 5/9) |>
      dplyr::mutate(condUncal = 10.7639104167 * condUncal)

  } else {

    tidy_data <-
      raw_data |>
      dplyr::rename_with(.cols = contains("Temp"),
                         .fn = function(x){"tempC"}) |>
      dplyr::rename_with(.cols = contains("Intensity"),
                         .fn = function(x){"condUncal"}) |>
      dplyr::select(datetime, condUncal, tempC) |>
      dplyr::mutate(tempC = as.numeric(tempC),
                    condUncal = gsub(",", "", condUncal),
                    condUncal = as.numeric(condUncal))

  }

  # UTC conversion if indicated by user
  if (convert_utc == TRUE) {

    tidy_data <- tidy_data |>
      dplyr::mutate(datetime = datetime + (utc_time_offset * 60 * 60))

  }

  # save data if needed
  if (outfile != FALSE) {
    write.csv(tidy_data, outfile, row.names = FALSE)
  }

  return(tidy_data)
}
