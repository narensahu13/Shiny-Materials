##########################################
###  UPLOADING FILES, DOWNLOADING DATA ### 
##########################################

##### UPLOADING FILES

# Sometimes you'll want users to be able to upload 
# their own data to your application. Shiny makes 
# it easy to offer your users file uploads straight
# from the browser, which you can then access from 
# your server logic.

# Some important notes:
  
# 1) Feature doesn't work with Internet Explorer 9 
#    and earlier (not even with Shiny Server).

# 2) By default, Shiny limits file uploads to 5MB 
#    per file. You can modify this limit by using 
#    the shiny.maxRequestSize option. For example, 
#    adding options(shiny.maxRequestSize=30*1024^2)
#    to the top of server.R would increase the 
#    limit to 30MB.

# To run this example, type:
library(shiny)
runExample("09_upload")

# or run off of C://shinyapps folder on this computer
# Note I label it "CSV Viewer"
# PLEASE NOTE: This calls a slightly different example
# currently with some errors
# runApp("C:/shinyapps/UploadingFiles")

# Made a GitHub Gist out of it, can call with:
# PLEASE NOTE: This calls a slightly different example
# currently with some errors
# shiny::runGist('6271260')

# or with:
# PLEASE NOTE: This calls a different example
# currently with some errors
# shiny::runGist('https://gist.github.com/6271260')

# File upload controls are created by using the 
# fileInput() function in your ui.R file. You access
# the uploaded data similarly to other types of 
# input: by referring to input$inputId. 

# The fileInput() function takes a multiple 
# parameter that can be set to TRUE to allow the 
# user to select multiple files, and an accept 
# parameter can be used to give the user clues as 
# to what kind of files the application expects.

# ui.R
shinyUI(pageWithSidebar(
  headerPanel("CSV Viewer"),
  sidebarPanel(
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 
                       'text/comma-separated-values,
                       text/plain')),
    tags$hr(),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 'Comma'),
    radioButtons('quote', 'Quote',
                 c(None='',
                   'Double Quote'='"',
                   'Single Quote'="'"),
                 'Double Quote')
  ),
  mainPanel(
    tableOutput('contents')
  )
))

# server.R
shinyServer(function(input, output) {
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. 
    # After the user selects and uploads a 
    # file, it will be a data frame with 
    # 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will 
    # contain the local filenames where the 
    # data can be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header=input$header, 
             sep=input$sep, quote=input$quote)
  })
})

# This example receives a file and attempts to read
# it as comma-separated values using read.csv, 
# then displays the results in a table. As the 
# comment in server.R indicates, inFile is either 
# NULL or a dataframe that contains one row per 
# uploaded file. In this case, fileInput did not 
# have the multiple parameter so we can assume 
# there is only one row.

# The file contents can be accessed by reading the 
# file named by the datapath column. See the 
# ?fileInput help topic to learn more about the 
# other columns that are available.

##### DOWNLOADING DATA

# The examples so far have demonstrated outputs 
# that appear directly in the page, such as plots,
# tables, and text boxes. Shiny also has the 
# ability to offer file downloads that are 
# calculated on the fly, which makes it easy to 
# build data exporting features.

# To run the example below, type:
library(shiny)
runExample("10_download")

# or run off of C://shinyapps folder on this computer
runApp("C:/shinyapps/DownloadingData")

# Made a GitHub Gist out of it, can call with:
shiny::runGist('6271307')

# or with:
shiny::runGist('https://gist.github.com/6271307')

# You define a download using the downloadHandler()
# function on the server side, and either 
# downloadButton() or downloadLink() in the UI:
  
# ui.R
shinyUI(pageWithSidebar(
  headerPanel('Download Example'),
  sidebarPanel(
    selectInput("dataset", "Choose a dataset:", 
                choices = c("rock", "pressure", 
                            "cars")),
    downloadButton('downloadData', 'Download')
  ),
  mainPanel(
    tableOutput('table')
  )
))

# server.R
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
    filename = function() {paste(input$dataset,
                                 '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
})

# As you can see, downloadHandler takes a filename
# argument, which tells the web browser what 
# filename to default to when saving. This 
# argument can either be a simple string, or it 
# can be a function that returns a string (as is 
# the case here).

# The content argument must be a function that 
# takes a single argument, the file name of a 
# non-existent temp file. The content function 
# is responsible for writing the contents of the 
# file download into that temp file.

# Both the filename and content arguments can use 
# reactive values and expressions (although in the
# case of filename, be sure your argument is an 
# actual function; filename = paste(input$dataset,
# '.csv') is not going to work the way you want it 
# to, since it is evaluated only once, when the 
# download handler is being defined).

# Generally, those are the only two arguments 
# you'll need. There is an optional contentType 
# argument; if it is NA or NULL, Shiny will 
# attempt to guess the appropriate value based 
# on the filename. Provide your own content type 
# string (e.g. "text/plain") if you want to 
# override this behavior.

### Isolate (show slides first)

# Run example Isolate:
library(shiny)
runApp("C:/shinyapps/IsolateDemo")

# Made a Gist out of it, can call with:
shiny::runGist('4963887')
