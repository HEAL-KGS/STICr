#' classify_wetdry
#'
#' @description This is a function to classify STIC data into a binary "wet" and "dry" column. Data can be classified according to any classification variable defined by the user. User can choose one of two methods for classification: either an absolute numerical threshold or as a chosen percentage of the maximum value of the classification variable.
#'
#' @param stic_data A data frame with STIC data, such as that produced by \link{apply_calibration} or \link{tidy_hobo_data}.
#' @param classify_var Name of the column in data frame you want to use for classification.
#' @param method User chooses which classification method used to generate the binary data. \code{"absolute"} uses an absolute numerical threshold for classifying wet vs dry. \code{"percent"} uses a threshold based on a given percentage of the maximum value of the classification variable in the data frame. \code{"y-intercept"} uses the y-intercept from the \link{get_calibration} function.
#' @param threshold This is the user-defined threshold for determining wet versus dry based on the designated classification variable. If using the \code{"absolute"} method, the threshold will be a value in the same units as the designated classification variable. If using the \code{"percent"} method, the value will be a decimal percentage (range 0-1) of the max value of the classification variable in the data frame. Values above this proportion of the maximum will be designated as wet. If using the \code{"y-intercept"} method, this should be a model fit used to generate calibrated \code{SpC} values such as that produced by \link{get_calibration}.
#'
#' @return The same data frame as input, but with a new column called \code{"wetdry"}.
#' @export
#' @import dplyr
#' @importFrom methods is
#'
#' @examples classified_df <-
#'   classify_wetdry(calibrated_stic_data,
#'   classify_var = "SpC", method = "absolute", threshold = 200)
#' head(classified_df)

classify_wetdry <- function(stic_data, classify_var, threshold, method) {

  # check if classify_var exists
  if (!(classify_var %in% colnames(stic_data))) stop("classify_var is not in stic_data")

 class_var <- stic_data[ , classify_var]

  if (method == "percent") {

    if ((threshold > 1) | (threshold < 0)) stop("Error - threshold should be between 0-1")

    # calculate what threshold is in absolute units
    abs_thres <- threshold*max(class_var)

    # classify and add to data frame
    stic_data$wetdry <- dplyr::if_else(class_var >= abs_thres, "wet", "dry" )

  } else if (method == "absolute") {

    # classify and add to data frame
    stic_data$wetdry <- dplyr::if_else(class_var >= threshold, "wet", "dry" )

  } else if (method == "y-intercept") {

    if (!is(threshold, "lm")) stop("Error - threshold should be a fitted lm model")

    y_int <- threshold$coefficients[2]

    stic_data$wetdry <- dplyr::if_else(class_var >= y_int, "wet", "dry")

} else {

    stop("Unknown method. Please use absolute, percent, or y-intercept.")

  }

  return(stic_data)
}
