# Example 014: Visualizing Density with Heat Map and Contour Plot
# server.R

library(shiny); library(MASS)

thickness <- Melanoma$thickness

age <- Melanoma$age

shinyServer(function(input,output){
  # Our only output is the 'density' plot which we want to be reactive to the 'adjustX,'
  # 'adjustY,' and 'nlevels' inputs. Therefore we use renderPlot and create the heat map and
  # the contour plots with the appropriate titles inside:
  output$density <- renderPlot({
      # Estimate the two-dimensional kernel density using the values of the adjustX and
      # adjustY slider inputs:
    kde <- kde2d(thickness,age,h=c(input$adjustX,input$adjustY))
    image(kde)
      
    # We add the titles separately:
    
    title(main="Tumor Thickness and Age of 205 patients\n in Denmark with malignant melanoma",ylab="Patient Age",xlab="Tumor Thickness (mm)")
      
    # We allowed the user to specify the number of levels of the contour plot. So we pull the
    # value from the nlevels sliderInput. We also want to plot a 50% transparent contour plot
    # instead of completely opaque one.
      
    contour(kde,add=T,lwd=1,col=rgb(0,0,0,0.5),nlevels=input$nlevels)
      
    # We want to see the heatmap and the contour overlay, so we plot 50% transparent points
    # instead of 100% opaque ones. We also decrease their size.
      
    points(thickness,age,pch=16,cex=0.5,col=rgb(0,0,0,0.5))
    })
})