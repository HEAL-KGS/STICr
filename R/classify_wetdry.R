#' classify_wetdry
#'
#' @description This is a function to classify STIC data into a binary "wet" and "dry" column. Data can be classified according to any classification variable defined by the user. User can choose one of two methods for classification: either an absolute numerical threshold or as a chosen percentage of the maximum value of the classification variable.
#'
#' @param stic_data A data frame with STIC data, such as that produced by `apply_calibration` or `tidy_hobo_data`
#' @param classify_var Name of the column in data frame you want to use for classification.
#                   Defaults to `SpC` which would be the output from `apply_calibration` function.
#' @param method User chooses which classification method used to generate the binary data. "absolute" uses an absolute numerical threshold for classifying wet vs dry. "percent" uses a threshold based on a given percentage of the maximum value of the classification variable in the data frame. "y-intercept" uses the y-intercept from the `get_calibration` function
#' @param threshold This is the user-defined threshold for determining wet versus dry based on the designated classification variable. If using the "absolute" method, the threshold will be a value in the same units as the designated classification variable. If using the "percent" method, the value will be a decimal percentage of the max value of the classification variable in the data frame. Values above this proportion of the maximum will be designated as wet.
#'
#' @return The same data frame as input, but with a new column called `wetdry`.
#' @export
#'
#' @examples classified_df <- classify_wetdry(calibrated_stic_data, classify_var = "SpC", method = "absolute", threshold = 200)
#' head(classified_df)

classify_wetdry <- function(stic_data, classify_var = "SpC", threshold = 200, method = "absolute") {

 class_var <- stic_data[ , classify_var]

  if (method == "percent") {

    # classify and add to data frame
    stic_data$wetdry <- dplyr::if_else(class_var >= (threshold * max(classify_var)), "wet", "dry" )

  } else if (method == "absolute") {

    #classify and add to data frame
    stic_data$wetdry <- dplyr::if_else(class_var >= threshold, "wet", "dry" )

  } else if (method == "y-intercept") {

    y_int <- threshold$coefficients[2]

    stic_data$wetdry <- dplyr::if_else(class_var >= y_int, "wet", "dry")

} else {

    stop("Unknown method. Please use absolute or percent.")

  }

  return(stic_data)
}
