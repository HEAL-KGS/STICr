#' validate_stic_data.R
#'
#' @description This function creates two confusion matrices from a classified STIC data frame with the variable names of that produced by `classify_wetdry`, with the addition of two additional columns called `field_SpC` and `field_classification`
#'
#' @param stic_data classified STIC data frame with the variable names of that produced by `classify_wetdry`, with the addition of two additional columns called `field_SpC` and `field_classification`
#' @param include_SpC logical argument where the user specifies if they want a matrix for SpC measurements
#' @param include_classification logical argument where the user specifies if they want a matrix for SpC measurements
#'
#' @return one or two confusion matrices
#' @export
#'
#' @examples data_validation_confusion_matrix <- validate_stic_data <- function(stic_data = classified_stic_with_field_obs, include_SpC = TRUE, include_classification = TRUE

validate_stic_data <- function(stic_data, include_SpC = TRUE, include_classification = TRUE) {

  require(caret)

  if (include_SpC == TRUE) {

    expected_value_SpC <- stic_data$field_SpC
    predicted_value_SpC <- stic_data$SpC

    SpC_confusion_matrix <- confusionMatrix(data = predicted_value_SpC,
                                            reference = expected_value_SpC)

  }

  if (include_classification == TRUE) {

    expected_value_classification <- stic_data$field_classification
    predicted_value_classification <- stic_data$wetdry

    classification_confusion_matrix <- confusionMatrix(data = predicted_value_classification,
                                            reference = expected_value_classification)

  }

  if (include_SpC == TRUE & include_classification == TRUE) {

    confusion_matrix <- list(SpC_confusion_matrix, classification_confusion_matrix)

  } else if (include_classification == TRUE & include_SpC != TRUE) {

    confusion_matrix <- classification_confusion_matrix

} else {


  confusion_matrix <- SpC_confusion_matrix


}

return(confusion_matrix)


}



