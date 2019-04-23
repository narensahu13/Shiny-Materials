server <- function(input, output) {
  output$hist <- renderPlot({
    title <- "100 normal random values"
    hist(rnorm(100))
  })
}