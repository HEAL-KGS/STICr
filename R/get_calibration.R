#' get_calibration
#'
#' @description Function to fit SpC standards and uncalibrated conductivity measured by the STIC to a model object. This model will then be used to predict SpC values using 'apply_calibration'
#'
#' @param calibration_data STIC calibration data frame with columns "standard" and "conductivity_uncal"
#' @param method method for creating interpolation: "linear" (default) or "exponential"
#'
#' @return A fitted model object relating SpC to the uncalibrated conductivity values measured by the STIC
#' @export
#'
#' @examples calibration_data <- calibration_standard_data
#' lm_calibration <- get_calibration(calibration_data, method = "linear")
#' View(lm_calibration)
#'
get_calibration <- function(calibration_data, method = "linear") {

  if (method == "exponential") {

    calibration <- lm(log(standard) ~ conductivity_uncal, data = calibration_data)

  } else if (method == "linear") {

    calibration <-  lm(standard ~ conductivity_uncal, data = calibration_data)

  } else {

    calibration <- print("Unknown method. Please use linear or exponential.")
  }

  return(calibration)
}
