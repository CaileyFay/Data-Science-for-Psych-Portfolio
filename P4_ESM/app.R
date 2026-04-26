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
library(tidyverse)
library(googlesheets4)
library(bslib)

source("/Users/caileyfay/Documents/LabsD4P/Data-Science-for-Psych-Portfolio/P4_ESM/cleaning_ESM.r")
syn_data <- read.csv("my_synthetic_data.csv")

# Define UI for application
ui <- library(shiny)
library(bslib)

ui <- fluidPage(
    titlePanel("ESM Personality Data"),

    page_navbar(
      theme = bs_theme(version = 5, bootswatch = "minty")
    ), #I got this theme and code from https://shiny.posit.co/r/articles/build/themes/

    sidebarLayout(
      sidebarPanel(
      sliderInput("hour", "Time of Day", min = 0, max = 24, #my slide is going to allow me to isolate times of day
                  value = c(9,18)),

       radioButtons("who_are_you", "Subject",
                   choices = c("Cailey","Ethan"), #I can select a button to show me the graph for Cailey or Ethan
                   selected = "Cailey")),

        selectInput("selected_trait", "Choose Trait", #I needed help from Gemini with this because I didn't know if I could select multiple columns to choose from
                 choices = c("Extraversion","Agreeableness","Conscientiousness","Emotional_Stability","Openness"),
                selected = "Extraversion")), #it appears to be working!

         mainPanel(plotOutput("coolplot"),
                tableOutput("cooltable"))
      )

# Define server logic
server <- function(input, output) {

  output$coolplot <- renderPlot({

      syn_data %>%
     filter(hour >= input$hour[1],
           hour <= input$hour[2],
       who_are_you == input$who_are_you) %>%
  # selected_trait == input$selected_trait) %>%

         ggplot(mapping = aes(x=hour, y=.data[[input$selected_trait]])) + #I got the y variable thing from Gemini because It was taking forever to figure out
      geom_col(fill = "tan") +
      labs(title = "Personality State Levels at Different Times of Day, For Different Subjects",
           x = "Time of Day, in Military Time",
           y = "Personality State Level") +
      theme_classic()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
