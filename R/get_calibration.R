#' get_calibration
#'
#' @description This is a function to fit specific conductivity (\code{SpC}) standards and uncalibrated conductivity measured by the STIC to a model object. This model can then be used to predict SpC values using \link{apply_calibration}. As of right now, only linear models are supported.
#'
#' @param calibration_data STIC calibration data frame with columns \code{"standard"} and \code{"condUncal"}.
#'
#' @return A fitted \code{lm} model object relating \code{SpC} to the uncalibrated conductivity values measured by the STIC
#' @export
#'
#' @examples head(calibration_standard_data)
#' lm_calibration <- get_calibration(calibration_standard_data)
#' summary(lm_calibration)
#'
get_calibration <- function(calibration_data) {
  calibration <- lm(standard ~ condUncal, data = calibration_data)

  return(calibration)
}
