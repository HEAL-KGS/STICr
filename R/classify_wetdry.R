#' classify_wetdry
#'
#' @param stic_data A data frame with STIC data, such as that produced by `apply_calibration` or `tidy_hobo_data`
#' @param classify_var A column name of the column in data frame you want to use for classification.
#                   Defaults to "SpC" which would be the output from `apply_calibration` function.
#' @param threshold An absolute numerical threshold for classifying wet vs dry
#'
#' @return The same data frame as input, but with a new column called wetdry
#' @export
#'
classify_wetdry <- function(stic_data, classify_var = "spc", threshold = 200) {

  # extract classify variable
  if (!(classify_var %in% names(stic_data))) stop(paste0("classify_var input (", classify_var, ") is not present in stic_data"))
  class_var <- stic_data[ ,classify_var]

  # classify and add to data frame
  stic_data$wetdry <- if_else(class_var >= threshold, "wet", "dry" )

  return(stic_data)
}
