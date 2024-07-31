# Load the necessary libraries
library(shiny)
library(gapminder)
library(dplyr)
library(ggplot2)

# Define the UI for the application
ui <- fluidPage(
  # Application title
  titlePanel("Gapminder Data Visualization"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    sidebarPanel(
      # Input: Select a continent to filter by
      selectInput("continent", "Select Continent:",
                  choices = unique(gapminder$continent)),
      
      # Input: Select a variable for the x-axis
      selectInput("xvar", "X-axis variable:",
                  choices = c("gdpPercap", "lifeExp", "pop")),
      
      # Input: Select a variable for the y-axis
      selectInput("yvar", "Y-axis variable:",
                  choices = c("gdpPercap", "lifeExp", "pop")),
      
      # Input: Select a year to filter by
      sliderInput("year", "Year:",
                  min = min(gapminder$year),
                  max = max(gapminder$year),
                  value = min(gapminder$year),
                  step = 5)
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      # Output: Plot
      plotOutput("gapminderPlot")
    )
  )
)

# Define server logic required to draw a plot
server <- function(input, output) {
  # Reactive expression to filter the data based on input
  filteredData <- reactive({
    gapminder %>%
      filter(continent == input$continent & year == input$year)
  })
  
  # Render the plot
  output$gapminderPlot <- renderPlot({
    ggplot(filteredData(), aes_string(x = input$xvar, y = input$yvar)) +
      geom_point() +
      labs(x = input$xvar, y = input$yvar, title = paste("Gapminder Data for", input$continent, "in", input$year)) +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
