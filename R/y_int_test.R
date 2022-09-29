library(tidyverse)
library(devtools)

devtools::install()
devtools::load_all()

library(STICr)


data("tidy_stic_data")


?get_calibration

data("calibration_standard_data")

head(calibration_standard_data)
lm_calibration <- get_calibration(calibration_standard_data, method = "linear")
summary(lm_calibration)

?apply_calibration

lm_calibration <- get_calibration(calibration_standard_data, method = "linear")
calibrated_df <- apply_calibration(tidy_stic_data, lm_calibration)
head(calibrated_df)


lm_calibration$coefficients[1]
