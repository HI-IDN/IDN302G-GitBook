# https://blog.patricktriest.com/game-of-thrones-leaflet-webpack/

# Load necessary libraries
library(tidyverse)   # For data manipulation
library(RPostgres)   # For PostgreSQL database connection
library(sf)          # For spatial data manipulation (Simple Features)
library(leaflet)     # For creating interactive maps
library(dotenv)      # For loading environment variables (credentials)

# Load database credentials from the .env file
# This ensures that sensitive information like user credentials remains hidden
dotenv::load_dot_env(".env")

# Establish connection to PostgreSQL database using credentials from .env file
con <- dbConnect(RPostgres::Postgres(),
                 host = "junction.proxy.rlwy.net",      # Database host
                 port = 55303,                          # Database port
                 dbname = "railway",                    # Database name
                 user = Sys.getenv("PGUSER"),           # Username from .env
                 password = Sys.getenv("PGPASSWORD")    # Password from .env
)

# Query for location data, retrieving the WKT format (spatial geometry) for points
query <- "SELECT gid, name, ST_AsText(geog) as geom_wkt FROM atlas.locations"
location_data <- dbGetQuery(con, query) %>%
  # Convert Well-Known Text (WKT) format to sf spatial object with WGS 84 coordinate reference system (CRS)
  st_as_sf(wkt = "geom_wkt", crs = 4326)  # EPSG 4326 represents WGS 84, the most common GPS system

# Query for kingdom data, retrieving the WKT format (spatial geometry) for polygons
query <- "SELECT gid, name, ST_AsText(geog) as geom_wkt FROM atlas.kingdoms"
kingdom_data <- dbGetQuery(con, query) %>%
  # Convert WKT to sf spatial object
  st_as_sf(wkt = "geom_wkt", crs = 4326) %>%
  # Generate random colors for each kingdom for visualization purposes
  mutate(color = colorRampPalette(colors = rainbow(n()))(n()))

# Create a Leaflet map with interactive elements
leaflet() %>%
  # Add base tiles using Carto tile layer, a common map style
  addTiles(
    urlTemplate = 'https://cartocdn-gusc.global.ssl.fastly.net//ramirocartodb/api/v1/map/named/tpl_756aec63_3adb_48b6_9d14_331c6cbc47cf/all/{z}/{x}/{y}.png'
  ) %>%

  # Add location markers using circle markers
  # Cluster the markers together so that they form clusters when zoomed out
  addCircleMarkers(
    data = location_data,
    group = "Locations",                          # Group locations for layer control
    lng = ~st_coordinates(geom_wkt)[, 1],         # Longitude from spatial data
    lat = ~st_coordinates(geom_wkt)[, 2],         # Latitude from spatial data
    popup = ~name,                                # Popup showing the location name
    radius = 5,                                   # Size of the circle marker
    color = "blue",                               # Color of the marker
    fillOpacity = 0.7,                            # Opacity of the fill color
    clusterOptions = markerClusterOptions()       # Cluster the markers together
  ) %>%

  # Add kingdom polygons (for areas) with dynamic fill colors
  addPolygons(
    data = kingdom_data,
    group = "Kingdoms",                           # Group kingdoms for layer control
    fillColor = ~color,                           # Color each kingdom polygon differently
    weight = 2,                                   # Line thickness for the polygon boundary
    opacity = 1,                                  # Line opacity
    color = "black",                              # Border color of polygons
    dashArray = "3",                              # Dashed line style for the borders
    fillOpacity = 0.5,                            # Opacity of the polygon fill color
    popup = ~name                                 # Popup showing the kingdom name
  ) %>%

  # Add layer controls to toggle between viewing Locations and Kingdoms
  addLayersControl(
    overlayGroups = c("Locations", "Kingdoms"),    # Allow toggling of layers
    options = layersControlOptions(collapsed = FALSE) # Keep the control panel open by default
  )
