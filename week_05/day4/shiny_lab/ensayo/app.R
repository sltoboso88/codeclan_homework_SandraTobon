library(shiny)
library(dplyr)
library(ggplot2)
library(CodeClanData)
ui <- fluidPage(
    titlePanel("Reaction Time vs. Memory Game"),
    
    sidebarLayout( 
        sidebarPanel(
            
            radioButtons("colour",
                         "Colour of points",
                         choices = c(Blue = "#3891A6", Yellow = "#FDE74C", Red = "#E3655B")),
            
            sliderInput("bins", 
                        "Transperency of points",
                        min = 0, max = 1, value = 1),
            
            selectInput("shape",
                        "Shape of Points",
                        choices = c( Square = "15", Circle = "#16", Triangle = "#17"),
                        selected = "Square")
            
        ),
        
        
        plotOutput("scatter")
        
    )
    
)
server <- function(input, output) {
    output$scatter<- renderPlot({
        ggplot(students_big) %>% 
            aes(x = reaction_time, y = score_in_memory_game) +
            geom_point(alpha = input$alpha)
        
    })
}
shinyApp(ui = ui, server = server)















