library(tidyverse)
library(shiny)
library(readr)
library(shinythemes)

oscar_winers <- read_csv("~/codeclan_homework_SandraTobon/week_05/weekend_homework/clean_procces/clean_oscar_winers.csv")



ui <- fluidPage(
    
    theme = shinytheme("cerulean"), 
    
    tags$h3(titlePanel("Oscar Awards Winners 1927 to 2014")),
    
    sidebarPanel(
      #here I am doing 2 dropdown that the socond depend of the behavoir of the first. So the user 
      #can choice the continent and the specific country that he wants to see
      uiOutput("select_var1"), 
      uiOutput("select_var2")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel( "Plots",
                  fluidRow(
          column(6, 
                 plotOutput("continent_awards_plot")),
          column(6,
                 plotOutput("country_awards_plot"))
        )),
        tabPanel("Table",
                 DT::dataTableOutput("data_table_awards"))
      )
      
    )

   
)

server <- function(input, output) {
#With this app I pretend that the user could filter the winers by country and I choice bar char
#because is categorical data and I want to count it by award. 
  plot_filter <- reactive({
    oscar_winers %>%
      filter(continent == input$continent)
  })
  
  plot_filter_1 <- reactive({
      plot_filter() %>%  
      filter(country == input$country)
  })
  
  
  output$select_var1 <- renderUI({
    selectizeInput("continent", 
                   "Select Continent", 
                   choices = c("select" = "", unique(oscar_winers$continent)))
  })
  
  output$continent_awards_plot <- renderPlot({
    ggplot(plot_filter(), mapping = aes(x = award)) +
      geom_bar() +
      scale_y_continuous(limits = c(0,75)) +
      labs(
        title = input$continent,
        x = "Award",
        y = "Number Actors"
      ) +
      theme(
        axis.text = element_text(size = 4)
      )
  })
  
  output$select_var2 <- renderUI({
    
    choices_country <- reactive({
      oscar_winers %>%
        filter(continent == input$continent) %>%
        pull(country)
    })
    
    selectizeInput("country",
                   "Select Country",
                   choices = c("select" = "", choices_country()) )
    
  })
  
  output$country_awards_plot <- renderPlot({
    
      ggplot(plot_filter_1(), mapping = aes(x = award)) +
      geom_bar() +
      scale_y_continuous(limits = c(0, 75)) +
      labs(
        title = input$country,
        x = "Award",
        y = "Number Actors"
      ) + 
      theme(
        axis.text = element_text(size = 4))
  })
  
  output$data_table_awards <- DT::renderDataTable({
    plot_filter() %>%
      select(person, movie, award, year_of_award, country)
  })
}



shinyApp(ui = ui, server = server)
