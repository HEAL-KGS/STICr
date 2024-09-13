#' trim_hobo_data
#'
#' @description This function trims a tidied hobo data frame by datetime to eliminate periods where the logger wad recording but not placed
#' in the stream network
#'
#' @param stic_data A data frame with columns named \code{condUncal} and  \code{datetime}, for example as produced by the function \code{tidy_hobo_data}.
#' @param time_start User enters the time at which the logger was placed in the stream network
#' @param time_end User enters the time at which the logger was removed from the stream network
#'
#' @return a tidied data frame with the same columns as the input, but trimmed to the user-defined time
#' @import lubridate
#' @import dplyr
#' @export
#'
#' @examples trimmed_data <-
#'   trim_hobo_data(tidy_stic_data,
#'     time_start = "2021-07-16 18:00:00",
#'     time_end = "2021-07-27 01:00:00"
#'   )
#' head(trimmed_data)
trim_hobo_data <- function(stic_data, time_start = "2021-07-16 18:00:00", time_end = "2021-07-27 01:00:00") {
  # bind variables
  datetime <- NULL

  # change the time_start and time_end arguments to POSIXct using lubridate
  time_start <- lubridate::ymd_hms(time_start)
  time_end <- lubridate::ymd_hms(time_end)

  # filter using time_start and time_end
  stic_data <-
    stic_data |>
    dplyr::filter(datetime >= time_start & datetime <= time_end)

  return(stic_data)
}
