library(shiny)
library(leaflet)

# Define UI for application
shinyUI(fluidPage(

  # Add the map output
  leafletOutput("map", width = "100%", height = "800px"),

))