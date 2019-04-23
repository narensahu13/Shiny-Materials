###############################################
#####   Pre-Shiny app: loads .splsm and   #####
#####   data file (.csv) and runs plspm   #####
#####   and semPLS functions in R         #####
###############################################

# NOTE: You can run this code line-by-line by
# using control-Enter instead of using the
# Run App button 

library("shiny")

# isolate demo
runExample("01_hello")
runApp("C://shinyapps/IsolateDemo")

# Interactive PLS Path Modeling Online project
runApp("C://shinypls/006")

# examples
runApp("C://shinyapps/Tabsets")
runApp("C://shinyapps/DistRV1")
runApp("C://shinyapps/DistRV2")
runApp("C://shinyapps/DistRV3")
install.packages("VGAM")
runApp("C://shinyapps/DistRV4")
runApp("C://shinyapps/DistRV5")
# This one will install several packages:
runApp("C://shinyapps/ViolinPlots")
#runApp("C://shinyapps/HeatMap")

# To run this example, you must install
# these packages: semPLS, plspm, XML
#runApp("C://shinyapps/pls")
# https://gist.github.com/pls-man/6336153

shiny::runGist('6336153')

runApp("C://shinypls/006")
