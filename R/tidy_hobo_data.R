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
#'
#' @examples
#' clean_data <- tidy_hobo_data(infile = "https://raw.githubusercontent.com/HEAL-KGS/STICr/main/data/raw_hobo_data.csv", outfile = FALSE, convert_utc = TRUE)
#' head(clean_data)
#'

infile <- "20210915_20946486_STIC.csv"

tidy_hobo_data <- function(infile, outfile = FALSE, convert_utc = TRUE) {

  # read in file
  raw_data <- read.csv(infile, skip = 1)

  # get numeric version of number of hours to add from datetime column name
  utc_time_offset <-
    raw_data |>
    dplyr::select(contains("Time")) |>
    colnames() |>
    str_sub(start = -5, end = -4) |>
    as.numeric()

  if ("Date" %in% names(raw_data)) {
    logger_record$datetime <- mdy_hms(paste0(logger_record$Date, " ", logger_record$Time..GMT.05.00))
  } else {
    logger_record$datetime <- mdy_hms(logger_record$Date.Time..GMT.05.00)
  }

  if ("lum" %in% names(raw_data)) {

    tidy_data <-
      raw_data |>
      dplyr::rename_with(.cols = contains("Temp"),
                         .fn = function(x){"tempC"}) |>
      dplyr::rename_with(.cols = contains("Intensity"),
                         .fn = function(x){"condUncal"}) |>
      dplyr::rename_with(.cols = contains("Date"),
                         .fn = function(x){"datetime"}) |>
      dplyr::select(datetime, condUncal, tempC) |>
      dplyr::mutate(datetime = lubridate::mdy_hms(datetime)) |>
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
      dplyr::rename_with(.cols = contains("Date"),
                         .fn = function(x){"datetime"}) |>
      dplyr::select(datetime, condUncal, tempC) |>
      dplyr::mutate(datetime = lubridate::mdy_hms(datetime)) |>
      dplyr::mutate(tempC = as.numeric(tempC),
                    condUncal = gsub(",", "", condUncal),
                    condUncal = as.numeric(condUncal))
  }

  # tidy columns and names
  tidy_data <-
    raw_data |>
    dplyr::rename_with(.cols = contains("Temp"),
                       .fn = function(x){"tempC"}) |>
    dplyr::rename_with(.cols = contains("Intensity"),
                       .fn = function(x){"condUncal"}) |>
    dplyr::rename_with(.cols = contains("Date"),
                       .fn = function(x){"datetime"}) |>
    dplyr::select(datetime, condUncal, tempC) |>
    dplyr::mutate(datetime = lubridate::mdy_hms(datetime)) |>
    dplyr::mutate(tempC = as.numeric(tempC),
                  condUncal = gsub(",", "", condUncal),
                  condUncal = as.numeric(condUncal))

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
