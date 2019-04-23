# Uploading Files Example ui.R

# Allows users to upload their data files for your application.

# NOTES:
# . This feature does not work with Internet Explorer 9 
#   and earlier (not even with Shiny Server).

# . By default, Shiny limits file uploads to 5MB per file. 
#   You can modify this limit by using shiny.maxRequestSize 
#   option. For example, adding 

#   options(shiny.maxRequestSize=30*1024^2)

#   to top of server.R would increase the limit to 30MB.

# File upload controls are created by using the 
# fileInput() function in your ui.R file. You access 
# the uploaded data similarly to other types of input: 
# by referring to input$inputId. The fileInput() function 
# takes a multiple parameter that can be set to TRUE to 
# allow the user to select multiple files, and an accept 
# parameter can be used to give the user clues as to what 
# kind of files the application expects.


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