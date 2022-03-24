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

cal_fit <- get_calibration(cal_input, method = "linear")
summary(cal_fit)

## Step 3: Apply calibration
source("apply_calibration.R")  # load function

tidy_data_with_spc <- apply_calibration(stic_data = tidy_data, calibration = cal_fit)

head(tidy_data_with_spc)
plot(tidy_data_with_spc$conductivity_uncal, tidy_data_with_spc$SpC)

# Step 4: Classify

classified <- classify_wetdry(stic_data_with_spc)
