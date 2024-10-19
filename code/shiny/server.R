# server.R

library(shiny)        # For creating Shiny apps
library(htmlwidgets)  # For onRender function

# Define server logic
# Define server logic
shinyServer(function(input, output, session) {

  # Render the initial Leaflet map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = 'https://cartocdn-gusc.global.ssl.fastly.net//ramirocartodb/api/v1/map/named/tpl_756aec63_3adb_48b6_9d14_331c6cbc47cf/all/{z}/{x}/{y}.png'
      ) %>%

      # Set the initial view of the map to a specific location and zoom level
      setView(lng = 30, lat = 20, zoom = 6) %>%

      # Add house markers (without Leaflet popups)
      addMarkers(
        data = house_data,
        group = "Houses",                     # Group houses for layer control
        lng = ~st_coordinates(geom_wkt)[, 1], # Longitude from spatial data
        lat = ~st_coordinates(geom_wkt)[, 2], # Latitude from spatial data
        layerId = ~house_name,                # Use house_name as the marker ID
        # No need for popups here, as we will handle them separately in the observeEvent below
        #popup = ~house_info,                  # Popup showing the house name and summary
        icon = house_icons                    # Use the custom icons created
      ) %>%

      # Add location markers (without Leaflet popups)
      addMarkers(
        data = location_data,
        group = "Locations",                  # Group locations for layer control
        lng = ~st_coordinates(geom_wkt)[, 1], # Longitude from spatial data
        lat = ~st_coordinates(geom_wkt)[, 2], # Latitude from spatial data
        layerId = ~location_name,             # Use location_name as the marker ID
        # No need for popups here, as we will handle them separately in the observeEvent below
        #popup = ~location_info,               # Popup showing the location name and summary
        icon = location_icons                 # Use the custom icons created
      ) %>%

      # Add layer control to toggle between layers
      addLayersControl(
        overlayGroups = c("Locations", "Houses"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })

  # Observe marker click events (both houses and locations)
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click  # Get clicked marker info

    # First, try to match the click with house_data
    selected_house <- house_data %>% filter(house_name == click$id)

    if (nrow(selected_house) > 0) {
      # If a house was clicked, display house info
      output$popup_info <- renderUI({
        HTML(selected_house$house_info)
      })
    } else {
      # If no house was clicked, check if it matches location_data
      selected_location <- location_data %>% filter(location_name == click$id)

      if (nrow(selected_location) > 0) {
        # Display location info if a location marker was clicked
        output$popup_info <- renderUI({
          HTML(selected_location$location_info)
        })
      }
    }
  })
})
