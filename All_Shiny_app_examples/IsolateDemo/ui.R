# Isolate (Action Button) Example ui.r
# Can view Gist at http://tinyurl.com/isolate-demo

library(shinyIncubator)

shinyUI(pageWithSidebar(
  headerPanel("Click the button"),
  sidebarPanel(
    sliderInput("obs", "Number of observations:",
                min = 0, max = 1000, value = 500),
    actionButton("goButton", "Go!"),
    p(br(), a("View source code", href="https://gist.github.com/wch/4963887"))
  ),
  mainPanel(
    plotOutput("distPlot")
  )
))
