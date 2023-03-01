library(shiny)
library(plotly)

ui <- navbarPage('MacroView', # App title goes here!
                 tabPanel('Dashboard', # first navbar page
                          titlePanel("Macroview Main Dashboard"),
                  ),
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
