## User Interface or ui.R source file for:
## Super Bootstrapper Online Application

# Extends bootstrapping capabilities for plspm()

library(shiny)

tabPanelAbout <- source("about.r")$value
# Define UI for PLS path modeling application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(
    HTML(
      '<div id="stats_header">
      Super Bootstrapper
      <a href="http://sem-n-r.com" target="_blank">
      <img id="sem-n-r_logo" align="right" alt="SEM-n-R" width=160 height=40 src="http://www.pls-sem.com/files/sem_n_r_logo_original_0.png" />
      </a>
      </div>'
    ),
    "Super Bootstrapper"
    ),
  
  sidebarPanel(
    
    wellPanel(
      fileInput('file1', 
                'Upload CSV data file with column headers:', 
                accept=c('text/csv',
                         'text/comma-separated-values,
                         text/plain')),
      uiOutput('columns'),
      checkboxInput("lvs", "I am using a SmartPLS .splsm model file to define my model structure.", TRUE),
      conditionalPanel(
        condition = "input.lvs== true",
        fileInput('file2', 'Upload SmartPLS .splsm model file:')
        ),
      conditionalPanel(
        condition = "input.lvs== false",
        helpText("If you are not specifying your model with an existing SmartPLS",
                 "model (.splsm) file, you need to import two .csv files",
                 "to specify (1) the measurement model (outer model) and (2) the structural",
                 "model (inner model). Please see instructions and examples."),
        fileInput('file3', 'Upload measurement model specification .csv file:'),
        fileInput('file4', 'Upload structural model specification .csv file:')
        ),
      sliderInput("boots","Number of Bootstrap Resamples:",
                    min = 100, max=10000, value=100, step=100),
      selectInput("scheme", "Choose inner weighting scheme:",
                  choices = c("path", "factor", "centroid")),
      checkboxInput('scl', 'Scale input data. ', TRUE)
      ),
      
      wellPanel(
        selectInput("downdata", "Choose Results Table to Download: ",
                    choices = c("Outer Weights", "Outer Loadings",
                                "Direct Effects","Indirect Effects",
                                "Total Effects")),
        selectInput("downplot", "Choose Plot to Download:",
                    choices = c("Path Model Plot","Outer Loadings Plot",
                                "Outer Weights Plot", "Path Group Differences Plot",
                                "Hierarchical Cluster Analysis Plot", "Outer Weights Evolution Plot",
                                "LV Scores Plot","LV Predictions Plot",
                                "LV Residuals Plot")),
        downloadButton("downloadData", "Download Results Table"),
        downloadButton("downloadPlot", "Download Plot")
      )
    ),
  
  ##### MAIN PANEL
  
  mainPanel(
    
    tabsetPanel(
      tabPanel("Dataset View", 
               h4("Dataset: Variable Names and Values"),
               tableOutput("contents")),
      tabPanel("Outer Weights", 
               h4("Bootstrap Results: Outer Weights"),
               tableOutput("wgt")),
      tabPanel("Outer Loadings", 
                 h4("Bootstrap Results: Outer Loadings"),
                 tableOutput("load")),
      tabPanel("Direct Effects", 
               h4("Bootstrap Results: Direct Effects (Inner Model Path Coefficients)"),
               tableOutput("drff")),
      tabPanel("Indirect Effects", 
               h4("Bootstrap Results: Indirect Effects (Total Effects minus Direct Effects)"),
               tableOutput("inff")),
      tabPanel("Total Effects", 
               h4("Bootstrap Results: Total Effects (the Sum of Direct and Indirect Effects)"),
               tableOutput("toff")),
     # tabPanel("Don't Know", 
      #         h4("Blah blah"),
      #         tableOutput("calph")),
     # tabPanel("Blah", 
       #        h4("Bootstrapped Outer Loadings"),
      #         tableOutput("load1")),
      tabPanelAbout(), id = "allPanels")
  )
  ))
