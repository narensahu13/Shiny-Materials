## User Interface or ui.R source file for:
## Interactive PLS Path Modeling Online Application

library(shiny)

tabPanelAbout <- source("about.r")$value
# Define UI for PLS path modeling application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(
    HTML(
      '<div id="stats_header">
      Interactive PLS Path Modeling
      <a href="http://sem-n-r.com" target="_blank">
      <img id="sem-n-r_logo" align="right" alt="SEM-n-R" width=160 height=40 src="http://www.pls-sem.com/files/sem_n_r_logo_original_0.png" />
      </a>
      </div>'
    ),
    "PLS Path Modeling Online"
  ),
  
  sidebarPanel(
   
    wellPanel(
      fileInput('file1', 
                'Upload CSV data file:', 
                accept=c('text/csv',
                         'text/comma-separated-values,
                         text/plain')),
      checkboxInput('header', 'Data file has variable names as column headers.', TRUE),
      radioButtons('sep', 'Data file separator value:',
                   c(Comma=',',Semicolon=';',Tab='\t'),'Comma'),
      checkboxInput("lvs", "I am using a SmartPLS .splsm model file to define my model structure.", TRUE),
      conditionalPanel(
        condition = "input.lvs== true",
        fileInput('file2', 'Upload SmartPLS .splsm model file:')),
      conditionalPanel(
        condition = "input.lvs== false",
        helpText("If you are not specifying your model with an existing SmartPLS",
                 "model (.splsm) file, you need to import two .csv files",
                 "to specify (1) the measurement model (outer model) and (2) the structural",
                 "model (inner model). Please see instructions and examples."),
        fileInput('file3', 'Upload measurement model specification .csv file:'),
        fileInput('file4', 'Upload structural model specification .csv file:')
        ),
    
    wellPanel(
      checkboxInput("bval", "Run bootstrap validation", FALSE),
      conditionalPanel(
        condition = "input.bval== true",
        sliderInput("boots","Number of Bootstrap Resamples:",
                    min = 100, max=500, value=100, step=100)),
      selectInput("scheme", "Choose inner weighting scheme:",
                  choices = c("path", "factor", "centroid")),
      checkboxInput('scl', 'Scale input data. ', TRUE),
      checkboxInput('groups', 'Run group comparison test (MGA)', FALSE),
      conditionalPanel(
          condition = "input.groups== true",
          uiOutput('columns'))
      ),
    
    wellPanel(
      selectInput("downdata", "Choose Results Table to Download: ",
                  choices = c("LV Overview", "LV Cross Correlation Matrix",
                            "Loadings and Cross Loadings",
                            "Direct, Indirect, and Total Effects",
                            "Outer Weights and Loadings", "Latent Variable Scores",
                            "Unscaled Latent Variable Scores",
                              "Group Differences Permutation","Group Differences Parametric",
                            "Bootstrap: Path Model CIs", "Bootstrap: Loading CIs",
                            "Bootstrap: Weight CIs","Bootstrap: Effect CIs",
                            "Bootstrap: R-Squared CIs")),
      selectInput("downplot", "Choose Plot to Download:",
                  choices = c("Path Model Plot",
                              "Outer Loadings Plot",
                              "Outer Weights Plot", 
                              "Standard Scatterplot: LV Scores", 
                              "Augmented Scatterplot: LV Scores", 
                              "Path Group Differences Plot",
                              "Hierarchical Cluster Analysis Plot", 
                              "Outer Weights Evolution Plot",
                              "LV Scores Plot",
                              "LV Predictions Plot",
                              "LV Residuals Plot")),
      downloadButton("downloadData", "Download Results Table"),
      downloadButton("downloadPlot", "Download Plot")
      )
      
    )),
  
  ##### MAIN PANEL
  
  mainPanel(
    
    tabsetPanel(
      tabPanel("Data: Dataset View", 
               h4("Dataset: Variable Names and Values"),
               tableOutput("contents")),
      tabPanel("Report: LV Overview", 
               h4("Latent Variable Overview and Reliability Table"),
               tableOutput("inners")),
      tabPanel("Report: LV Cross Correlation Matrix",
               h4("Latent Variable Correlations (AVE square root in diagonal)"),
               tableOutput("lvcor")),
      tabPanel("Report: Loadings and Cross Loadings",
               h4("Loadings and Cross Loadings Table"),
               tableOutput("outerc")),
      tabPanel("Report: Direct, Indirect, and Total Effects",
               h4("Direct, Indirect, and Total Effects"),
               tableOutput("eff")),
      tabPanel("Report: Outer Weights and Loadings", 
               h4("Measurement Model Weights and Loadings"),
               tableOutput("outerm")),
      tabPanel("Report: Latent Variable Scores", 
               h4("Scaled Latent Variable Scores Derived by PLS Algorithm"),
               tableOutput("outlvs")),
      tabPanel("Report: Unscaled Latent Variable Scores", 
               h4("Latent Variable Scores if Scaling is Turned Off"),
               tableOutput("outulvs")),
      tabPanel("Report: Group Differences Permutation", 
               h4("Group Differences using the Permutation Approach"),
               tableOutput("groupdp")),
      tabPanel("Report: Group Differences Parametric", 
               h4("Group Differences using the Parametric T-test Approach"),
               tableOutput("groupdb")),
      tabPanel("Bootstrap: Path Model CIs", 
               h4("95% Confidence Intervals for Inner Model Path Coefficients"),
               tableOutput("paths")),
      tabPanel("Bootstrap: Loading CIs", 
               h4("95% Confidence Intervals for Outer Path Loadings"),
               tableOutput("loads")),
      tabPanel("Bootstrap: Weight CIs", 
               h4("95% Confidence Intervals for Outer Path Weights"),
               tableOutput("weights")),
      tabPanel("Bootstrap: Effect CIs", 
               h4("95% Confidence Intervals for Total Effects"),
               tableOutput("effects")),
      tabPanel("Bootstrap: R-Squared CIs", 
               h4("95% Confidence Intervals for R-Squared Explained Variance Values"),
               tableOutput("rsq")),
      tabPanel("Plot: Path Model",
               h4("Path Model Coefficients"),
               plotOutput("plotinner",height="650px")),
      tabPanel("Plot: Outer Loadings", 
               h4("Measurement (Outer) Model Path Loadings"),
               plotOutput("plotload",height="650px")),
      tabPanel("Plot: Outer Weights", 
               h4("Measurement (Outer) Model Path Weights"),
               plotOutput("plotweight",height="650px")),
      tabPanel("Standard Scatterplot: LV Scores", 
               h4("Standard Scatterplot Matrix of Latent Variable Scores"),
               plotOutput("lvplot1",height="800px")),
      tabPanel("Augmented Scatterplot: LV Scores", 
               h4("Augmented Scatterplot Matrix of Latent Variable Scores (Color indicates density; Red line indicates best fit)"),
               plotOutput("lvplot2",height="800px")),
      tabPanel("Plot: Path Group Differences", 
               h4("Barchart of Group Differences in Path Coefficients"),
               plotOutput("grpdbplot",height="650px")),
      tabPanel("Plot: Hierarchical Cluster Analysis", 
               h4("Hierarchical Cluster Analysis of LV Scores"),
               plotOutput("hierplot",height="480px")),
      tabPanel("Plot: Outer Weights Evolution", 
               h4("PLS Algorithm Iterative Evolution of Outer Weights"),
               plotOutput("weightsevol",height="650px")),
      tabPanel("Plot: LV Scores", 
               h4("Density and Rug Plots of Latent Variable Score Distributions"),
               plotOutput("densplotf",height="650px")),
      tabPanel("Plot: LV Predictions", 
               h4("Density and Rug Plots of Endogenous Latent Variable Predicted Score Distributions"),
               plotOutput("densplotp",height="650px")),
      tabPanel("Plot: LV Residuals", 
               h4("Density and Rug Plots of Endogenous Latent Variable Residual Score Distributions"),
               plotOutput("densplotr",height="650px")),
      tabPanelAbout(), id = "allPanels")
    )
  ))
