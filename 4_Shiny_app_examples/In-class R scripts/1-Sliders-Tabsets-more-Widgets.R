##########################################
###   SLIDERS, TABSETS, MORE WIDGETS   ### 
##########################################

##### SLIDERS

# The Sliders application demonstrates the many 
# capabilities of slider controls, including the 
# ability to run an animation sequence. To run the 
# example type:
  
library(shiny)
runExample("05_sliders")

# or run off of C://shinyapps folder on this computer
runApp("C:/shinyapps/Sliders")

# Made a GitHub Gist out of it, can call with:
shiny::runGist('6270922')

# or with:
shiny::runGist('https://gist.github.com/6270922')

# Customizing Sliders

# Shiny slider controls are extremely capable and 
# customizable. Features supported include:
  
# 1) The ability to input both single values and 
#    ranges;

# 2) Custom formats for value display (e.g for 
#    currency);

# 3) The ability to animate the slider across a 
#    range of values;

# Slider controls are created by calling the 
# sliderInput() function. ui.R file demonstrates
# using sliders with a variety of options:
  
# ui.R
library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Sliders"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    # Simple integer interval
    sliderInput("integer", "Integer:", 
                min=0, max=1000, value=500),
    
    # Decimal interval with step value
    sliderInput("decimal", "Decimal:", 
                min = 0, max = 1, value = 0.5, step= 0.1),
    
    # Specification of range within an interval
    sliderInput("range", "Range:",
                min = 1, max = 1000, value = c(200,500)),
    
    # Provide a custom currency format for value display, with basic animation
    sliderInput("format", "Custom Format:", 
                min = 0, max = 10000, value = 0, step = 2500,
                format="$#,##0", locale="us", animate=TRUE),
    
    # Animation with custom interval (in ms) to control speed, plus looping
    sliderInput("animation", "Looping Animation:", 1, 2000, 1, step = 10, 
                animate=animationOptions(interval=300, loop=T))
  ),
  
  # Show a table summarizing the values entered
  mainPanel(
    tableOutput("values")
  )
))


# Server Script

# The server side of the Slider application is very
# straightforward: it creates a data frame containing
# all of the input values and then renders it as 
# an HTML table:
  
# server.R
library(shiny)

# Define server logic for slider examples
shinyServer(function(input, output) {
  
  # Reactive expression to compose a data frame containing all of the values
  sliderValues <- reactive({
    
    # Compose data frame
    data.frame(
      Name = c("Integer", 
               "Decimal",
               "Range",
               "Custom Format",
               "Animation"),
      Value = as.character(c(input$integer, 
                             input$decimal,
                             paste(input$range, collapse=' '),
                             input$format,
                             input$animation)), 
      stringsAsFactors=FALSE)
  }) 
  
  # Show the values using an HTML table
  output$values <- renderTable({
    sliderValues()
  })
})

##### TABSETS

# The Tabsets application demonstrates using tabs to
# organize output. To run the example type:

library(shiny)
runExample("06_tabsets")

# or run off of C://shinyapps folder on this computer
runApp("C:/shinyapps/Tabsets")

# Made a GitHub Gist out of it, can call with:
shiny::runGist('6271070')

# or with:
shiny::runGist('https://gist.github.com/6271070')

# Tab Panels

# Tabsets are created by calling the tabsetPanel()
# function with a list of tabs created by the 
# tabPanel() function. Each tab panel is provided a
# list of output elements which are rendered vertically 
# within the tab.

# In this example we updated our 'Hello Shiny' 
# application to add a summary and table view of 
# the data, each rendered on their own tab. Here 
# is the revised source code for the user-interface:
  
# ui.R
library(shiny)

# Define UI for random distribution application 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Tabsets"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  sidebarPanel(
    radioButtons("dist", "Distribution type:",
                 list("Normal" = "norm",
                      "Uniform" = "unif",
                      "Log-normal" = "lnorm",
                      "Exponential" = "exp")),
    br(),
    
    sliderInput("n", 
                "Number of observations:", 
                value = 500,
                min = 1, 
                max = 1000)
  ),
  
  # Show a tabset that includes a plot, summary, and table view
  # of the generated distribution
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("plot")), 
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Table", tableOutput("table"))
    )
  )
))

