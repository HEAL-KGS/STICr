library(tidyverse)
library(devtools)

devtools::install_github("HEAL-KGS/STICr")

library(STICr)

#======================================================================================================
#======================================================================================================
# trying to fix anomaly detection

classified_df <- classified_df
test_df <- classified_df
# MAXIMUM three dry obs surrounded by MINIMUM 100 wet on either side
test_df[340:342, 5] <-  "dry"

anomaly_size <- 3
window_size <- 100

# need to use lag, unique, and length

# base R version of rleid

library(data.table)
DT = data.table(grp=rep(c("A", "B", "C", "A", "B"), c(2, 2, 3, 1, 2)), value=1:10)
rleid(DT$grp)


df <- data.frame(DT)
df$run_length <- rep(seq_along(rle(df$grp)$values), times = rle(df$grp)$lengths)

#==================================================================================================
#==================================================================================================
#==================================================================================================
x <- rev(rep(6:10, 1:5))

x

test <- rle(x)

test$lengths

test$values

x <- data.frame(x)

#==================================================================================================


# This is working

rm(test_stack)

test_stack <- dplyr::group_by(test_df, data.table::rleid(wetdry)) %>%
  dplyr::mutate(n = n()) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(anomaly_tf = wetdry != lag(wetdry, 1, default = "")
                & wetdry != lead(wetdry, 1, default = "")
                & lag(n, 1, default = 0) > 1000 & lead(n, 1, default = 0) > 1000)

test_stack$anomaly <- dplyr::if_else(test_stack$anomaly_tf == TRUE, "B", "" )

# try to break this is up
rm(test_stack)

test_stack <- dplyr::group_by(test_df, data.table::rleid(wetdry))

test_stack <- test_stack %>%
  dplyr::mutate(n = n())

test_stack <- test_stack %>%
  dplyr::ungroup()

test_stack <- test_stack %>%
  dplyr::mutate(anomaly_tf = wetdry != lag(wetdry, 1, default = "")
                & wetdry != lead(wetdry, 1, default = "")
                & lag(n, 1, default = 0) > 1000 & lead(n, 1, default = 0) > 1000)


test_df$lag <- lag(test_stack$wetdry, 1)
?lag
?lead
?unique
?length

#======================================================================================================
#======================================================================================================
# trying to figure out time issue

# read in file
df <- read.csv("20946487.csv", skip = 1)

# get numeric version of number of hours to add from datetime column name
time_offset <- df %>%
  select(contains("Date")) %>%
  colnames() %>%
  str_sub(start = -5, end = -4) %>%
  as.numeric()

# testing
df <- tidy_hobo_data("20946487.csv")

df_2 <- tidy_hobo_data("20946487.csv", convert_utc = FALSE)
#======================================================================================================

