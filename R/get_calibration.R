#' get_calibration
#'
#' @description This is a function to fit specific conductivity (\code{SpC}) standards and uncalibrated conductivity measured by the STIC to a model object. This model can then be used to predict SpC values using \link{apply_calibration}.
#'
#' @param calibration_data STIC calibration data frame with columns \code{"standard"} and \code{"condUncal"}.
#' @param method method for creating interpolation: \code{"linear"} (default) or \code{"exponential"}.
#'
#' @return A fitted model object relating \code{SpC} to the uncalibrated conductivity values measured by the STIC
#' @export
#'
#' @examples head(calibration_standard_data)
#' lm_calibration <- get_calibration(calibration_standard_data, method = "linear")
#' summary(lm_calibration)
#'

get_calibration <- function(calibration_data, method = "linear") {

  if (method == "exponential") {

    log_standard <- log(standard)

    calibration <- lm(log_standard ~ condUncal, data = calibration_data)

  } else if (method == "linear") {

    calibration <-  lm(standard ~ condUncal, data = calibration_data)

  } else {

    calibration <- print("Unknown method. Please use linear or exponential.")
  }

  return(calibration)
}
