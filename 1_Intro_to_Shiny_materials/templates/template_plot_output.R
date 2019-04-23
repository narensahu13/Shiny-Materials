library(shiny)
ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  plotOutput(outputId = "hist")
  )

server <- function(input, output) {}

shinyApp(ui = ui, server = server)