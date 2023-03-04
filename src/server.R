library(shiny)
library(dplyr)
library(tidyr)
library(forcats)
library(ggplot2)
library(scales)
library(RColorBrewer)
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

# read data and select relevent columns
data <- read.csv('../data/cleaned_dataset.csv') |>
  select(c('Food.name', 'Weight', 'Energy', 'Protein', 'Carbohydrate', 'Total.Fat'))
data[nrow(data)+1,] <- c('None', 1, 0, 0, 0, 0)

# input dropdown food selection
selected_foods = list()
food_list <- data$Food.name 

# populate dropdown lists
observe({
  updateSelectInput(session, inputId='select_food1', label='Select food', choices=food_list, selected='None')
  updateSelectInput(session, inputId='select_food2', label='Select food', choices=food_list, selected='None')
  updateSelectInput(session, inputId='select_food3', label='Select food', choices=food_list, selected='None')
  updateSelectInput(session, inputId='select_food4', label='Select food', choices=food_list, selected='None')
  updateSelectInput(session, inputId='select_food5', label='Select food', choices=food_list, selected='None')
})

# update total input food energy table to be plotted
reactive_data <- reactive({
  f1 <- data |>
    filter(Food.name == input$select_food1)
  f2 <- data |>
    filter(Food.name == input$select_food2)
  f3 <- data |>
    filter(Food.name == input$select_food3)
  f4 <- data |>
    filter(Food.name == input$select_food4)
  f5 <- data |>
    filter(Food.name == input$select_food5)
  
  cal = (as.numeric(f1[[3]])*(input$g1/as.numeric(f1[[2]])) + as.numeric(f2[[3]])*(input$g2/as.numeric(f2[[2]]))
    + as.numeric(f3[[3]])*(input$g3/as.numeric(f3[[2]])) + as.numeric(f4[[3]])*(input$g4/as.numeric(f4[[2]])) 
    + as.numeric(f5[[3]])*(input$g5/as.numeric(f5[[2]])))

  prot <- (4*as.numeric(f1[[4]])*(input$g1/as.numeric(f1[[2]])) + 4*as.numeric(f2[[4]])*(input$g2/as.numeric(f2[[2]]))
    + 4*as.numeric(f3[[4]])*(input$g3/as.numeric(f3[[2]])) + 4*as.numeric(f4[[4]])*(input$g4/as.numeric(f4[[2]])) 
    + 4*as.numeric(f5[[4]])*(input$g5/as.numeric(f5[[2]])))

  carbs <- (4*as.numeric(f1[[5]])*(input$g1/as.numeric(f1[[2]])) + 4*as.numeric(f2[[5]])*(input$g2/as.numeric(f2[[2]]))
    + 4*as.numeric(f3[[5]])*(input$g3/as.numeric(f3[[2]])) + 4*as.numeric(f4[[5]])*(input$g4/as.numeric(f4[[2]])) 
    + 4*as.numeric(f5[[5]])*(input$g5/as.numeric(f5[[2]])))

  fat <- (9*as.numeric(f1[[6]])*(input$g1/as.numeric(f1[[2]])) + 9*as.numeric(f2[[6]])*(input$g2/as.numeric(f2[[2]]))
    + 9*as.numeric(f3[[6]])*(input$g3/as.numeric(f3[[2]])) + 9*as.numeric(f4[[6]])*(input$g4/as.numeric(f4[[2]])) 
    + 9*as.numeric(f5[[6]])*(input$g5/as.numeric(f5[[2]])))

  input_foods <- data.frame(
    nutrients = c("Cals", "Prot", "Carbs", "Fat"),
    values = c(cal, prot, carbs, fat)
  )
})