# Tabs and Reactive Data

# Introducing tabs into our user-interface underlines 
# the importance of creating reactive expressions 
# for shared data. In this example each tab provides 
# its own view of the dataset. If the dataset is 
# expensive to compute then our user-interface 
# might be quite slow to render. The server script
# below demonstrates how to calculate the data once
# in a reactive expression and have the result be 
# shared by all of the output tabs:
  
# server.R
library(shiny)

# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  # Reactive expression to generate the requested distribution. This is 
  # called whenever the inputs change. The renderers defined 
  # below then all use the value computed from this expression
  data <- reactive({  
    dist <- switch(input$dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    dist(input$n)
  })
  
  # Generate a plot of the data. Also uses the inputs to build the 
  # plot label. Note that the dependencies on both the inputs and
  # the 'data' reactive expression are both tracked, and all expressions 
  # are called in the sequence implied by the dependency graph
  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n
    
    hist(data(), 
         main=paste('r', dist, '(', n, ')', sep=''))
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    summary(data())
  })
  
  # Generate an HTML table view of the data
  output$table <- renderTable({
    data.frame(x=data())
  })
})

##### MORE WIDGETS

# The More Widgets application demonstrates the help text and submit button widgets as well as the use of embedded HTML elements to customize formatting. To run the example type:

library(shiny)
runExample("07_widgets")

# or run off of C://shinyapps folder on this computer
runApp("C:/shinyapps/MoreWidgets")

# Made a GitHub Gist out of it, can call with:
shiny::runGist('6271129')

# or with:
shiny::runGist('https://gist.github.com/6271129')

# UI Enhancements

# In this example we update the Shiny Text 
# application with some additional controls and 
# formatting, specifically:
  
# 1) We added a helpText control to provide 
#    additional clarifying text alongside our 
#    input controls.

# 2) We added a submitButton control to indicate 
#    that we don't want a live connection between 
#    inputs and outputs, but rather to wait until 
#    the user clicks that button to update the 
#    output. This is especially useful if computing 
#    output is computationally expensive.

# 3) We added h4 elements (heading level 4) into 
#    the output pane. Shiny offers a variety of 
#    functions for including HTML elements directly
#    in pages including headings, paragraphics, 
#    links, and more.

# Here is the updated source code for the 
# user-interface:
  
# ui.R
library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  # Application title.
  headerPanel("More Widgets"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view. The helpText function is also used to 
  # include clarifying text. Most notably, the inclusion of a 
  # submitButton defers the rendering of output until the user 
  # explicitly clicks the button (rather than doing it immediately
  # when inputs change). This is useful if the computations required
  # to render output are inordinately time-consuming.
  sidebarPanel(
    selectInput("dataset", "Choose a dataset:", 
                choices = c("rock", "pressure", "cars")),
    
    numericInput("obs", "Number of observations to view:", 10),
    
    helpText("Note: while the data view will show only the specified",
             "number of observations, the summary will still be based",
             "on the full dataset."),
    
    submitButton("Update View")
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations. Note the use of the h4 function to provide
  # an additional header above each output section.
  mainPanel(
    h4("Summary"),
    verbatimTextOutput("summary"),
    
    h4("Observations"),
    tableOutput("view")
  )
))

# Server Script

# All of the changes from the original Shiny Text 
# application were to the user-interface, the 
# server script remains the same:
  
# server.R
library(shiny)
library(datasets)

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})

### Isolate (show slides first)

# You need to install the packages devtools
# and shinyIncubator for this next example
# to work. You should be able to install 
# these packages using these commands:
if (!require(devtools))
  install.packages("devtools")
devtools::install_github("shiny-incubator", "rstudio")

# Or more simply with these commands:
install.packages("devtools")
devtools::install_github("shiny-incubator", "rstudio")

# Run example Isolate:
library(shiny)
runApp("C:/shinyapps/IsolateDemo")

# Made a Gist out of it, can call with:
shiny::runGist('4963887')
