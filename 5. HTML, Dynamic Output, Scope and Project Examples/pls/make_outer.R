# Non-reactive function to create outer_list
# third argument for plspm() function
make_outer <- function(modl=model,d=data){
  # initialize outer as a list
  outer <- list()
  # counts number of blocks 
  # (latent variables) in the model
  nblocks <- length(modl$blocks)
  # initializes z
  z <- numeric(nblocks)
  # initial df object to hold output
  # vectors for LV mv positions in data
  comp <- data.frame()
  # loop thru nblocks counting number mv's
  for(i in 1:nblocks){
    # store number mvs per block in z[i]
    z[i] <- length(modl$blocks[[i]])
    # find positions in data for mvs
    for(j in 1:z[i]){
      data.index <- grep((modl$blocks[[i]][j]),names(d))
      # store as rows in comp
      comp[i,j] <- data.index
    }
  }
  # transpose rows and columns in comp
  df <- t(comp)
  for(i in 1:nblocks){
    vec <- unname(df[,i])
    vec <- c(na.omit(vec))
    outer[[i]] <- vec
  }
  return(outer)
}