#Main Plot
#If using Sliders
observeEvent(input$selectSliders,{
  df <- data.frame(
      nutrients = c("Cals", "Prot", "Carbs", "Fat"),
      values = c(as.numeric(input$calSliders), as.numeric(input$proteinSlider)/100 * as.numeric(input$calSliders),
                 as.numeric(input$carbSlider)/100 * as.numeric(input$calSliders), 
                 as.numeric(input$fatSlider)/100 * as.numeric(input$calSliders)))
  
  # get summay data from food input 
  input_foods <- reactive_data()
  df['values_input'] <- input_foods['values']

  
  df <- df |> mutate(nutrients = as_factor(nutrients) |> fct_relevel(c("Fat", "Carbs", "Prot", "Cals")))
  
  cals_input <- df |> filter(nutrients == "Cals") |> pull(values_input)
  cals_goal <- df |> filter(nutrients == "Cals") |> pull(values)

  # Main plot

  plot1 <- ggplot(data = df) + 
    geom_point(aes(x = nutrients, y = values), shape = '-', stroke = 15, size = 15) +
    geom_col(aes(x = nutrients, y = values_input, fill = nutrients), alpha=0.7, colour = "black") +
    labs(x = "Nutrient", y = "Calories") +
    ylim(0, max(cals_input, cals_goal)) +
    theme_bw(base_size = 20) +
    theme(
      legend.key.size = unit(1, 'cm'),
      legend.key.height = unit(1, 'cm'),
      legend.key.width = unit(1, 'cm'),
    ) +
    scale_fill_brewer(palette = 'Dark2')
  
  output$main_plot <- renderPlot(plot1)
  
  
  # Calculate proportions
  prop_df <- df |> filter(nutrients != "Cals")
  prop_df['goal'] <- prop_df['values'] / sum(prop_df['values'])
  prop_df['input'] <- prop_df['values_input'] / sum(prop_df['values_input'])
  prop_df <- prop_df |>
    select(c('nutrients', 'goal', 'input')) |> 
    pivot_longer(2:3, names_to = 'field', values_to = 'prop') |> 
    mutate(nutrients = fct_rev(nutrients))
  
  cals_df <- data.frame(
    field = c('goal', 'input'),
    cals = c(cals_goal, cals_input),
    prop = c(1.17, 1.17),
    nutrients = c('Carbs', 'Carbs')
  )
  
  
  # Sub plot
  subplot1 <- ggplot(prop_df) +
    aes(
      y = field,
      x = prop,
      fill = nutrients
    ) +
    geom_bar(
      stat = "identity",
      colour = 'black',
      alpha = 0.7
    ) +
    geom_text(
      aes(label = ifelse(prop >= 0.05, paste0(sprintf("%.0f", prop*100),"%"),"")),
      position = position_stack(vjust = 0.5),
      colour = "black",
      fontface = "bold",
      size = 6
    ) +
    scale_x_continuous(breaks = c(0, .25, .5, .75, 1), labels = percent_format()) +
    labs(
      y = "",
      x = "",
      fill = ""
    ) +
    theme_bw(base_size = 20) +
    theme(
      legend.key.size = unit(1, 'cm'),
      legend.key.height = unit(1, 'cm'),
      legend.key.width = unit(1, 'cm'),
    ) +
    scale_fill_manual(values = rev(brewer.pal(n=3, "Dark2"))) +
    geom_text(
      aes(label = paste(round(cals, 0), "\ncalories")),
      data = cals_df,
      size = 6,
      hjust = 0.75,
      colour = brewer.pal(n=4, "Dark2")[4],
      fontface = "bold"
    ) +
    guides(fill = guide_legend(reverse = TRUE))
  
  
  
  output$sub_plot <- renderPlot(subplot1)
  })

#If using Manual
observeEvent(input$selectText,{
  cals <- as.numeric(input$proteinText)*4 + as.numeric(input$carbText)*4 + as.numeric(input$fatText)*9
  df <- data.frame(
    nutrients = c("Cals", "Prot", "Carbs", "Fat"),
    values = c(cals, as.numeric(input$proteinText)*4, 
              as.numeric(input$carbText)*4, as.numeric(input$fatText)*9))
  
  # get summay data from food input
  input_foods <- reactive_data()
  df['values_input'] <- input_foods['values']
  
  # plot things
  plot2 <- ggplot(data = df) + 
    geom_point(aes(x = nutrients, y = values)) +
    geom_col(aes(x = nutrients, y = values_input), alpha=0.5)
    labs(x = "Nutrient", y = "Calories") +
    ylim(0, cals) 
  
  output$main_plot <- renderPlot(plot2) 
                              
  })
  
        





  
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

