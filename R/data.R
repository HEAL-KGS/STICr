#' Example tidied STIC output data.
#'
#' Example tidied STIC data for input to calibration and classification process.
#'
#' @format ## `tidy_stic_data`
#' A data frame with 1000 rows and 3 columns:
#' \describe{
#'   \item{datetime}{Date and time of measurement.}
#'   \item{condUncal}{Raw uncalibrated conductivity recorded by STIC logger.}
#'   \item{tempC}{Temperature recorded by STIC logger.}
#' }
#' @source AIMS project data.
"tidy_stic_data"

#' Example calibrated STIC output data.
#'
#' Calibrated STIC data used for function examples.
#'
#' @format ## `calibrated_stic_data`
#' A data frame with 1000 rows and 4 columns:
#' \describe{
#'   \item{datetime}{Date and time of measurement.}
#'   \item{condUncal}{Raw uncalibrated conductivity recorded by STIC logger.}
#'   \item{tempC}{Temperature recorded by STIC logger.}
#'   \item{SpC}{Specific conductance calculated using `apply_calibration` function.}
#' }
#' @source AIMS project data.
"calibrated_stic_data"

#' Example classified STIC output data.
#'
#' Classified STIC data used for function examples.
#'
#' @format ## `classified_df`
#' A data frame with 1000 rows and 5 columns:
#' \describe{
#'   \item{datetime}{Date and time of measurement.}
#'   \item{condUncal}{Raw uncalibrated conductivity recorded by STIC logger.}
#'   \item{tempC}{Temperature recorded by STIC logger.}
#'   \item{SpC}{Specific conductance calculated using `apply_calibration` function.}
#'   \item{wetdry}{Classified STIC data created by `classify_wetdry` function.}
#' }
#' @source AIMS project data.
"classified_df"

#' Example calibration STIC lab data.
#'
#' Example calibration data for STIC sensor for conversion from uncalibrated conductivity to specific conductivity (`SpC`).
#'
#' @format ## `calibration_standard_data`
#' A data frame with 4 rows and 3 columns:
#' \describe{
#'   \item{sensor}{Serial number for STIC sensor.}
#'   \item{standard}{Specific conductance (`SpC`) standard values used for soaking STIC.}
#'   \item{condUncal}{Uncalibrated conductivity recorded by STIC when soaked in each standard.}
#' }
#' @source AIMS project data.
"calibration_standard_data"

#' Example field observations that could be compared to classified STIC data.
#'
#' @format ## `field_obs`
#' A data frame with 5 rows and 3 columns:
#' \describe{
#'   \item{datetime}{Date and time of field observation.}
#'   \item{wetdry}{Field observation of stream water status (`wet` or `dry`).}
#'   \item{SpC}{Field observations of specific conductance.}
#' }
#' @source Made up data.
"field_obs"
