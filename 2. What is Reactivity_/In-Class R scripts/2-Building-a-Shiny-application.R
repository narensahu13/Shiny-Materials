###########################################
####    BUILDING A SHINY APPLICATION   ####
###########################################

#### UI and SERVER

# Let's walk through the steps of building a simple 
# Shiny application. A Shiny application is simply a 
# directory containing a user-interface definition, 
# a server script, and any additional data, scripts, 
# other resources needed to support the application

# To get started building the application, create a 
# new empty directory wherever you'd like, then 
# create empty ui.R and server.R files within in. 
# For purposes of illustration we'll assume you've 
# chosen to create the application at ~/shinyapps:
  
#  ~/shinyapps
# |-- ui.R
# |-- server.R

# Now we'll add the minimal code required in each 
# source file. We'll first define the user interface 
# by calling the function pageWithSidebar and passing
# it's result to the shinyUI function:

# ui.R
library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Miles Per Gallon"),
  
  sidebarPanel(),
  
  mainPanel()
))

# The three functions headerPanel, sidebarPanel, and 
# mainPanel define the various regions of the user-
# interface. The application will be called "Miles 
# Per Gallon" so we specify that as the title when 
# we create the header panel. The other panels are 
# empty for now.

# Now let's define a skeletal server implementation. 
# To do this we call shinyServer and pass it a function 
# that accepts two parameters: input and output:
  
# server.R
library(shiny)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
})

# Our server function is empty for now but later we'll
# use it to define the relationship between our inputs 
# and outputs.

# We've now created the most minimal possible Shiny 
# application. You can run the application by calling
# the runApp function as follows:

# Shine App 001
library(shiny)
runApp("C:/shinyapps/001")


# If everything is working correctly you'll see the
# application appear in your browser.

# We now have a running Shiny application however, it
# does not do much yet. Next we will complete the
# application by specifying the user-interface and
# implementing the server script.

#### Inputs and outputs

# Adding Inputs to the Sidebar

# The application we'll be building uses the mtcars 
# data from the R datasets package, and allows users 
# to see a box-plot that explores the relationship 
# between miles-per-gallon (MPG) and three other 
# variables (Cylinders, Transmission, and Gears).

# We want to provide a way to select which variable 
# to plot MPG against as well as provide an option 
# to include or exclude outliers from the plot. To do
# this we'll add two elements to the sidebar, a 
# selectInput to specify the variable and a 
# checkboxInput to control display of outliers. 
# Our user-interface definition looks like this 
# after adding these elements:
  
# ui.R
library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Miles Per Gallon"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    selectInput("variable", "Variable:",
                list("Cylinders" = "cyl", 
                     "Transmission" = "am", 
                     "Gears" = "gear")),
    
    checkboxInput("outliers", "Show outliers", FALSE)
  ),
  
  mainPanel()
))

# If you run the application again after making these
# changes you'll see the two user-inputs we defined
# displayed within the sidebar:

library(shiny)
runApp("C:/shinyapps/002")

#### Creating the Server Script

# Next we need to define the server-side of the applica-
# tion which will accept inputs and compute outputs.

# Our server.R file is shown below, and it illustrates
# these important concepts/techniques:

# 1) Accessing input using 'slots' of the input object
# and generating output by assigning to slots on the
# output object.

# 2) Initializing data at startup that can be accessed
# throughout the lifetime of the application.

# 3) Using a reactive expression to compute a value
# shared by more than one output.

# The basic task of a Shiny server script is to define
# the relationship between inputs and outputs. Our
# script does this by accessing inputs to perform
# computations and by assigning reactive expressions
# to output slots.

# Here is the source code for the full server script
# with inline comments that explain the implementation
# techniques in greater detail:

# server.R

library(shiny)
library(datasets)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application
mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable against mpg and only 
  # include outliers if requested
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = mpgData,
            outline = input$outliers)
  })
})

# The use of renderText and renderPlot to generate 
# output (rather than just assigning values directly)
# is what makes the application reactive. These 
# reactive wrappers return special expressions that 
# are only re-executed when their dependencies change. 

# This behavior is what enables Shiny to automatically
# update output whenever input changes.

#### Displaying Outputs

