# Example 4: Malignant Melanoma Violin Plots
# ui.R
library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Malignant Melanoma Violin Plots"),
  sidebarPanel(
    # Slider Input is the most intuitive way to tune the smoothing parameter.
    sliderInput("adjust",label="Smoothing Parameter",
                min=0.5, max=10, value=3, step=0.5,animate=T)
  ),
  mainPanel(plotOutput("violins"))
))