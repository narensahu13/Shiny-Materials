# runapps file for shiny class

###############################################
#####       SHINY-DISCUSS LISTSERV        #####
###############################################

# If you are serious about keeping up with shiny apps and development,
# a "must-have" is to join the shiny-discuss group listserv/forum
# go to: http://groups.google.com/group/shiny-discuss

###############################################
#####           HTML UI  EXAMPLE          #####
###############################################

# Here we demo defining the Shiny user interface using standard HTML.

library(shiny)
runExample("08_html")


# Using HTML can offer more flexibility than building the interface
# with the ui.R file.

# Basically, you can define your user-interface directly in HTML.

#<html>
  
#  <head>
#  <script src="shared/jquery.js" type="text/javascript"></script>
#  <script src="shared/shiny.js" type="text/javascript"></script>
#  <link rel="stylesheet" type="text/css" href="shared/shiny.css"/> 
#  </head>
  
#  <body>
#  <h1>HTML UI</h1>
  
#  <p>
#  <label>Distribution type:</label><br />
#  <select name="dist">
#  <option value="norm">Normal</option>
#  <option value="unif">Uniform</option>
#  <option value="lnorm">Log-normal</option>
#  <option value="exp">Exponential</option>
#  </select> 
#  </p>
  
#  <p>
#  <label>Number of observations:</label><br /> 
#  <input type="number" name="n" value="500" min="1" max="1000" />
#  </p>
  
#  <pre id="summary" class="shiny-text-output"></pre> 
  
#  <div id="plot" class="shiny-plot-output" 
#style="width: 100%; height: 400px"></div> 
  
#  <div id="table" class="shiny-html-output"></div>
#  </body>
  
#  </html>
  

# How Shiny binds HTML elements back to inputs and outputs:

# 1) HTML form elements (here a select list and a number input) which 
# are bound to input slots using the name attribute:

# e.g. select list name is "dist"
# e.g. number input name is "n"

# Output is rendered to HTML elements by matching their id attribute
# to an output slot and by specifying the requisite css class for the
# element

# eg: either
# id is"summary" and class is "shiny-text-output"; or
# id is "plot" and class is "shiny-plot-output" ; or
# id is "table" and class is "shiny-html-output"

# Can create highly customized user-interfaces using any sort of
# combination of HTML, CSS and JavaScript that you want to use.

# The server file is unchanged for its previous example use.


###############################################
#####        DYNAMIC UI  EXAMPLES         #####
###############################################

# Can create things on the fly

# Can hide or show inputs depending on the state of another input,
# and can create input controls "on the fly" in response to user
# input.

# There are three approaches in shiny to make interfaces more
# dynamic:

# 1) The conditional Panel function used in ui.R to wrap UI elements
#    such that they are dynamically shown or hidden
# 2) The renderUI() function used in server.R in conjunction with
#    htmlOutput() or uiOutput() in ui.R to generate calls to UI
#    functions and make the results appear in some predetermined 
#    place in the UI; or
# 3) Use JavaScript to modify the webpage directly.

# Showing and hiding controls with conditionalPanel

# Show live example

# Using renderUI() function in server.R with uiOutput() in ui.R

# Show live example

###############################################
#####              SCOPING                #####
###############################################

# Where you define objects determines where the object is visible
# What helps (hopefully) to understand this critical concept is this:

# Think of a single user in an R session. There is a "global environment"
# The 'global environment' is everything available and 'seen' by a user
# when they 'start up R'. Basically, this is everything visible in the
# workspace window in RStudio and includes some things that are not visible
# (like packages, or libraries)

# But when that individual user 'calls a function,' the scope changes. 
# When the function is executing, a new 'session' or 'level' opens up
# LOCAL ONLY TO THAT FUNCTION. When you create an object (or anything)
# inside a function, IT CAN ONLY BE SEEN INSIDE THAT FUNCTION....these
# are sometimes called 'local variables' but they can be functions
# themselves, they can be anything.

