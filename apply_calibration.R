# apply_calibration.R
#inputs: calibration (a model object) and a data frame with columns labeled "datetime", "temperature" "conductivity_uncal"
# output: same data frame as input, except with a new column called "spc"

apply_calibration <- function(input, calibration) {
  
  just_cond <- input %>% 
    select(conductivity_uncal)
  
  just_spc <- predict(calibration, just_cond)
  
  input$spc <- just_spc
  
  return(input)
  
}





