#' test_threshold.R
#'
#' @description This function is intended to allow the user to visually assess the effects of classification threshold uncertainty on STIC classification. It takes the the model object used to calibrate SpC, as well as a classified STIC data frame with column names matching those produced by \link{classify_wetdry}.
#'
#' @param stic_data classified STIC data frame with the variable names of that produced by \link{classify_wetdry}
#' @param calibration the model object used to calibrate SpC, generated by the \link{get_calibration} function and used in \link{apply_calibration}
#'
#' @return A time series plot of classified wet/dry observations through time using three different absolute classification thresholds: the y-intercept of the fitted model developed in get_calibration, the y-intercept plus one standard error, and the y-intercept minus one standard error
#' @import dplyr
#' @import tidyr
#' @importFrom graphics barplot
#' @export
#'
#' @examples lm_calibration <- get_calibration(calibration_standard_data)
#' threshold_testing_plot <- test_threshold(stic_data = classified_df, calibration = lm_calibration)
#'
test_threshold <- function(stic_data, calibration) {
  # bind variables
  SpC <- yint <- yint_plus_se <- yint_minus_se <- Threshold <- classification <- n_wet <-
    n_timesteps <- percent_time_wet <- datetime <- condUncal <- tempC <- datetime <- NULL

  # Extracting y-intercept
  y_int <- calibration$coefficients[2]

  # Extracting and using standard error
  model_summary <- summary(calibration)
  se <- model_summary$sigma

  y_int_plus_se <- y_int + se
  y_int_minus_se <- y_int - se

  # Now can make a df for plotting by classifying according the the three absolute thresholds
  threshold_df <-
    stic_data |>
    dplyr::mutate(yint = dplyr::if_else(SpC >= y_int, "wet", "dry")) |>
    dplyr::mutate(yint_plus_se = dplyr::if_else(SpC >= y_int_plus_se, "wet", "dry")) |>
    dplyr::mutate(yint_minus_se = dplyr::if_else(SpC >= y_int_minus_se, "wet", "dry"))

  # Reshaping this for categorical plotting
  threshold_long <-
    threshold_df |>
    tidyr::pivot_longer(
      cols = c(yint, yint_plus_se, yint_minus_se),
      names_to = "Threshold", values_to = "classification"
    )

  # Making a time series bar graph of wet network proportion, with bars for y-int,
  # y-int plus standard error, and y-int minus standard error
  wet_network_prop <-
    threshold_long |>
    dplyr::group_by(Threshold) |>
    dplyr::summarise(
      n_wet = sum(classification == "wet"),
      n_timesteps = dplyr::n()
    ) |>
    dplyr::mutate(percent_time_wet = n_wet / n_timesteps)

  wnp_subset <-
    wet_network_prop |>
    dplyr::select(Threshold, percent_time_wet)

  wnp_subset_transpose <-
    wnp_subset |>
    tidyr::pivot_wider(names_from = Threshold, values_from = percent_time_wet)

  wnp_matrix <- as.matrix(wnp_subset_transpose)

  # make bar chart showing the impacts of classification threshold
  threshold_plot <-
    barplot(wnp_matrix,
      ylab = "% of Time Wet",
      xlab = "Threshold for Wet Classification"
    )

  return(threshold_plot)
}
