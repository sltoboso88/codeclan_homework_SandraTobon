library(tidyverse)
library(shiny)
library(CodeClanData)
library(shinythemes)

region <- unique(students_big %>%
                     mutate(region = str_to_title(region)) %>%
                     select(region))

ui <- fluidPage(

    titlePanel(tags$h3("Comparing Importance of Internet Access vs. Reducing Pollution")),

    sidebarLayout(
        sidebarPanel(
            selectInput("gender",
                        tags$b("Select the Gender"),
                        choices = c(Female = "F", Male = "M")),
            selectInput("region",
                        tags$b("Select the Region"),
                        choices = region),
            actionButton("update_plots", "Update Region and Gender")
            
        ),
        
        mainPanel(
          tabsetPanel(
            tabPanel( "Plots",
              fluidRow(
              column(6,
                     plotOutput("plot_internet")),
              column(6, 
                     plotOutput("plot_pollution"))
            ) ),
            tabPanel( "Data",
              DT::dataTableOutput("table_output")
            )
          )
           
        )
    )
)


server <- function(input, output) {
    
    filter_student <- eventReactive(input$update_plots, {
        students_big %>%
            mutate(region = str_to_title(region)) %>%
            filter(gender == input$gender) %>%
            filter(region == input$region) %>%
            select(region,
                   gender,
                   importance_internet_access, 
                   importance_reducing_pollution)
        
    })
    
    output$plot_internet <- renderPlot({
            ggplot(filter_student() ) +
            aes(x = importance_internet_access) +
            geom_histogram() +
            labs(
                x = "Importance Internet Acces ",
                y = "Points"
            )
    })
    
    output$plot_pollution <- renderPlot({
            ggplot(filter_student()) +
            aes(x = importance_reducing_pollution) +
            geom_histogram() +
            labs(
                x = "Importance Reducing Pollution",
                y = "Points"
            )
    })
    
    output$table_output <- DT::renderDataTable({
      filter_student()
    })
}

shinyApp(ui = ui, server = server)
