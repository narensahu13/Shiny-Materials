# Non-reactive function to create inner_matrix
# second argument for plspm() function 
make_inner <- function(modl=model){
  inner <- t(modl$D)
}