# Uploading Files Example server.R

# The example receives a file and attempts to read it as
# comma-separated values using read.csv().

# Then it displays the results in a table. As comments below
# indicate, inFile is either NULL or a dataframe that
# contains one row per uploaded file.

# In this example, fileInput dis not have the multiple
# parameter so we can assume there is only one row.

# The file contents can be accessed by reading the file
# named by the datapath column. To learn more, do
# ?fileInput to learn about other columns available.

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