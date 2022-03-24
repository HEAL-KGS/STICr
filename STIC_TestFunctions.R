# STIC_TestFunctions.R
# Script to test each function in the STIC processing workflow.

library(tidyverse)
library(dplyr)
library(lubridate)

## Step 1: Tidy HOBO data
source("tidy_hobo_data.R")  # load function
raw_hobo_infile <- file.path("data", "TestData_20946471_Raw.csv")
tidy_hobo_outfile <- file.path("data", "TestData_20946471_Clean.csv")

tidy_data <- tidy_hobo_data(infile = raw_hobo_infile) # test with no saved output
head(tidy_data)

tidy_data <- tidy_hobo_data(infile = raw_hobo_infile, outfile = tidy_hobo_outfile) # test with saved output

head(tidy_data)
file.exists(tidy_hobo_outfile)

## Step 2: Get calibration
source("get_calibration.R")  # load function
cal_input <- read_csv(file.path("data", "TestData_20946471_Calibration.csv"))
head(cal_input)

cal_fit_lin <- get_calibration(cal_input, method = "linear")
summary(cal_fit_lin)

cal_fit_exp <- get_calibration(cal_input, method = "exponential")
summary(cal_fit_exp)

## Step 3: Apply calibration
source("apply_calibration.R")  # load function

tidy_data_with_spc <- apply_calibration(stic_data = tidy_data, calibration = cal_fit_lin) # default linear

head(tidy_data_with_spc)
plot(tidy_data_with_spc$conductivity_uncal, tidy_data_with_spc$SpC)
plot(tidy_data_with_spc$datetime, tidy_data_with_spc$SpC)

tidy_data_with_spc_exp <- apply_calibration(stic_data = tidy_data, calibration = cal_fit_exp) # check exponential

head(tidy_data_with_spc_exp)
plot(tidy_data_with_spc_exp$conductivity_uncal, tidy_data_with_spc_exp$SpC)

# Step 4: Classify
source("classify_wetdry.R")  # load function

tidy_data_classified <- classify_wetdry(stic_data = tidy_data_with_spc, classify_var = "nocolumn") # test error
tidy_data_classified <- classify_wetdry(stic_data = tidy_data_with_spc, classify_var = "SpC") # test classification

head(tidy_data_classified)

library(ggplot2)
ggplot(tidy_data_classified, aes(x = datetime, y = SpC, color = wetdry)) +
  geom_point()
