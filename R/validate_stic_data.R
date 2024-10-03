#' validate_stic_data.R
#'
#' @description This function takes a data frame with field observations of wet/dry status and SpC and generates both a confusion matrix for the wet/dry observations and a scatterplot comparing estimated SpC from the STICs to field-measured values.
#'
#' @param stic_data classified STIC data frame with the variable names of that produced by \link{classify_wetdry}. At a minimum, there must be \code{datetime} and \code{wetdry} columns, and an \code{SpC} column if \code{get_SpC = T}.
#' @param field_observations The input data frame of field observations must include a \code{datetime} column (in POSIXct format), as well as a column labeled \code{wetdry} consisting of the character strings “wet” or “dry” (as in the processed STIC data itself). Additionally, if field data on SpC was collected (e.g., with a sonde), this should be included as a third column called \code{SpC}, and units should be in µS/cm.
#' @param max_time_diff Maximum allowed time difference (in minutes) between field observation and STIC reading to be counted as a match.
#' @param join_cols A named vector of columns that need to be matched between \code{stic_data} and \code{field_observations} in addition to datetime. This could include, for instance, a column specifying the site at which the observation was collected. Should be in the format of \code{c("col_name_in_stic_data" = "col_name_in_field_observations")} and can have as many columns as desired. If there are no additional columns to be matched, set to \code{NULL}.
#' @param get_SpC Logical flag whether to get STIC data for SpC (\code{T}) or not (\code{T}). You must have an \code{SpC} column in both \code{stic_data} and \code{field_observations} if this is used.
#'
#' @return The \code{field_observations} data frame with new columns indicating the closest-in-time STIC wetdry classification (\code{wetdry_STIC}), SpC measurement (\code{SpC_STIC}; only if \code{get_SpC = T}), and time difference between the field observation and STIC reading (\code{timediff_min}).
#' @export
#'
#' @examples stic_validation <-
#'   validate_stic_data(
#'     stic_data = classified_df,
#'     field_observations = field_obs,
#'     max_time_diff = 30,
#'     join_cols = NULL,
#'     get_SpC = TRUE
#'   )
validate_stic_data <- function(stic_data, field_observations, max_time_diff, join_cols, get_SpC) {

  # bind variables
  datetime <- wetdry <- SpC <- timediff_min <- NULL

  # check input data for potential issues
  if (sum(!(names(join_cols) %in% names(stic_data))) > 0) stop("One or more of your join_cols names is not in stic_data")
  if (sum(!(join_cols %in% names(field_observations))) > 0) stop("One or more of your join_cols names is not in field_observations")

  if (get_SpC & !("SpC" %in% names(stic_data))) stop("get_SpC = T but no SpC column in stic_data")
  if (get_SpC & !("SpC" %in% names(field_observations))) stop("get_SpC = T but no SpC column in field_observations")

  # rename field observations as needed
  field_observations <-
    field_observations |>
    dplyr::rename(any_of(c(wetdry_obs = "wetdry",
                           SpC_obs = "SpC",
                           join_cols)))

  # initialize fields to get from STIC data
  field_observations$wetdry_STIC <- NA
  if (get_SpC) field_observations$SpC_STIC <- NA
  field_observations$timediff_min <- NA

  # for each field observation, find closest field measurement
  for (i in 1:length(field_observations$wetdry_obs)){
    # get time of field observation
    time_obs <- field_observations$datetime[i]

    # subset stic data based on other join columns
    stic_data_sub <- stic_data
    if (!is.null(join_cols)){
      for (k in 1:length(join_cols)){
        stic_data_sub <- stic_data_sub[stic_data_sub[, names(join_cols)[k]] == as.character(field_observations[i, names(join_cols)[k]]), ]
      }
    }

    # get observation and time difference
    j_closest <- which.min(abs(stic_data_sub$datetime - time_obs))
    t_diff <- as.numeric(difftime(time_obs, stic_data_sub$datetime[j_closest], units = "mins"))

    # add observation
    if (length(t_diff) > 0){
      field_observations$wetdry_STIC[i] <- stic_data_sub$wetdry[j_closest]
      if (get_SpC) field_observations$SpC_STIC[i] <- stic_data_sub$SpC[j_closest]
      field_observations$timediff_min[i] <- t_diff
    }

  }

  # get rid of any with timediff exceeding threshold or NA timediff
  df_validation <- subset(field_observations, abs(timediff_min) < max_time_diff)

  return(df_validation)
}
