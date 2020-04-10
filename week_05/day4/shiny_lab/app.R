library(tidyverse)
library(CodeClanData)
library(shiny)

age <- unique(students_big$ageyears)

ui <- fluidPage(
    
    titlePanel(tags$h3("Height and Arm Span vs Age")),
    
    radioButtons("age", 
                 tags$b("Students Age"),
                 choices = age,
                 inline = TRUE),
    fluidRow(
        column(6,
            plotOutput("height_plot")
        ),
        column(6,
            plotOutput("arm_span_plot")
        )
    )
)

server <- function(input, output){
    
    age_filter <- reactive({
        students_big %>%
            select(height, arm_span, ageyears) %>%
            filter(ageyears == input$age)
    })
    
    output$height_plot <- renderPlot({
            ggplot(age_filter()) +
            aes(x = height) +
            geom_histogram() +
            labs(
                title = "Height of Students",
                x = "Height",
                y = "Number of Students"
            )
    })
    
    output$arm_span_plot <- renderPlot({
        ggplot(age_filter()) +
            aes(x = arm_span) +
            geom_histogram() +
            labs(
                title = "Arm Span",
                x = "Arm Span",
                y = "Number of Students"
            )
    })
    
}

shinyApp(ui = ui, server = server)