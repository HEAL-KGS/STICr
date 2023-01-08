#' validate_stic_data.R
#'
#' @description This function takes a data frame with field observations of wet/dry status and SpC and generates both a confusion matrix for the wet/dry observations and a scatterplot comparing estimated SpC from the STICs to field-measured values.
#'
#' @param stic_data classified STIC data frame with the variable names of that produced by `classify_wetdry`
#' @param field_observations The input data frame of field observations must include a datetime column (in Posixct format), as well as a column labeled wetdry consisting of the character strings “wet” or “dry” (as in the processed STIC data itself). Additionally, if field data on SpC was collected (e.g., with a sonde), this should be included as a third column called SpC, and units should be in µS/cm.
#'
#' @return A confusion matrix (if just field wet/dry observations are included) and an SpC scatter plot if field measurements of SpC are included.
#' @export
#'
#' @examples data_validation_confusion_matrix <- validate_stic_data(stic_data = classified_stic_with_field_obs, include_SpC = TRUE, include_classification = TRUE)

validate_stic_data <- function(stic_data, field_observations) {

  field_observations <- field_observations %>%
    mutate(datetime = lubridate::round_date(datetime, "15 minutes")) %>%
    rename(wetdry_field = wetdry) %>%
    rename(SpC_field = SpC)


  stic_and_field_obs <- left_join(stic_data, field_obsservations, by = "datetime")

  # Replacing na values in wetdry_field column with blank string
  stic_and_field_obs$wetdry_field[is.na(stic_and_field_obs$wetdry_field)] <- ""
  stic_and_field_obs$SpC_field[is.na(stic_and_field_obs$SpC_field)] <- ""

  false_wet <- sum(stic_and_field_obs$wetdry_field == "dry" & stic_and_field_obs$wetdry == "wet")
  false_dry <- sum(stic_and_field_obs$wetdry_field == "wet" & stic_and_field_obs$wetdry == "dry")

  true_wet <- sum(stic_and_field_obs$wetdry_field == "wet" & stic_and_field_obs$wetdry == "wet")
  true_dry <- sum(stic_and_field_obs$wetdry_field == "dry" & stic_and_field_obs$wetdry == "dry")

  # making confusion matrix data frame from counts
  predicted_positive <- c(true_wet, false_wet)
  predicted_negative <- c(false_dry, true_dry)

  confusion_matrix <- data.frame(predicted_positive, predicted_negative)

  # making row names: "actual_positive" and "actual_negative"
  row.names(confusion_matrix) <- c("actual_positive", "actual_negative")


  return(confusion_matrix)

}



