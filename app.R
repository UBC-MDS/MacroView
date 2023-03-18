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
  
  
  # Slider input
  get_data_sliders <- function(){
    df <- data.frame(
      nutrients = c("Cals", "Prot", "Carbs", "Fat"),
      values = c(as.numeric(input$calSliders), as.numeric(input$proteinSlider)/100 * as.numeric(input$calSliders),
                 as.numeric(input$carbSlider)/100 * as.numeric(input$calSliders),
                 as.numeric(input$fatSlider)/100 * as.numeric(input$calSliders)))
    
    input_foods <- reactive_data()
    df['values_input'] <- input_foods['values']
    
    
    df <- df |> 
      mutate(nutrients = as_factor(nutrients) |> fct_relevel(c("Fat", "Carbs", "Prot", "Cals")))
    
    cals_input <- df |> filter(nutrients == "Cals") |> pull(values_input)
    cals_goal <- df |> filter(nutrients == "Cals") |> pull(values)
    
    list(df = df, cals_input = cals_input, cals_goal = cals_goal)
  }
  
  
  # Manual input
  get_data_manual <- function(){
    cals <- as.numeric(input$proteinText)*4 + as.numeric(input$carbText)*4 + as.numeric(input$fatText)*9
    df <- data.frame(
      nutrients = c("Cals", "Prot", "Carbs", "Fat"),
      values = c(cals, as.numeric(input$proteinText)*4,
                 as.numeric(input$carbText)*4, as.numeric(input$fatText)*9))
    
    # get summary data from food input
    input_foods <- reactive_data()
    df['values_input'] <- input_foods['values']
    
    df <- df |>
      mutate(nutrients = as_factor(nutrients) |> fct_relevel(c("Fat", "Carbs", "Prot", "Cals")))
    
    
    cals_input <- df |> filter(nutrients == "Cals") |> pull(values_input)
    cals_goal <- df |> filter(nutrients == "Cals") |> pull(values)

        
    list(df = df, cals_input = cals_input, cals_goal = cals_goal)
  }
  
  
  
  # Calculate proportions for the subplot
  calc_proportions <- function(df){
    prop_df <- df |> filter(nutrients != "Cals")
    prop_df['goal'] <- prop_df['values'] / sum(prop_df['values'])
    prop_df['input'] <- prop_df['values_input'] / sum(prop_df['values_input'])
    prop_df <- prop_df |>
      select(c('nutrients', 'goal', 'input')) |>
      pivot_longer(2:3, names_to = 'field', values_to = 'prop') |>
      mutate(nutrients = fct_rev(nutrients))
    
  
    prop_df
  }
  
  
  
  # Main plot
  main_plot <- function(data){
    df <- data$df
    cals_input <- df |> filter(nutrients == "Cals") |> pull(values_input)
    cals_goal <- df |> filter(nutrients == "Cals") |> pull(values)
    
    plot <- ggplot(data = df) +
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
    
    plot
  }
  
  
  
  # Sub plot
  sub_plot <- function(data){
    df <- data$df
    cals_input <- df |> filter(nutrients == "Cals") |> pull(values_input)
    cals_goal <- df |> filter(nutrients == "Cals") |> pull(values)
    
    prop_df <- calc_proportions(df)
    
    cals_df <- data.frame(
      field = c('goal', 'input'),
      cals = c(cals_goal, cals_input),
      prop = c(1.17, 1.17),
      nutrients = c('Carbs', 'Carbs')
    )
    
    subplot <- ggplot(prop_df) +
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
    
    
    subplot
  }
  
  
  get_input_foods <- function(){
    input_foods_list <- c(
      input$select_food1,
      input$select_food2,
      input$select_food3,
      input$select_food4,
      input$select_food5
      ) # This is super good coding btw
    input_grams_list <- c(
      input$g1, input$g2, input$g3, input$g4, input$g5
    )
    
    foods <- data.frame(
        food_name = input_foods_list,
        weight_grams = input_grams_list
        ) |> 
      filter(food_name != 'None')
      
    foods
  }
  
  
  

  
  #If using Sliders
  observeEvent(input$selectSliders,{
    data <- get_data_sliders() 
    
    # Main plot
    plot1 <- main_plot(data)
    output$main_plot <- renderPlot(plot1)
    
    # Sub plot
    subplot1 <- sub_plot(data)
    output$sub_plot <- renderPlot(subplot1)
  })
  
  #If using Manual
  observeEvent(input$selectText,{
    data <- get_data_manual()
    
    # Main plot
    plot2 <- main_plot(data)
    output$main_plot <- renderPlot(plot2)
    
    
    # Sub plot
    subplot2 <- sub_plot(data)
    output$sub_plot <- renderPlot(subplot2)
  })
  
  
  
  # Render report for downloading
  render_report <- function(file, data){
    
    
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
    tempReport <- file.path(tempdir(), "report.Rmd")
    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    
    # Run the analysis
    # --
    input_foods_df <- get_input_foods()
    
    totals_df <- data$df |> 
      rename(
        nutrient = nutrients,
        goal_calories = values,
        input_calories = values_input
      )
    
    main_plot <- main_plot(data)
    
    proportions_df <- calc_proportions(data$df) |> 
      pivot_wider(names_from = field, values_from = prop) |> 
      rename(
        nutrient = nutrients,
        goal_proportion = goal,
        input_proportion = input
      )
    
    cals_prop <- data.frame(nutrient = c('Cals'), goal_proportion = c(1), input_proportion=c(1))
    
    proportions_df <- rbind(cals_prop, proportions_df)
    
    sub_plot <- sub_plot(data)
    # --
    
    # Set up parameters to pass to Rmd document
    params <- list(
      input_foods = input_foods_df, 
      totals = totals_df,
      main_plot = main_plot,
      proportions = proportions_df,
      sub_plot = sub_plot
    )
    
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
    rmarkdown::render(
      tempReport, 
      output_file = file,
      params = params,
      envir = new.env(parent = globalenv())
    )
  }
  
  
  # Download report (slider input)
  output$download_sliders <- downloadHandler(
    filename = function() {
      "report.html"
    },
    content = function(file) {
      data <- get_data_sliders()
      render_report(file, data)
    }
  )
  
  # Download report (manual input)
  output$download_manual <- downloadHandler(
    filename = function() {
      "report.html"
    },
    content = function(file) {
      data <- get_data_manual()
      render_report(file, data)
    }
  )
  
  
  
  
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
  # dashboard tab
  tabPanel(
    'Dashboard',
    # first navbar page
    h1('MacroView Main Dashboard'),
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
                      ),
                      
                      fluidRow(
                        h4(""),
                        column(
                          width = 7,
                        )
                      ),
                      fluidRow(
                        h4(""),
                        column(
                          width = 7,
                        )
                      ),
                      fluidRow(
                        h4(""),
                        column(
                          width = 7,
                        )
                      ),
                      fluidRow(
                        h4(""),
                        column(
                          width = 7,
                        )
                      ),
                      
                      
                      # Download report button
                      fluidRow(
                          column(
                            h4("Download Report"),
                            width = 5,
                            offset = 4,
                          ),
                          column(
                            h5("Slider Input"),
                            downloadButton("download_sliders"),
                            width = 5,
                            offset = 4,
                          ), 
                          column(
                            h5("Manual Input"),
                            downloadButton("download_manual"),
                            width = 5,
                            offset = 4,
                          ),
                    )
                )
          )
      ),
      
      # mainpanel for plots
      mainPanel(
        width=7,
        h1("Macronutrient Totals"),
        plotOutput("main_plot", width = "1000px"),
        h1("Macronutrient Proportions"),
        plotOutput("sub_plot", width = "1000px")
      ),
      position = "left"
    )
  ),
  
  tabPanel('About', 
           h2('Macroview'),
           'Macroview is an application designed to provide a convenient, premium level 
           experience for tracking macronutrient intake, while employing transparent, 
           government approved nutrition data.',
           h3('Macro Tracking:'),
           'Tracking macronutrients is an essential component of the flexible dieting 
           nutrition strategy, a very common approach for both competitive athletes and 
           individuals with specific health/ physique goals.  As the name implies, flexible 
           dieting provides more flexibility than a set diet plan, allowing for variation of 
           food intake while maintain the progress/ performance benefits of structured 
           dieting by ensuring overall nutrition targets. It is important to note that 
           flexible dieting is not a replacement healthy eating, and users should still 
           ensure to hit their nutrient targets with mostly whole, healthy foods. A common 
           approach is the 80/20 or 90/10 rule, where individuals attempt to have 80-90% of 
           their nutrients come from healthy, whole sources, with the remainder being free 
           to come from processed/junk foods',
           h5(''),
           'The essence of the strategy is to set specific daily targets for the main three 
           macronutrients (Protein, Carbohydrates, Fats), but to take a flexible approach 
           to fulfilling these targets. This accomplishes control of total intake via 
           implicitly setting a calorie total as a sum of the energy content of macro 
           goals, allowing for control of body weight changes. But beyond simple calorie 
           tracking, macro tracking allows for specific optimization of the benefits of 
           each macronutrient:',
           h4('Protein:'),
           'A minimum amount of protein is required for optimal protein synthesis, and 
           increased protein promotes satiety.',
           h4('Carbohydrates:'),
           'Carbohydrates are important for energy and ensuring optimal training performance.
           Carbohydrates are the main macronutrient manipulated to control total intake.',
           h4('Fats:'),
           'A minimum amount of fat is required for proper health/ hormonal function. 
           Increased fats can also help increase total caloric intake for individuals 
           who struggle with hitting sufficient calories for their goals. ',
           h3('Target Setting Guidance:'),
           'Please note that the developers of Macroview are not doctors or registered 
           The recommendations below are based on personal anecdotal and coaching experience. 
           Specifically, developer Samson Bakos is an experienced natural bodybuilder and 
           certified personal trainer with experience in nutrition coaching for both lifestyle
           and competitive clients. Please do not attempt drastic diet protocols without 
           guidance of a professional.',
           h4('Total Calories:'),
           'An idea of baseline caloric needs can be obtained from simple calculators, 
           i.e.: https://www.calculator.net/bmr-calculator.html which give an estimate 
           based on sex, height, weight and activity level. From this basal metabolic rate,
           users can choose to maintain, gain or lose weight. A surplus or deficit of ~500 
           calories will lead to a gain or loss of 1 pound, respectively. So for a user with 
           a maintenance caloric intake of 2500, they will lose approximately 1 pound a week 
           eating 2000 calories. Note that basal metabolic rate is roughly distributed on 
           a bell curve, with some individuals having much higher or much lower needs. The 
           best way to establish your metabolic rate is to track both intake and weight 
           trends for several weeks, and calculate your needs from there, but calculators 
           ive a good place to start. Note as well that it is recommended to not lose or 
           gain more than 1% of your total body mass per week.',
           h4('Protein:'),
           'The RDA requirement (0.8g per kg bodyweight) is generally considered to be 
           very low for individuals involved in athletics or desiring physique changes. 
           Macroview developers recommend 1.5g/kg for individuals involved in regular 
           athletics, to as high as 2.0-2.2g/kg for those involved in intense resistance 
           training.',
           h4('Fat and Carbs:'),
          'Fat and Carbs are generally considered “energy calories” and are used to fill 
          out the remainder of the desired caloric total. Carbs promote energy and training 
          performance, and fats promote satiety. Exact balance depends on user food 
          preferences, but it is not recommended to drop below 0.3g/kg for either 
          macronutrient.',
          h3('App Usage:'),
          'See the ReadMe for detailed example images of usage.',
          'The left-most panel allows users to set their macronutrient targets, with a 
          choice between using sliders to set macronutrient percentages (top) or inputting
          specific values (bottom). Once set, users must click either the “Plot Sliders” or 
          “Plot Manual Input” to display plots, which appear on the right side. The top plot 
          displays the set targets and current logged intake in terms of calories. The 
          bottom plot displays a bar plot of the current macro breakdown of intake as 
          percentages alongside the desired final breakdown based on set targets.',
          h5(''),
          'The middle panel allows for selection of a food from the dataset, along with 
          a quantity consumed in grams. Once food consumed has been entered, users should 
          click the desired plotting button (see above) to visualize their intake.'
           ),
  tabPanel('Data', 
           h3('About the Dataset:'),
           'The dataset for this app is “Nutrient Value of Some Common Foods (NVSCF)”, 
           provided by Health Canada, available through the open.canada.ca portal: 
           https://open.canada.ca/data/en/dataset/a289fd54-060c-4a96-9fcf-b1c6e706426f. ',
           h5(''),
           'The dataset is designed as a “quick and easy reference to help make informed 
           food choices through an understanding of the nutrient content of the foods you 
           eat.”',
           h5(''),
           'Note that Macroview does not use all the available columns in the dataset, 
           as this app is used to track calories and macronutrients, not micronutrients 
           (vitamins/ minerals) or other values (sugars, cholesterol, saturated fat, etc). 
           Making healthy choices with respect to specific food selections is left to the 
           user. More information for foods in the dataset is available in a directly 
           readable format in the following booklet: 
           https://open.canada.ca/data/en/dataset/a289fd54-060c-4a96-9fcf-b1c6e706426f/resource/a30e489c-f191-42b5-8f22-1e366e99e7a1'
           ),
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

