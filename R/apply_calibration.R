#' apply_calibration
#'
#' @description This function takes the cleaned data frame generated by \code{tidy_hobo_data} and the fitted model object generated by \code{get_calibration}. It outputs a data frame with the same columns as the input, plus a calibrated specific conductivity column called SpC.
#'
#' @param stic_data A data frame with a column named \code{condUncal}, for example as produced by the function \link{tidy_hobo_data}.
#' @param calibration a model object relating \code{condUncal} to a standard of some sort, for example as produced by the function \link{get_calibration}.
#' @param outside_std_range_flag a logical argument indicating whether the user would like to include an additional column flagging instances where the calibrated SpC value is outside the range of standards used to calibrate it
#'
#' @return The same data frame as input, except with a new column called \code{SpC}. This will be in the same units as the data used to develop the model calibration.
#' @import dplyr
#' @importFrom stats lm predict
#' @importFrom methods is
#' @export
#'
#' @examples calibration <- get_calibration(calibration_standard_data)
#' calibrated_df <- apply_calibration(tidy_stic_data, calibration, outside_std_range_flag = TRUE)
#' head(calibrated_df)
#'
apply_calibration <- function(stic_data, calibration, outside_std_range_flag = TRUE) {
  # check that lm model is correct
  if (!is(calibration, "lm")) stop("Error - calibration should be a fitted lm model")

  # apply fitted model to STIC data
  just_spc <- predict(object = calibration, newdata = stic_data)

  # add new column to data frame
  stic_data$SpC <- just_spc

  if (outside_std_range_flag == TRUE) {
    # Extract max and min of calibration standards from model object
    model_data <- calibration$model
    standards <- model_data$standard
    min_standard <- min(standards, na.rm = TRUE)
    max_standard <- max(standards, na.rm = TRUE)

    # Create outside range column with mutate
    stic_data$outside_std_range <- dplyr::if_else(stic_data$SpC >= max_standard | stic_data$SpC <= min_standard,
      "O", ""
    )
  }

  return(stic_data)
}
