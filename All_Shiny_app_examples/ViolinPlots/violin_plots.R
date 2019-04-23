# Example 4: Malignant Melanoma Violin Plots
# ui.R
library(shiny) 
library(MASS)
library(wvioplot)
thickness <- Melanoma$thickness # tumour thickness in mm
status <- Melanoma$status
library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Malignant Melanoma Violin Plots"),
  sidebarPanel(
    # Slider Input is the most intuitive way to tune the smoothing parameter.
    sliderInput("adjust",label="Smoothing Parameter",
                min=0.5, max=10, value=3, step=0.5,animate=T)
  ),
  mainPanel(plotOutput("violins"))
))

shinyServer(function(input,output){
  # Our only output is the 'violins' plot which we want to be reactive to the 'adjust' input.
  # Therefore we use renderPlot and create the violin plot with the appropriate titles inside.
  output$violins <- renderPlot({
    wvioplot(thickness[status==1], thickness[status==2],
             thickness[status==3], names=c('Died from melanoma','Alive','Dead from other causes'), col="magenta",
             adjust=input$adjust) # Here we pull the value from the adjust sliderInput
    title(main='Tumor Thickness of 205 patients in Denmark with
          malignant melanoma',ylab="Tumor Thickness (mm)",xlab="Status")
  })
  })