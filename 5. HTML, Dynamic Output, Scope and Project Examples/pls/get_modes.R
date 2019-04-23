# Non-reactive function to strip out modes from
# imported SmartPLS model file for each LV
# and return them in an LV-named vector.
get_modes <- function(modl=model){
  # Retrieve names of latent variables
  lv.names <- names(modl$blocks)
  # Get count of number of latent variables
  num.lvs <- length(modl$blocks)
  # Initialize a variable to store
  # names of LVs and their modes
  lv.modes <- numeric(num.lvs)
  # loop through each LV and retrieve model
  for(i in 1:num.lvs){
    # retrieve mode stored as only attribute
    # of each block (same as LV)
    lv.modes[i] <- attributes(modl$blocks[[i]])
    # replace LV component index in lv.modes
    # with the name of the LV for that mode
    names(lv.modes) <- lv.names
  }
  # convert lv.modes list into a named vector
  # of LVs and their modes and return it
  return(unlist(lv.modes))
}