library(shiny)
library(leaflet)
library(sf)
library(ggplot2)

states <- read_sf("us-states.geojson")

function(input, output, session) {
  
  output$mtcars <- renderPlot({
    ggplot(mtcars, aes(mpg, cyl)) + geom_col()
  })
  
  observe({
    print(
      brushedPoints(mtcars, input$clicked)
    )
  })
  
  output$states <- renderLeaflet({
    
    states <- read_sf("us-states.geojson")
    map <- leafletProxy("states", states)
    
    bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
    pal <- colorBin("YlOrRd", domain = states$density, bins = bins)
    
    leaflet(states) %>%
      setView(-96, 37.8, 4) %>%
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
  })
  
  observeEvent(input$polygons, {
    states <- read_sf("us-states.geojson")
    map <- leafletProxy("states", session, states)

    if (input$polygons) {
      map %>%
        addPolygons(
          # layerId = "statePolygons",
          group = "statePolygons",
          fillColor = ~pal(density),
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlightOptions = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = labels,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto"))
    } else {
        map %>%
          clearGroup("statePolygons")
    }

  })
  
}