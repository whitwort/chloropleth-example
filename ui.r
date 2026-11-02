library(shiny)
library(leaflet)
library(sf)

fluidPage(
  checkboxInput("polygons", "Show polygons", TRUE),
  leafletOutput("states"),
  plotOutput("mtcars", brush = "clicked")
)