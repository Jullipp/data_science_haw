library(tidyverse)
library(e1071)
library(shiny)








model.svm <- readRDS('titanic.svm.rds')

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Uberlebensrechner"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput("age",
                  "Alter",
                  min = 0,
                  max = 100,
                  value = 30),
      
      selectInput("sex", selected = NULL, "Geschelcht:",
                  c("weiblich" = 1,
                    "maennlich" = 0)),
      selectInput("pclass", selected = NULL, "Passagierklasse:",
                  c("1" = 1,
                    "2" = 2,
                    "3" = 3)),
      
      actionButton("action", label = "Wie hoch sind meine Chancen das Unglück zu überleben?")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      tableOutput("value1")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
  
  observeEvent(input$action, {
    pclass <- as.numeric(input$pclass)
    sex <- as.numeric(input$sex)
    age <- input$age
    data <- data.frame(pclass,sex,age)
    print(str(data))
    result <- predict(model.svm, data, probability = TRUE)
    my_result <- data.frame(attr(result, "probabilities"))
    output$value1 <- renderTable(my_result)
  })
  
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)