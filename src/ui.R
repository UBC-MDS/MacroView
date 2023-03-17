library(shiny)
library(plotly)

ui <- navbarPage(
  theme = bslib::bs_theme(bootswatch = 'cerulean'),
  'MacroView',
  # App title goes here!
  # dashboard tab
  tabPanel(
    'Dashboard',
    # first navbar page
    h1("Macroview Main Dashboard"),
    fluidPage(fluidRow(
      #2,
      
      # Leftmost Input Panel
      column(
        #1
        
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
          value = 25,
          min = 0,
          max = 100
        ),
        sliderInput(
          "carbSlider",
          "Carb %",
          value = 50,
          min = 0,
          max = 100
        ),
        sliderInput(
          "fatSlider",
          "Fat %",
          value = 25,
          min = 0,
          max = 100
        ),
        tableOutput("table_sliders"),
        actionButton("selectText", "Plot Manual Input?", class = "btn-block"),
        textInput("proteinText", "Protein (Grams)",
                  value = 100),
        textInput("carbText", "Carbs (Grams)",
                  value = 100),
        textInput("fatText", "Fat (Grams)",
                  value = 100),
        tableOutput("table_text"),
        width = 2,
        offset = 0
        
      ),
      # END leftmost panel
      
      # Middle Panel (Drop Downs)
      column(
        #2
        h4("Food Entry"),
        
        # mid panel row 1
        fluidRow(
          column(
            h6('Foods'),
            selectInput(
              inputId = 'select_food1',
              label = 'Select food 1',
              choices = 'Names',
              selected = 'None',
              width = '100%',
            ),
            width = 9,
            offset = 0
          ),
          column(
            h6('Weights'),
            numericInput(
              "g1",
              "Grams",
              value = 0,
              min = 0,
              max = 9000
            ),
            width = 3,
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
              selected = 'None',
              width = '100%'
            ),
            width = 9,
            offset = 0
          ),
          column(
            numericInput(
              "g2",
              "Grams",
              value = 0,
              min = 0,
              max = 9000
            ),
            width = 3,
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
              selected = 'None',
              width = '100%'
            ),
            width = 9,
            offset = 0
          ),
          column(
            numericInput(
              "g3",
              "Grams",
              value = 0,
              min = 0,
              max = 9000
            ),
            width = 3,
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
            width = 9,
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
            width = 3,
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
            width = 9,
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
            width = 3,
            offset = 0
          )
        ),
        
        width = 3,
        offset = 0
      ),
      # End Middle Panel
      
      
      
      # Right Panel (Visualizations)
      column(
        5,
        titlePanel("Macroutrient Totals"),
        plotOutput("main_plot", width = "600px"),
        titlePanel("Macronutrient Proportions"),
        plotOutput("sub_plot", width = "600px")
      )
      # End Right Panel
      
      
      
      
      
    ))
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
          inputId = 'component',
          label = 'Select a compoent to rank',
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
