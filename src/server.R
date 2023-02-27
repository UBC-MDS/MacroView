library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)


server <- function(input, output, session) {

  output$sortedChart <- renderPlotly({
    data <- read.csv('../data/cleaned_dataset.csv') |> rename(name = Food.name)
    specCol <- data[, gsub(" ", ".", input$component, fixed=TRUE)]
    data$colByWeight <- ifelse(data$Weight == 0, 0, specCol / data$Weight)
    
    top_data <- data |> arrange(desc(colByWeight)) |> head(input$topK)
    
    top_data |> 
      plot_ly(x = ~reorder(name,-colByWeight), y = ~colByWeight) |> 
      add_bars() |> layout(title = 'Food ranked by energy/component, sorted', xaxis = list(title = 'Food Name'))
      
  })
}

