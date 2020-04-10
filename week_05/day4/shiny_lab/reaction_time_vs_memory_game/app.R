library(CodeClanData)
library(tidyverse)
library(shiny)

ui <- fluidPage(
    
    titlePanel(tags$h3("Reaction Time vs Memory Game")),
    
    sidebarLayout( 
        
        sidebarPanel(
                       
        radioButtons("color",
                    tags$b("Color of points"), 
                    choices = c(Blue = "#3891A6", Yellow = "#FDE74C", Red = "#E3655B")
        ),
        
        sliderInput("alpha",
                   tags$b("Transparency of points"),
                    min = 0, max = 1, value = 0.7),
        
        selectInput("shape",
                    tags$b("Shape of points"),
                    choices = list("Square" = 15, "Circle" = 16, "Triangle" = 17)),
        
        textInput("text",
                  tags$b("Title of Graph"),
                  value = "Reaction time vs Memory game")
        
    ),
    
    mainPanel(
        plotOutput("reaction_memory_plot")
    )
    )
)

server <- function(input, output){
    
    output$reaction_memory_plot <- renderPlot({
        students_big %>%
            ggplot() +
            aes(x = reaction_time, y = score_in_memory_game) +
            geom_point(
                       shape = as.integer(input$shape), 
                       alpha = input$alpha,
                       colour = input$color) +
            labs(
                title = input$text,
                x = "Reaction Time",
                y = "Score in memory game"
            )
    })
    
}

shinyApp(ui = ui, server = server)