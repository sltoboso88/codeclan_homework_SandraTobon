library(shiny)
library(tidyverse)
library(CodeClanData)
library(shinythemes)
library(shinyWidgets)

source("global.R")

all_teams <- unique(olympics_overall_medals$team)
chosen_season <- unique(olympics_overall_medals$season)
chosen_medal <- unique(olympics_overall_medals$medal)

ui <- fluidPage(
    
    theme = shinytheme("flatly"),
    
    titlePanel(tags$h1("Olympic Games")),
    
   tabsetPanel( 
        tabPanel(
            "Medal by Country",
            plotOutput("medal_plot"),
            fluidRow(
                column(4,
                       radioButtons("season", 
                                    tags$i("Summer of Winter Olympics?"),
                                    choices = chosen_season)
                ),
                column(4,
                       selectInput("team", 
                                   tags$i("Chose Team"),
                                   choices =  all_teams)
                ),
                column(4,
                       tags$a("Olympic Web", href = "https://www.Olympic.org/")
                )
            )       
    ),
    tabPanel(
        "Medal by 5 Countries", 
        plotOutput("medal_plot_m"),
        fluidRow(
            column(4,
                   radioButtons("season",
                                "Summer of Winter Olympics?",
                                choices = chosen_season)
            ),
            column(4,
                   radioButtons("medal",
                                "Chose Medal",
                                choices = chosen_medal)
            ),
            column(4,
                    multiInput("team", 
                               tags$i("Chose Team"),
                               choices =  all_teams)
                
            )
        )
    )
    
  )
)
        

   


server <- function(input, output) {
    
    output$medal_plot <- renderPlot({
        
        medal_plot(chosen_team = input$team, 
                   chosen_season = input$season)
    })
    
    output$medal_plot_m <- renderPlot({
        medals_olympics(chosen_season = input$season, 
                        chosen_medal = input$medal,
                        chosen_team = input$team)
    })
    
}

shinyApp(ui = ui, server = server)