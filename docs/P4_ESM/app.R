#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)

bsl <- read.csv("cancerData.csv", stringsAsFactors = FALSE)

bsl <- bsl %>%
  mutate(stat_num = case_when(
    stat == "deaths" ~ 1,
    stat == "cases" ~ 2,
    stat == "mortalityRate" ~ 3,
    stat == "deathsPerMillion" ~ 4,
    TRUE ~ NA_real_,

  ))


# Define UI for application
ui <- fluidPage(
    titlePanel("ESM Personality Data"),

    sidebarLayout(
      sidebarPanel(
      sliderInput("year", "Year", min = 1999, max = 2011,
                  value = c(2005,2010),
      radioButtons("value", "Value",
                   choices = c("deaths","cases","mortalityRate", "deathsPerMillion"),
                   selected = "deaths")),
      mainPanel(plotOutput("coolplot"),
                tableOutput("cooltable"))
      ))

# Define server logic
server <- function(input, output) {

  output$coolplot <- renderPlot({

    bsl %>%
      filter(Year >= input$year[1],
             Year <= input$year[2],
             stat == input$stat) %>%
    ggplot(aes(x=year, y=value)) +
      geom_point() +
      geom_smooth(method = "lm")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
