library(shiny)
library(dplyr)
library(tidyr)
library(forcats)
library(ggplot2)
library(scales)
library(RColorBrewer)
library(plotly)
library(shinythemes)


# Server
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
  data <- read.csv('https://raw.githubusercontent.com/UBC-MDS/MacroView/main/data/cleaned_dataset.csv') |>
    select(c('Food.name', 'Weight', 'Energy', 'Protein', 'Carbohydrate', 'Total.Fat'))
  data[nrow(data)+1,] <- c('None', 1, 0, 0, 0, 0)
  
  # input dropdown food selection
  selected_foods = list()
  food_list <- data$Food.name
  
  # populate dropdown lists
  observe({
    updateSelectInput(session, inputId='select_food1', label='Select food', choices=food_list, selected='Chicken, ground, lean, cooked')
    updateSelectInput(session, inputId='select_food2', label='Select food', choices=food_list, selected='Rice, brown, long-grain, cooked')
    updateSelectInput(session, inputId='select_food3', label='Select food', choices=food_list, selected='Banana')
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
    
    df <- df |> mutate(nutrients = as_factor(nutrients) |> fct_relevel(c("Fat", "Carbs", "Prot", "Cals")))
    
    cals_input <- df |> filter(nutrients == "Cals") |> pull(values_input)
    cals_goal <- df |> filter(nutrients == "Cals") |> pull(values)
    
    
    # Main plot
    plot2 <- ggplot(data = df) +
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
    
    output$main_plot <- renderPlot(plot2)
    
    
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
    subplot2 <- ggplot(prop_df) +
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
    
    
    
    output$sub_plot <- renderPlot(subplot2)
    
  })
  
  
  
  
  
  #Statistics/ Ranking Plot Tab
  output$sortedChart <- renderPlotly({
    data <- read.csv('https://raw.githubusercontent.com/UBC-MDS/MacroView/main/data/cleaned_dataset.csv') |> rename(name = Food.name)
    primaryCol <- data[, gsub(" ", ".", input$primarycomponent, fixed=TRUE)]
    secondaryCol <- data[, gsub(" ", ".", input$secondarycomponent, fixed=TRUE)]
    
    data$colByWeightPrimary <- ifelse(data$Weight == 0, 0, primaryCol / data$Weight)
    data$colByWeightSecondary <- ifelse(data$Weight == 0, 0, secondaryCol / data$Weight)
    
    top_data <- data |> arrange(desc(colByWeightPrimary), desc(colByWeightSecondary)) |> head(input$topK)
    
    top_data |>
      plot_ly(x = ~reorder(name,-(colByWeightPrimary * 1000 + colByWeightSecondary)), y = ~colByWeightPrimary) |>
      add_bars() |> layout(title = 'Food ranked by energy/component, sorted', xaxis = list(title = 'Food Name'))
    
  })
}