# The server script assigned two output values: 
# output$caption and output$mpgPlot. To update our 
# user interface to display the output we need to add
# some elements to the main UI panel.

# In the updated user-interface definition below you 
# can see that we've added the caption as an h3 element 
# and filled in it's value using the textOutput() 
# function, and also rendered the plot by calling 
# the plotOutput() function:

# ui.R for example 003
library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Miles Per Gallon"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    selectInput("variable", "Variable:",
                list("Cylinders" = "cyl", 
                     "Transmission" = "am", 
                     "Gears" = "gear")),
    
    checkboxInput("outliers", "Show outliers", FALSE)
  ),
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    h3(textOutput("caption")),
    
    plotOutput("mpgPlot")
  )
))

# Running the application now shows it in its final 
# form including inputs and dynamically updating 
# outputs:

# Run example 003:
library(shiny)
runApp("C:/shinyapps/003")

# Now that we have a simple application running we will
# probably want to make some changes. The next topic
# Covers the basic cycle of editing, running, and 
# debugging Shiny applications.

#####   Run and Debug

# Throughout the tutorial you've been calling runApp 
# to run the example applications. This function 
# starts the application and opens up your default 
# web browser to view it. The call is blocking, 
# meaning that it prevents traditional interaction 
# with the console while the applciation is running.

# To stop the application you simply interupt R.
# You can do this by pressing the Escape key in all 
# R front ends as well as by clicking the stop button
# if your R environment provides one.

# If you don't want to block access to the console
# while running your Shiny application you can also 
# run it in a separate process. You can do this by
# opening a terminal or console window and executing:

# R -e "shiny::runapp('~/shinyapp')"

# By default runApp starts the application on 
# port 8100. If you are using this default then you 
# can connect to the running application by navigating 
# your browser to http://localhost:8100.

# Note that below we discuss some techniques for 
# debugging Shiny applications, including the ability
# to stop execution and inspect the current environment. 
# In order to combine these techniques with running 
# your applications in a separate terminal session 
# you need to run R interactively (that is, first 
# type "R" to start an R session then execute 
# runApp from within the session).

##### Live Reloading

# When you make changes to your underlying user-
# interface definition or server script you don't 
# need to stop and restart your application to see 
# the changes. Simply save your changes and then 
# reload the browser to see the updated application 
# in action.

# One qualification to this: when a browser reload 
# occurs Shiny explicitly checks the timestamps of 
# the ui.R and server.R files to see if they need to 
# be re-sourced. If you have other scripts or data 
# files that change Shiny isn't aware of those, so a 
# full stop and restart of the application is 
# necessary to see those changes reflected.

###### Debugging Techniques

# Printing

# There are several techniques available for debugging
# Shiny applications. The first is to add calls to 
# the cat function which print diagnostics where 
# appropriate. For example, these two calls to cat 
# print diagnostics to standard output and standard 
# error respectively:

cat("foo\n")
cat("bar\n", file=stderr())

# Using Browser

# The second technique is to add explicit calls to 
# the browser function to interrupt execution and 
# inspect the environment where browser was called 
# from. Note that using browser requires that you 
# start the application from an interactive session 
# (as opposed to using R -e as described above).

# For example, to unconditionally stop execution at 
# a certain point in the code:
  
# Always stop execution here
browser() 

# You can also use this technique to stop only on 
# certain conditions. For example, to stop the MPG 
# application only when the user selects 
# "Transmission" as the variable:
  
# Stop execution when the user selects "am"
# browser(expr = identical(input$variable, "am"))

# Establishing a custom error handler

# You can also set the R "error" option to automatically 
# enter the browser when an error occurs:
  
# Immediately enter the browser when an error occurs
options(error = browser)

# Alternatively, you can specify the recover function 
# as your error handler, which will print a list of 
# the call stack and allow you to browse at any point
# in the stack:
  
# Call the recover function when an error occurs
options(error = recover)

# If you want to set the error option automatically 
# for every R session, you can do this in your 
# .Rprofile file...see:

# http://http://stat.ethz.ch/R-manual/R-patched/library/base/html/Startup.html

# NOTE: You exit the browser by typing 'c' or 'cont' (for 'continue')
# Browse[1]> c
# R will not let you quit your session if you are in browse mode
# so you must issue the 'c' or 'cont' command to get out of Browse