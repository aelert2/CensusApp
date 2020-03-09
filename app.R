# percent_map function in helpers.R to plot the counties data as a choropleth map
# Argument	    Input
# var	          a column vector from the counties.rds dataset
# color	        any character string you see in the output of colors()
# legend.title	A character string to use as the title of the plot’s legend
# max	          A parameter for controlling shade range (defaults to 100)
# min	          A parameter for controlling shade range (defaults to 0)

library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui = ui, server = server)

# runApp("app.R")
# Line to turn in on Canvas: runGitHub("census-app", "aelert2")


# server <- function(input, output) {
#   
#   output$selected_var <- renderText({ 
#     paste0("You have selected ", input$var, ". You have choosen a range from ", input$range[1], " to ", input$range[2], ".")
#     #paste("You have choosen a range from", input$range[1], "to", input$range[2])
#   })
#   
# }
