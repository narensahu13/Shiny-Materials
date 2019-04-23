###########################################################

############## USER-DEFINED FUNCTIONS IN R   ##############

###########################################################

## Discusses creation of functions, their rules,
## how they relate to and communicate with the
## environments from which they are called.

# 4.1 FUNCTIONS p. 63

## GO TO - SHOW SLIDE # 1 FIRST

# A function has the form
# 
# name <- function(argument_1, argument_2, ...) {
#     expression_1
#     expression_2
#     ...
#     return(output) # optional but preferred
# }
#
# Here argument_1, argument_2 are variables and
# expression_1, expression_2, and output are all
# regular R expressions. name is the name of the 
# function. A function may have no arguments.
# Braces are optional with only one expression.
# 
# To call or run the function we type
# 
# name(x1, x2, ...)
# 
# The value of this expression is the value of the
# expression output.
#
# 1)Function may have more than one return statement
#   in which case it stops executing after reaching 
#   the first one.
#
# 2)If no return(output) statement, the last thing
#   done (and returned) is the last statment in
#   in the braces.
#
# 3)Function always returns a value (can be NULL)
#
# 4)Like an expression, value returned is printed
#   if not assigned to a variable.

## Scope and its consequences; p. 68

# Arguments and variables defined within a function
# exist only within that function. If variables
# w/ same name exist in and out, they do not
# interact or affect each other at all. Is two 
# separate environments. The function environment
# only communicates with the outside world through
# values of its arguments, and output expression.

# For example, if you execute command rm(list=ls())
# inside a function, you only delete those objects
# that are defined inside the function.

rm(list=ls())
test <- function(x) {
    y <- x + 1
    return(y)
}
test(1)
x
y
y <- 10
test(1)
y

# Part of program in which variable is defined is
# its 'scope'. Variables called within a function
# do not modify samed-named variables outside.

# HOWEVER!!! This scope is not symmetric....
# Variables defined inside a function cannot be
# seen outside, but variables defined outside
# can be seen inside the function (as long as
# there is not a same-named variable inside.

# This opens the door to creative programming
# opportunities as we will see with recursive
# programming.

# Also makes it possible to write a function
# whose behavior depends on the context in
# which it is run. For example, consider:

test2 <- function(x) {
    y <- x + z
    return(y)
}
z <- 1
test2(1)

z <- 2
test2(1)

# Moral: value returned with same value passed into
# the function changes based on value of z outside.
# 'outside' means the "global environment"; BUT
# ONLY BECAUSE Z IS ABSENT INSIDE THE FUNCTION.

# REMEMBER THIS for exercise "random.sum" later

# So called 'lexical scope': z is unbound variable.
# R attempts to resolve in the local environment, then
# in the enclosure to that function, working it way
# 'out' to the global environment.

# EXAMPLE SCOPING RULE p. 8 SLIDES

cube <- function(n) {
  sq <- function() n*n
  cb <- n*sq()
 }
cube(3)

# Note that variable n in function sq() is
# not an argument to that function. It is a free
# variable and scoping rules determine its
# value from the value in outside function cube().

## Optional arguments and default values. p. 70

# If any argument has a default value within a function,
# then it may be omitted when calling the function.
# Then the default value is used.

# However, omitting an argument can cause ambiguity
# about which arguments are assigned to which variables.

# R tries to avoid this ambiguity by assigning arguments
# from left to right, unless the argument is named.

test3 <- function(x = 1, y = 1, z = 1) {
    return(x * 100 + y * 10 + z)
}
test3(2, 2)
test3(y = 2, z = 2)

# EXAMPLE OPTIONAL ARGUMENTS slides 9-10:

# Function charplot() with two essential (x and y) 
# and two optional arguments (pc and co): 

charplot <- function(x,y,pc=16,co="red"){
plot(y~x,pch=pc,col=co)}
	
# To execute, you only need to provide x and y:
charplot(1:10,1:10)

# To get a different plotting symbol:
charplot(1:10,1:10,17)

# For navy-colored circles:
charplot(1:10,1:10,co="navy")	

# To change both plotting symbol and color:
charplot(1:10,1:10,15,"green")

# Reversing arguments does not work:
charplot(1:10,1:10, "green",15)
# Takes first character of 'green', "g"
# and plots that with a yellow (co=15) color.

# Order unimportant if specify both variable names:
charplot(1:10,1:10,co="green",pc=15)

## EXAMPLE: VARIABLE NUMBERS OF ARGUMENTS, slides 11-12

# Calculates means and variances of any number of vectors: 
many.means <- function(...){
	    data <- list(...)
	    n <- length(data)
	    means <- numeric(n)
	    vars <- numeric(n)
	    for (i in 1:n){
	       means[i] <- mean(data[[i]])
	       vars[i] <- var(data[[i]])
	    }
	    print(means)
	    print(vars)
	    invisible(NULL)
	  }

# Lets try it out ! : 

x <- rnorm(100)
y <- rnorm(200)
z <- rnorm(300)

many.means(x,y,z)
# [1]  -0.039181830  0.003613744  0.050997841
# [1]      1.146587     0.989700     0.999505

## RETURNING VALUES FROM A FUNCTION

# Example of a function returning a single value
parmax <- function (a,b){
	  c <- pmax(a,b)
	  median(c)}

# TRY IT OUT
x <- c(1,9,2,8,3,7)
y <- c(9,2,8,3,7,2)
parmax(x,y)

# Unassigned last line median(c) returns a value:
# [1] 8

# EXAMPLE: Return Multiple Values in a List
parboth <- function (a,b){
	  c <- pmax(a,b)
	  d <- pmin(a,b)
	  answer <- list(median(c),median(d))
	  names(answer)[[1]] <- "median of the par maxima"
	  names(answer)[[2]] <- "median of the par minima" 
	  return(answer)}
	
# Example using the same data as before:
parboth(x,y)
# $'median of the par maxima'
# [1] 8
# $'median of the par minima'
# [1] 2

# EXAMPLE: Anonymous (Unnamed) Functions, slide 15
(function(x,y){z <- 2*x^2 + y^2; x+y+z})(0:7,1)
# [1] 2 5 12 23 38 57 80 107

# R Exhibits Flexible Handling of Arguments to Functions
# EXAMPLE: Function that 'works' when called with
# one argument OR with two arguments:

plotx2 <- function(x,y=z^2){
	    z <- 1:x
	    plot(z,y,type="l")}

# change type="l" to p, b, h, s and n
# and observe how the plot changes

# TRY IT:
par(mfrow=c(1,2))
plotx2(12)
plotx2(12,1:12)
