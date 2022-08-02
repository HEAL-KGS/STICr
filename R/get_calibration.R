#' get_calibration
#'
#' @description This is a function to fit specific conductivity (`SpC`) standards and uncalibrated conductivity measured by the STIC to a model object. This model can then be used to predict SpC values using `apply_calibration`.
#'
#' @param calibration_data STIC calibration data frame with columns "standard" and "condUncal"
#' @param method method for creating interpolation: "linear" (default) or "exponential"
#'
#' @return A fitted model object relating `SpC` to the uncalibrated conductivity values measured by the STIC
#' @export
#'
#' @examples head(calibration_standard_data)
#' lm_calibration <- get_calibration(calibration_standard_data, method = "linear")
#' summary(lm_calibration)
#'
get_calibration <- function(calibration_data, method = "linear") {

  if (is.na(calibration_data$standard) | is.na(calibration_data$standard)) {
    calibration <- print("No data available to make calibration model")
  }

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
