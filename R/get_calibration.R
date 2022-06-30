#' get_calibration
#'
#' @param calibration_data STIC calibration data frame with columns "standard" and "conductivity_uncal"
#' @param method method for creating interpolation: "linear" (default) or "exponential"
#'
#' @return fitted model object
#' @export
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
