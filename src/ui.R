library(shiny)
library(plotly)

ui <- navbarPage('MacroView', # App title goes here!
                 
                 tabPanel('Dashboard', # first navbar page
                          headerPanel("Macroview Main Dashboard"),
                          fluidPage(
                            
                            fluidRow(
                              
                              # Leftmost Input Panel 
                              column(5,
                                     
                              titlePanel("Enter Nutrient Targets"),
                              checkboxInput("selectSliders", "Use Sliders?", value = TRUE),
                              numericInput("calSliders", "Enter Calorie Goal", 
                                           value = 2000, min = 0, max = 20000),
                              sliderInput("proteinSlider", "Protein %", 
                                          value = 25, min = 0, max = 100),
                              sliderInput("carbSlider", "Carb %", 
                                          value = 50, min = 0, max = 100),
                              sliderInput("fatSlider", "Fat %", 
                                          value = 25, min = 0, max = 100),
                              checkboxInput("selectText", "OR Use Manual Input?", value = FALSE),
                              textInput("proteinText", "Protein (Grams)",
                                        value = 100),
                              textInput("carbText", "Carbs (Grams)",
                                        value = 100),
                              textInput("fatText", "Fat (Grams)",
                                        value = 100),
                              
                              
                              ),
                              # END leftmost panel
                              
                              
                              
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
