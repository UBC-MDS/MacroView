library(shiny)
library(plotly)

ui <- navbarPage('MacroView', # App title goes here!
                 
                 tabPanel('Dashboard', # first navbar page
                          headerPanel("Macroview Main Dashboard"),
                          fluidPage(
                            
                            fluidRow(
                              
                              # Leftmost Input Panel 
                              column(2,
                                     
                              titlePanel("Enter Nutrient Targets"),
                              actionButton("selectSliders", "Use Sliders", class = "btn-block"),
                              numericInput("calSliders", "Enter Calorie Goal", 
                                           value = 2000, min = 0, max = 20000),
                              sliderInput("proteinSlider", "Protein %", 
                                          value = 25, min = 0, max = 100),
                              sliderInput("carbSlider", "Carb %", 
                                          value = 50, min = 0, max = 100),
                              sliderInput("fatSlider", "Fat %", 
                                          value = 25, min = 0, max = 100),
                              tableOutput("table_sliders"),
                              actionButton("selectText", "Use Manual Input?", class = "btn-block"),
                              textInput("proteinText", "Protein (Grams)",
                                        value = 100),
                              textInput("carbText", "Carbs (Grams)",
                                        value = 100),
                              textInput("fatText", "Fat (Grams)",
                                        value = 100),
                              tableOutput("table_text")
                    
                              ),
                              # END leftmost panel
                              
                              # Middle Panel (Drop Downs)
                              column(3,
                                    titlePanel("Enter Food")),
                              # End Middle Panel
                              
                              # Right Panel (Visualizations)
                              column(5, 
                                     titlePanel("Daily Totals"),
                                     plotOutput("main_plot", width = "400px")
                                     )
                              # End Right Panel
                              
                              
                                    
                              
                              
                              )
                            
                          
                  )),
                 
                 tabPanel('About', 'A Page to display some other static information'), 
                 tabPanel('Data', 'A Page to display some other static information'),
                 tabPanel('Download', 'A Page to display some other static information'),
                 
                 
                 tabPanel('Statistics', 
                          titlePanel("Get the Nutrition Rank!"),
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId='component',
                                          label='Select a compoent to rank',
                                          choices=c('Energy', 'Protein', 'Carbohydrate', 'Total Sugar', 'Total Fat', 
                                                    'Saturated Fat', 'Monounsaturated Fat', 'Polyunsaturated Fat', 
                                                    'Cholesterol', 'Calcium', 'Iron', 'Sodium', 'Potassium', 'Magnesium',
                                                    'Phosphorus', 'Vitamin A', 'Lycopene', 'Folate', 'DHA', 'EPA', 
                                                    'Vitamin D', 'Vitamin B12', 'Vitamin E', 'Trans Fat', 'Vitamin C'
                                                    ),
                                          selected='Energy'),
                              sliderInput(inputId='topK',
                                          label='Choose top K food to rank',
                                          min=2,
                                          max=44,
                                          value=10)
                            ),
                           
                            mainPanel(
                              plotlyOutput(outputId = 'sortedChart')
                            )
                          )
              )

)
