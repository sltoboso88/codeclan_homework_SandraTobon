library(shiny)
library(tidyverse)
library(CodeClanData)

importance <- names(students_big %>%
                      select(starts_with("importance")))

ui <- fluidPage(

    titlePanel(tags$h3("Plot Different Values")),
    
    selectInput("plot",
                "Which variable to plot?",
                choices = importance),
    
    plotOutput("output_plot")
    
)


server <- function(input, output) {
  
  output$output_plot <- renderPlot({
    students_big %>%
      ggplot(mapping = aes_string(x = input$plot,  fill = "gender") )  +
      geom_density()
  })
  
}

shinyApp(ui = ui, server = server)
