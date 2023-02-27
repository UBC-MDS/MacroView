library(shiny)
library(dplyr)
library(ggplot2)


server <- function(input, output, session) {

  
  output$sortedChart <- renderPlot({
    data <- read.csv('../data/cleaned_dataset.csv') |> rename(name = Food.name)
    specCol <- data[, input$component]
    data$colByWeight <- ifelse(data$Weight == 0, 0, specCol / data$Weight)
    
    top_data <- data |> arrange(desc(colByWeight)) |> head(input$topK)
    
    top_data |> ggplot(aes(x = reorder(name, -colByWeight), y = colByWeight)) +
      geom_bar(stat = "identity") +
      labs(x = "Food name", y = paste0(input$component, "/ Weight"))
      
  })
}

