#' get_calibration
#'
#' @param calibration_data STIC calibration data frame with columns "standard" and "conductivity_uncal"
#' @param method method for creating interpolation: "linear" (default) or "exponential"
#'
#' @return fitted model object
#' @export
#'
#' @examples calibration_data <- data(TestData_20946471_Calibration)
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
