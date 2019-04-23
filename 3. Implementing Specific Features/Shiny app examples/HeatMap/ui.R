# Example 014: Visualizing Density with Heat Map and Contour Plot
# ui.R

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Visualizing Density with Heat Map and Contour Plot"),
  
  sidebarPanel(
   # Alternatively, we could have chosen to use numericInput since that lets us input any
   # number between the minimum and maximum allowed values. However, we don't want
   # the user to be able to type in non-whole number values and the animate=T feature of
   # sliderInput is very useful in this application.

    sliderInput("nlevels",label="Contour Levels",
                min=1,max=20,value=10,step=1,animate=T),
    h2("Bandwidth"),

    # Slider Input is the most intuitive way to tune the smoothing parameter. We need to
    # remember that X refers to Thickness and Y refers to Age (refer to server.R) and not mix
    # them up.
    
    sliderInput("adjustX",label="Thickness",
                min=0.5,max=10,value=3,step=0.5,animate=T),
    sliderInput("adjustY",label="Age",
                min=0.5,max=10,value=3,step=0.5,animate=T)
    ),
  
  mainPanel(
    plotOutput("density")
    )
))