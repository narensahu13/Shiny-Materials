library(shiny)

# ui layout instruction
ui <- fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      img(src="http://shiny.rstudio.com/tutorial/lesson2/www/bigorb.png", height = 400, width = 400)
    )
  )
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)