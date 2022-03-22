# STIC_TestFunctions.R
# Script to test each function in the STIC processing workflow.

library(tidyverse)
library(dplyr)
library(lubridate)

## Step 1: Tidy HOBO data
source("tidy_hobo_data.R")  # load function
raw_hobo_infile <- file.path("TestData", "STIC", "20946489_Raw.csv")
tidy_hobo_outfile <- file.path("TestData", "STIC", "20946489_Tidy.csv")

tidy_data <- tidy_hobo_data(infile = raw_hobo_infile) # test with no saved output
head(tidy_data)

tidy_data <- tidy_hobo_data(infile = raw_hobo_infile, outfile = tidy_hobo_outfile) # test with saved output

head(tidy_data)
file.exists(tidy_hobo_outfile)

# bringing in input
stic_data <- tidy_hobo_data("C:/Users/cwhee/Desktop/R_Directory/AIMS_hydro_qaqc/youngmeyer_stics_round_1/20946471_ENM305.csv")

## Step 2: Get calibration

cal_points <- read_csv("cal_points.csv")

cal_points <- cal_points %>% 
  rename(standard = std_val) %>% 
  rename(conductivity_uncal = measured_val)

calibration_data <- cal_points

calibration <- get_calibration(calibration_data, method = "linear")


## Step 3: Apply calibration

stic_data_with_spc <- apply_calibration(input = stic_data, calibration = calibration)

# Step 4: Classify

classified <- classify_wetdry(stic_data_with_spc)
