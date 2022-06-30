#' apply_calibration
#'
#' @param stic_data A data frame with a column named `conductivity_uncal`, for example as produced by the function `tidy_hobo_data`.
#' @param calibration a model object relating `conductivity_uncal` to a standard of some sort, for example as produced by the function `get_calibration`.
#'
#' @return The same data frame as input, except with a new column called `SpC`. This will be in the same units as the data used to develop the model calibration.
#' @export
#'
#' @examples stic_data <- read.csv("data/TestData_20946471_Clean.csv")
#' calibration_data <- read.csv("data/TestData_20946471_Calibration.csv")
#' calibration <- get_calibration(calibration_data, method = "linear")
#' calibrated_df <- apply_calibration(stic_data, calibration)
#' head(calibrated_df)
#'
apply_calibration <- function(stic_data, calibration) {

  # apply fitted model to STIC data
  just_spc <- predict(object = calibration, newdata = stic_data)

  # add new column to data frame
  stic_data$spc <- just_spc

  return(stic_data)
}
