# Downloading Data Example ui.R

# So far have only demonstrated outputs appearing directly
# on page (plots, tables, text boxes)

# Shiny can also offer file downloads that are calculated
# 'on the fly' so is easy to build data export features.

# Can define a download using the downloadHandler()
# function on server side with either downloadButton()
# or lownloadLink() in UI

shinyUI(pageWithSidebar(
  headerPanel('Download Example'),
  sidebarPanel(
    selectInput("dataset", "Choose a dataset:", 
                choices = c("rock", "pressure", "cars")),
    downloadButton('downloadData', 'Download')
  ),
  mainPanel(
    tableOutput('table')
  )
))