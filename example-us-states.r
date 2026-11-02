library(leaflet)
library(sf)
library(tidyverse)

geo <- read_sf("us-states.geojson")

pal <- colorBin("YlOrRd", domain = geo$density)

leaflet(geo) %>%
  addPolygons(fillColor = ~pal(density))

