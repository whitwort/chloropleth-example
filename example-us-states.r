library(leaflet)
library(geojsonio)
library(tidyverse)

geo <- geojson_read("states.geo.json", what = "sp")

# geo@data <- left_join(geo@data, myTable, by = c("NAME" = "State"))

geo@data <- mutate(geo@data, value = sample(1:100, nrow(geo@data)))

pal <- colorBin("YlOrRd", domain = geo@data$value)

leaflet(geo) %>%
  addPolygons(fillColor = ~pal(value))

