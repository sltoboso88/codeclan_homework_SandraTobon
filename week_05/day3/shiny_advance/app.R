library(shiny)
library(tidyverse)
library(CodeClanData)
library(shinythemes)

source("global.R")

all_teams <- unique(olympics_overall_medals$team)
chosen_season <- unique(olympics_overall_medals$season)
chosen_medal <- unique(olympics_overall_medals$medal)

ui <- fluidPage(
    
    theme = shinytheme("flatly"),
    
    titlePanel(tags$h1("Olympic Games")),
    
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
                   tags$a("Olympic Web", href = "https://www.Olympic.org/"),
            )
        )
    ), 
    tabPanel(
        "Medal by 5 Countries", 
        fluidRow(
            plotOutput("medal_plot_m")
        ),
        fluidRow(
            column(6,
                   radioButtons("season",
                                "Summer of Winter Olympics?",
                                choices = chosen_season)
            ),
            column(6,
                   radioButtons("medal",
                                "Chose Medal",
                                choices = chosen_medal)
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
                        chosen_medal = input$medal)
    })
    
}

shinyApp(ui = ui, server = server)