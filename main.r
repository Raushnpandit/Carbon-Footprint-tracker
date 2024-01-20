# Install and load necessary packages
install.packages(c("shiny", "ggplot2"))
library(shiny)
library(ggplot2)  # Add this line to load ggplot2

# Sample data (replace this with your actual data)
regions <- c("Region A", "Region B", "Region C")
years <- 2020:2025

# Sample carbon footprint data for energy, transportation, and industrial emissions
energy_emissions <- matrix(sample(50:100, length(years) * length(regions), replace = TRUE), ncol = length(regions))
transportation_emissions <- matrix(sample(20:50, length(years) * length(regions), replace = TRUE), ncol = length(regions))
industrial_emissions <- matrix(sample(10:60, length(years) * length(regions), replace = TRUE), ncol = length(regions))

# Create a data frame
carbon_data <- data.frame(Region = rep(regions, each = length(years)),
                          Year = rep(years, times = length(regions)),
                          Energy = as.vector(t(energy_emissions)),
                          Transportation = as.vector(t(transportation_emissions)),
                          Industrial = as.vector(t(industrial_emissions)))

# Define UI
ui <- fluidPage(
  titlePanel("Carbon Footprint Tracker"),
  sidebarLayout(
    sidebarPanel(
      selectInput("region", "Select Region:", choices = regions, selected = regions[1])
    ),
    mainPanel(
      plotOutput("carbon_plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$carbon_plot <- renderPlot({
    selected_region <- input$region
    filtered_data <- carbon_data[carbon_data$Region == selected_region, ]
    
    ggplot(filtered_data, aes(x = Year)) +
      geom_line(aes(y = Energy, color = "Energy"), size = 1.5) +
      geom_line(aes(y = Transportation, color = "Transportation"), size = 1.5) +
      geom_line(aes(y = Industrial, color = "Industrial"), size = 1.5) +
      labs(title = paste("Carbon Footprint Tracker -", selected_region),
           x = "Year",
           y = "Carbon Footprint",
           color = "Emission Type") +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui, server)
