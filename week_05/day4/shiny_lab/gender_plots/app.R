library(CodeClanData)
library(shiny)
library(tidyverse)

ui <- fluidPage(

    titlePanel(tags$h3("Students Gender in the Data Set")),
    
    radioButtons("char",
                 "Plot Type",
                 choices = c("Bar", "Pie Chart", "Stacked Bar")),
    
    plotOutput("plot_selected")

)

server <- function(input, output) {
    
    filter_gender <- reactive({
        students_big %>%
            group_by(gender) %>%
            summarise(count = n()) 
    })
    
    labs_g <- reactive({
        labs(
            title = "Students by gender",
            x = "Gender",
            y = "Number of students", 
            fill = "Gender"
        )
    })
    
   output$plot_selected <- renderPlot({
       if("Bar" == input$char){
               filter_gender() %>%
                ggplot() +
               aes(x = gender, y = count, fill = gender) +
               geom_bar(stat = "identity") +
               labs_g()
       } else{ 
            if("Stacked Bar" == input$char){
               filter_gender() %>%
               ggplot()+
               aes(x = "", y = count, fill = gender) +
               geom_bar(position = "stack", stat = "identity") +
               labs_g()
       }else{  
           if("Pie Chart" == input$char){
                ggplot(filter_gender(), mapping =  aes(x = "", y = count, fill = gender))+
               geom_bar(stat = "identity", width = 0.5) +
               coord_polar("y") +
                labs_g()
               
       }
               }
           
       }
   })
}

shinyApp(ui = ui, server = server)
