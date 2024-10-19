library(shiny)
library(leaflet)

# Define UI for application
shinyUI(fluidPage(

  # Include the external CSS file
  includeCSS("www/custom.css"),

  # Create a two-column layout: 70% for map, 30% for popup info
  fluidRow(
    column(width = 3,
           h2("Information"),
           htmlOutput("popup_info")  # Placeholder for dynamic HTML popup info
    ),
    column(width = 9,
           leafletOutput("map", width = "100%", height = "650pt")
    )
  )
))