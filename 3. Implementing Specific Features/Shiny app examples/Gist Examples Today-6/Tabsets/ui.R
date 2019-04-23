# Live Tabsets Example ui.R
# Can use tabs to organize output

# Create tabsets by calling tabsetPanel() function with list
# of tabs created by call to tabsetPanel() function.

# Each tab panel is provided a list of output elements
# which are rendered vertically within the tab.

# Note we also use this example as the begining of the
# "Random Variables Distribution" examples or DistRV1

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
