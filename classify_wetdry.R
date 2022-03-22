# classify_wetdry.R
# Classify wetdry function (start with absolute threshold)
# inputs: data frame with columns "datetime", "temperature", "conductivity", and "specific_conductivity"
# output: same data frame as input, but with a new column called wetdry

classify_wetdry <- function(input, threshold = 1000) {
  
input <- input %>% 
  dplyr::mutate(wetdry = if_else(conductivity_uncal >= threshold, "wet", "dry" ))

}

