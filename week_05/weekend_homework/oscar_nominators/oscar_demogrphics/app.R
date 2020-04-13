library(tidyverse)
library(readr)
library(shiny)
library(shinythemes)

oscar_winers <- read_csv("~/codeclan_homework_SandraTobon/week_05/weekend_homework/clean_procces/clean_oscar_winers.csv")

demography <- names(oscar_winers %>%
    select(race_ethnicity, religion, sexual_orientation))

ui <- fluidPage(
    
    theme = shinytheme("cerulean"), 

    tags$h3(titlePanel("Oscar Awards Winners 1927 to 2014")),

    sidebarLayout(
        sidebarPanel(
            selectInput("demography",
                        "Choice demography",
                        choices = c(select = "", demography)),
            radioButtons("char",
                         "Plot Type",
                         choices = c("Bar", "Pie Chart", "Stacked Bar"))
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Plot Demographies",
                     plotOutput("plot_demography")),
            tabPanel("Demography by Years",
                     plotOutput("plot_demography_year"))
          )
          
        )
    )
)

server <- function(input, output){

  graph_base <- reactive({
    oscar_winers %>%
      group_by_at(input$demography ) %>%
      summarise(count = n())
  })
  
  labs <- reactive({
    theme(
      axis.text.x = element_blank()
    )
  })
  output$plot_demography <- renderPlot({
    if(input$char == "Bar"){
      graph_base () %>%
        ggplot(mapping = aes_string(x = input$demography, y = "count", 
                                    fill = input$demography))+
        geom_bar(stat = "identity") +
        labs()
    } else if (input$char == "Pie Chart"){
      graph_base () %>%
        ggplot(mapping = aes_string(x = "1", y = "count", 
                                    fill = input$demography))+
        geom_bar(stat = "identity", width = 0.5) +
        coord_polar("y") +
        labs()
    } else if (input$char == "Stacked Bar"){
      graph_base () %>%
        ggplot(mapping = aes_string(x = "1", y = "count", 
                                    fill = input$demography))+
        geom_bar(stat = "identity", position = "stack") +
        labs()
    }
    
  })
    
  output$plot_demography_year <- renderPlot({
    oscar_winers %>%
      ggplot(aes_string(x = "year_of_award", 
                        fill = input$demography))+
      geom_bar() +
      facet_wrap(as.formula(paste("~", input$demography)))
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
