library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)


server <- function(input, output, session) {

  #Main Dashboard, Left Panel, Mutually Exclusive Buttons
  observeEvent(input$selectSliders, {
    updateCheckboxInput(session = session, inputId = "selectText", value = 1 - input$selectSliders)
  })
  observeEvent(input$selectText, {
    updateCheckboxInput(session = session, inputId = "selectSliders", value = 1 - input$selectText)
  })
  
  
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

