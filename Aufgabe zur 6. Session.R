library(tidyverse)
library(e1071)
library(shiny)








model.svm <- readRDS('titanic.svm.rds')
#model.svm_2 <- readRDS('titanic_2.svm.rds')

ui <- fluidPage(
  
  
  titlePanel("Sollte ich mich von Kreuzfahrten mit Schiffen aus dem 20. Jahrhundert fernhalten?"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      #selectInput(inputId = "dataset",
       #           label = "Choose a dataset:",
        #          choices = c("Toms Albys Modell", "Mein Modell")),
      
      sliderInput("age",
                  "Alter",
                  min = 0,
                  max = 100,
                  value = 30),
      
      radioButtons("sex", selected = NULL, "Geschlecht:",
                  c("w" = 1,
                    "m" = 0)),
      
      helpText("Da diese Simulation mit Daten der Passagiere der Titanic arbeitet, ist eine Auswahl des dritten Geschlechtes nicht moeglich. Wir bitten um Ihr Verstaendnis."),
      
      selectInput("pclass", selected = NULL, "Passagierklasse:",
                  c("1" = 1,
                    "2" = 2,
                    "3" = 3)),
      
      actionButton("action", label = "Berechnen")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      tableOutput("value1")
      
    )
  )
)


server <- function(input, output, session) {
  
  #datasetInput <- reactive({
    #switch(input$dataset,
     #      "Tom Albys Modell" = model.svm,
      #     "Mein Modell" = model_2.svm)
  #})
  
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