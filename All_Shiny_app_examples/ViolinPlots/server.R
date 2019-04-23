# Example 4: Malignant Melanoma Violin Plots
# server.R
library(shiny); library(MASS); install.packages("Hmisc")
download.file(url="http://cran.r-project.org/src/contrib/Archive/
wvioplot/wvioplot_0.1.tar.gz", destfile="wvioplot_0.1.tar.gz")
install.packages("wvioplot_0.1.tar.gz", repos = NULL, type = "source")
unlink("wvioplot_0.1.tar.gz") # Delete the downloaded file.
library(wvioplot)
thickness <- Melanoma$thickness # tumour thickness in mm
status <- Melanoma$status
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