# UI
ui <- navbarPage(
  theme = shinytheme("spacelab"),
  'MacroView',
  # App title goes here!
  # dashboard tab
  tabPanel(
    'Dashboard',
    # first navbar page
    h1('Macroview Main Dashboard'),
    sidebarLayout(
      # sidebar panel for inputs
      sidebarPanel(
        width=5,
        fluidRow(
          # target input 
          column(
            width=5,
            h4("Enter Nutrient Targets"),
            actionButton("selectSliders", "Plot Sliders", class = "btn-block"),
            numericInput(
              "calSliders",
              "Enter Calorie Goal",
              value = 2000,
              min = 0,
              max = 20000
            ),
            sliderInput(
              "proteinSlider",
              "Protein %",
              value = 30,
              min = 0,
              max = 100
            ),
            sliderInput(
              "carbSlider",
              "Carb %",
              value = 40,
              min = 0,
              max = 100
            ),
            sliderInput(
              "fatSlider",
              "Fat %",
              value = 30,
              min = 0,
              max = 100
            ),
            tableOutput("table_sliders"),
            actionButton("selectText", "Plot Manual Input", class = "btn-block"),
            textInput("proteinText", "Protein (Grams)",
                      value = 150),
            textInput("carbText", "Carbs (Grams)",
                      value = 200),
            textInput("fatText", "Fat (Grams)",
                      value = 65),
            tableOutput("table_text")
          ),
          
          # user input entry
          column(
            width=7,
            h4("Food Entry"),
            fluidRow(
              column(
                h5('Foods'),
                selectInput(
                  inputId = 'select_food1',
                  label = 'Select food 1',
                  choices = 'Names',
                  selected = 'Chicken, ground, lean, cooked',
                  width = '100%'
                ),
                width = 8,
                offset = 0
              ),
              column(
                h5('Weights'),
                numericInput(
                  "g1",
                  "Grams",
                  value = 500,
                  min = 0,
                  max = 9000
                ),
                width = 4,
                offset = 0
              )
            ),
            
            # mid panel row 2
            fluidRow(
              column(
                selectInput(
                  inputId = 'select_food2',
                  label = 'Select food 2',
                  choices = 'Names',
                  selected = 'Rice, brown, long-grain, cooked',
                  width = '100%'
                ),
                width = 8,
                offset = 0
              ),
              column(
                numericInput(
                  "g2",
                  "Grams",
                  value = 400,
                  min = 0,
                  max = 9000
                ),
                width = 4,
                offset = 0
              )
            ),
            
            # mid panel row 3
            fluidRow(
              column(
                selectInput(
                  inputId = 'select_food3',
                  label = 'Select food 3',
                  choices = 'Names',
                  selected = 'Banana',
                  width = '100%'
                ),
                width = 8,
                offset = 0
              ),
              column(
                numericInput(
                  "g3",
                  "Grams",
                  value = 200,
                  min = 0,
                  max = 9000
                ),
                width = 4,
                offset = 0
              )
            ),
            
            # mid panel row 4
            fluidRow(
              column(
                selectInput(
                  inputId = 'select_food4',
                  label = 'Select food 4',
                  choices = 'Names',
                  selected = 'None',
                  width = '100%'
                ),
                width = 8,
                offset = 0
              ),
              column(
                numericInput(
                  "g4",
                  "Grams",
                  value = 0,
                  min = 0,
                  max = 9000
                ),
                width = 4,
                offset = 0
              )
            ),
            
            # mid panel row 5
            fluidRow(
              column(
                selectInput(
                  inputId = 'select_food5',
                  label = 'Select food 5',
                  choices = 'Names',
                  selected = 'None',
                  width = '100%'
                ),
                width = 8,
                offset = 0
              ),
              column(
                numericInput(
                  "g5",
                  "Grams",
                  value = 0,
                  min = 0,
                  max = 9000
                ),
                width = 4,
                offset = 0
              )
            )
          )
        )
      ),
      
      # mainpanel for plots
      mainPanel(
        width=7,
        h1("Macroutrient Totals"),
        plotOutput("main_plot", width = "1000px"),
        h1("Macronutrient Proportions"),
        plotOutput("sub_plot", width = "1000px")
      ),
      position = "left"
    )
  ),
  
  tabPanel('About', 'A Page to display some other static information'),
  tabPanel('Data', 'A Page to display some other static information'),
  tabPanel('Download', 'A Page to display some other static information'),
  
  tabPanel(
    'Statistics',
    titlePanel("Get the Nutrition Rank!"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = 'primarycomponent',
          label = 'Select your primary component to rank',
          choices = c(
            'Energy',
            'Protein',
            'Carbohydrate',
            'Total Sugar',
            'Total Fat',
            'Saturated Fat',
            'Monounsaturated Fat',
            'Polyunsaturated Fat',
            'Cholesterol',
            'Calcium',
            'Iron',
            'Sodium',
            'Potassium',
            'Magnesium',
            'Phosphorus',
            'Vitamin A',
            'Lycopene',
            'Folate',
            'DHA',
            'EPA',
            'Vitamin D',
            'Vitamin B12',
            'Vitamin E',
            'Trans Fat',
            'Vitamin C'
          ),
          selected = 'Energy'
        ),
        selectInput(
          inputId = 'secondarycomponent',
          label = 'Select your secondary component to rank',
          choices = c(
            'Energy',
            'Protein',
            'Carbohydrate',
            'Total Sugar',
            'Total Fat',
            'Saturated Fat',
            'Monounsaturated Fat',
            'Polyunsaturated Fat',
            'Cholesterol',
            'Calcium',
            'Iron',
            'Sodium',
            'Potassium',
            'Magnesium',
            'Phosphorus',
            'Vitamin A',
            'Lycopene',
            'Folate',
            'DHA',
            'EPA',
            'Vitamin D',
            'Vitamin B12',
            'Vitamin E',
            'Trans Fat',
            'Vitamin C'
          ),
          selected = 'Energy'
        ),
        sliderInput(
          inputId = 'topK',
          label = 'Choose top K food to rank',
          min = 2,
          max = 44,
          value = 10
        )
      ),
      
      mainPanel(plotlyOutput(outputId = 'sortedChart'))
    )
  )
)


shinyApp(ui, server)