# The global environment (or session) is still there, but it is
# "one level up". 'Things' in the function call 'can see' 'things' in
# the global environment, but the reverse is not true.....the global
# environment has no visibility whatsoever over what is going on inside
# a function.

# Shiny sessions are basically functions calls themselves (with some
# differences).

##### SO:

# Some objects are visible within the server.R code of each user session;

# Other objects are visible in the server.R code of all sessions
# (such that multiple users could use a shared variable);

# Still other objects are visible in the server.R code and the ui.R
# code across all user sessions (put them in global.R file)

# There are at least three 'high levels' of sessions or visibility.

# 1) Global visibility
# 2) Session visibility
# 3) Shiny session visibility


# 3) Shiny session visibility
# We will start at the bottom...the function that you pass to shinyServer()
# (look at the code: shinyServer(func = function(input,output))) with the
# two arguments input and output is unique to each person's session.
# Everything in this function that you pass to shinyServer is instantiated
# separately and is called once for each session. This function is called
# once, and separately, each time a web browser is pointed to the
# Shiny application. Every object in the function, variables and functions
# you create are 'private'

# 2) Session visibility
# If you want some objects to be visible across all sessions for
# all users, you can create these objects once and share them across all
# user sessions by placing them (creating them) in the server.R code BUT
# ABOVE THE LINE WHERE YOU MAKE THE CALL TO shinyServer(). For example:

# A read-only data set that will load once, when Shiny starts, and will be
# available to each user session.
# bigDataSet <- read.csv('bigdata.csv')

# A non-reactive function that will be available to each user session
utilityFunction <- function(x) {
  # Function code here
  # ...
}

shinyServer(function(input, output) {
  # Server code here
  # ...
})

# If the bigDataSet or utilityFunction objects change, then the changed 
# objects will be visible in every user session. But note that you would 
# need to use the <<- assignment operator to change bigDataSet, because 
# the <- operator only assigns values in the local environment.

# like this:

varA <- 1
varB <- 1
listA <- list(X=1, Y=2)
listB <- list(X=1, Y=2)

shinyServer(function(input, output) {
  # Create a local variable varA, which will be a copy of the shared variable
  # varA plus 1. This local copy of varA is not be visible in other sessions.
  varA <- varA + 1
  
  # Modify the shared variable varB. It will be visible in other sessions.
  varB <<- varB + 1
  
  # Makes a local copy of listA
  listA$X <- 5
  
  # Modify the shared copy of listB
  listB$X <<- 5
  
  # ...
})

# Things work this way because server.R is sourced when you start your 
# Shiny app. Everything in the script is run immediately, including the 
# call to shinyServer()-but the function which is passed to shinyServer() 
# is called only when a web browser connects and a new session is started.

# 1) Global visibility
# Objects defined in global.R are similar to those defined in server.R 
# outside shinyServer(), with one important difference: they are also 
# visible to the code in ui.R. This is because they are loaded into the 
# global environment of the R session; all R code in a Shiny app is run 
# in the global environment or a child of it.

# In practice, there aren't many times where it's necessary to share 
# variables between server.R and ui.R. The code in ui.R is run once, 
# when the Shiny app is started and it generates an HTML file which is 
# cached and sent to each web browser that connects. This may be useful 
# for setting some shared configuration options.

### Scope for Included R files (Show Example in my code)

# If you want to split the server or ui code into multiple files, 
# you can use source(local=TRUE) to load each file. You can think 
# of this as putting the code in-line, so the code from the sourced 
# files will receive the same scope as if you copied and pasted the 
# text right there.

# This example server.R file shows how sourced files will be scoped:

# Objects in this file are shared across all sessions
# source('all_sessions.R', local=TRUE)

# Objects here are defined once, separately in each session
shinyServer(function(input, output) {
  # Objects in this file are defined in each session
  source('each_session.R', local=TRUE)
  
  output$text <- renderText({
    # Objects in this file are defined each time this function is called
    source('each_call.R', local=TRUE)
    
    # ...
  })
})

# If you use the default value of local=FALSE, then the file will 
# be sourced in the global environment.

  
