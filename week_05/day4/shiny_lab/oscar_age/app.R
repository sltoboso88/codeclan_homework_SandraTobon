library(tidyverse)
library(shiny)
library(readr)
library(shinythemes)

oscar_winers <- read_csv("~/codeclan_homework_SandraTobon/week_05/weekend_homework/clean_procces/clean_oscar_winers.csv")

min_age = min(unique(oscar_winers$age_win))
max_age = max(unique(oscar_winers$age_win))

ui <- fluidPage(
    theme = shinytheme("cerulean"), 
    titlePanel("Oscar Nominators by age that they have when they win"),

    sidebarLayout(
        sidebarPanel(
          sliderInput("age",
                     "Range of Age:", 
                     min = 11, max = 83, value = 50)
         
        ),
        mainPanel(
           plotOutput("range_age_plot")
        )
    )
)


server <- function(input, output){
  
  output$range_age_plot <- renderPlot({
    oscar_winers %>%
      filter(age_win <= input$age) %>%
      ggplot() +
      aes(x = age_win) +
      geom_bar()
  })
  
}

shinyApp(ui = ui, server = server)
