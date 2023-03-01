library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)


server <- function(input, output, session) {
  
# Leftmost Panel, Output Current Targets
output$table_sliders <- renderTable(data.frame(cals = input$calSliders,
    prot = input$proteinSlider/400 * input$calSliders,
    carbs = input$carbSlider/400 * input$calSliders,
    fat = input$fatSlider/900 * input$calSliders))
  
output$table_text <- renderTable(data.frame(
      cals = as.numeric(input$proteinText)*4 + as.numeric(input$carbText)*4 + as.numeric(input$fatText)*9,
      prot = input$proteinText,
      carbs = input$carbText,
      fat = input$fatText))

# Link Sliders to Sum to 100
# Update Protein Slider
observeEvent(input$proteinSlider,  {
  if(as.numeric(input$proteinSlider) + as.numeric(input$carbSlider) + as.numeric(input$fatSlider) != 100){
    updateSliderInput(session = session, inputId = "carbSlider", 
                    value = input$carbSlider - (input$fatSlider + input$carbSlider + input$proteinSlider - 100)/2)
    updateSliderInput(session = session, inputId = "fatSlider", 
                      value = input$fatSlider - (input$fatSlider + input$carbSlider + input$proteinSlider - 100)/2)
}
  })

#Update Fat Slider
observeEvent(input$fatSlider,  {
  if(as.numeric(input$proteinSlider) + as.numeric(input$carbSlider) + as.numeric(input$fatSlider) != 100){
    updateSliderInput(session = session, inputId = "carbSlider", 
                      value = input$carbSlider - (input$fatSlider + input$carbSlider + input$proteinSlider - 100)/2)
    updateSliderInput(session = session, inputId = "proteinSlider", 
                      value = input$proteinSlider - (input$fatSlider + input$carbSlider + input$proteinSlider - 100)/2)
  }
})

#Update Carb Slider
observeEvent(input$carbSlider,  {
  if(as.numeric(input$proteinSlider) + as.numeric(input$carbSlider) + as.numeric(input$fatSlider) != 100){
    updateSliderInput(session = session, inputId = "fatSlider", 
                      value = input$fatSlider - (input$fatSlider + input$carbSlider + input$proteinSlider - 100)/2)
    updateSliderInput(session = session, inputId = "proteinSlider", 
                      value = input$proteinSlider - (input$fatSlider + input$carbSlider + input$proteinSlider - 100)/2)
  }
})

#Main Plot
observeEvent(input$selectSliders,{
  df <- data.frame(
      nutrients = c("cals", "prot", "carbs", "fat"),
      values = c(as.numeric(input$calSliders), as.numeric(input$proteinSlider)/400 * as.numeric(input$calSliders),
                 as.numeric(input$carbSlider)/400 * as.numeric(input$calSliders), 
                 as.numeric(input$fatSlider)/900 * as.numeric(input$calSliders)))
  
  output$main_plot <- renderPlot(ggplot(data = df, aes(x = nutrients, y = values)) + geom_point())
  })

observeEvent(input$select)
  

             
        





  
#Statistics/ Ranking Plot Tab
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

