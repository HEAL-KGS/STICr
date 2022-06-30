#' tidy_hobo_data
#'
#' @param infile filename (including path if needed) for the raw HOBO data on your computer.
#' @param outfile filename (including path if needed) to save the tidied. Defaults to FALSE, in which case tidied data will not be saved.
#'
#' @return a tidied data frame
#' @export
#'
#' @examples
#' tidy_df <- tidy_hobo_data(infile = "https://raw.githubusercontent.com/HEAL-KGS/STICr/main/data/TestData_20946471_Raw.csv", outfile = FALSE)
#' head(tidy_df)
#'
tidy_hobo_data <- function(infile, outfile = FALSE) {

  # read in file
  raw_data <- read.csv(infile,
                       skip = 1)

  # tidy columns
  tidy_data <-
    raw_data %>%
    dplyr::rename_with(.cols = contains("Temp"),
                       .fn = function(x){"temperature"}) %>%
    dplyr::rename_with(.cols = contains("Lux"),
                       .fn = function(x){"conductivity_uncal"}) %>%
    dplyr::rename_with(.cols = contains("Date"),
                       .fn = function(x){"datetime"}) %>%
    dplyr::select(datetime, conductivity_uncal, temperature) %>%
    dplyr::mutate(datetime = lubridate::mdy_hms(datetime),
                  temperature = as.numeric(temperature),
                  conductivity_uncal = as.numeric(conductivity_uncal))

  # save data if needed
  if (outfile != FALSE) {
    write.csv(tidy_data, outfile, row.names = FALSE)
  }

  return(tidy_data)
}
