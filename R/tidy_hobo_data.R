#' tidy_hobo_data
#'
#' @description This function loads raw HOBO STIC CSV files and cleans up columns and headers
# to produce a tidy data frame and/or saved CSV output.
#'
#' @param infile filename (including path or URL if needed) for a raw CSV file exported from HOBOware.
#' @param outfile filename (including path if needed) to save the tidied data frame. Defaults to FALSE, in which case tidied data will not be saved.
#'
#' @return a tidied data frame with the following column names: datetime, condUncal, tempC
#' @export
#'
#' @examples
#' clean_data <- tidy_hobo_data(infile = "https://raw.githubusercontent.com/HEAL-KGS/STICr/main/data/raw_hobo_data.csv", outfile = FALSE)
#' head(clean_data)
#'

tidy_hobo_data <- function(infile, outfile = FALSE) {

  # read in file
  raw_data <- read.csv(infile,
                       skip = 1)

  if ("Date" %in% names(raw_data)) {
    raw_data$datetime <- lubridate::mdy_hms(paste0(raw_data$Date, " ", raw_data$Time..GMT.05.00))
  } else {
    raw_data$datetime <- lubridate::mdy_hms(raw_data$Date.Time..GMT.05.00)
  }

  # tidy columns
  tidy_data <-
    raw_data |>
    dplyr::rename_with(.cols = contains("Temp"),
                       .fn = function(x){"tempC"}) |>
    dplyr::rename_with(.cols = contains("Lux"),
                       .fn = function(x){"condUncal"}) |>
    dplyr::select(datetime, condUncal, tempC) |>
    dplyr::mutate(tempC = as.numeric(tempC),
                  condUncal = as.numeric(condUncal))

  # save data if needed
  if (outfile != FALSE) {
    write.csv(tidy_data, outfile, row.names = FALSE)
  }

  return(tidy_data)
}
