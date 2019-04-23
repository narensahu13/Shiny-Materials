# Download Data example server.R

# Can define a download using the downloadHandler()
# function on server side with either downloadButton()
# or lownloadLink() in UI.

# As you can see, downloadHandler() takes a filename 
# argument, which tells the web browser what filename 
# to default to when saving. This argument can either be 
# a simple string, or it can be a function that returns 
# a string (as is the case here).

# The content argument must be a function that takes a 
# single argument, the file name of a non-existent temp 
# file. The content() function is responsible for writing 
# the contents of the file download into that temp file.

# Both the filename and content arguments can use reactive 
# values and expressions (although in the case of filename,
# be sure your argument is an actual function... 

# filename = paste(input$dataset, '.csv') 

# is not going to work like you want, since it is evaluated
# only once, when the download handler is being defined).

# Usually, filename and content arguments are the only two
# arguments you'll need. There is an optional contentType 
# argument; if it is NA or NULL, Shiny will attempt to 
# guess the appropriate value based on the filename. 

# Provide your own content type string (e.g. "text/plain") 
# if you want to override this behavior.

shinyServer(function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  output$table <- renderTable({
    datasetInput()
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
})
