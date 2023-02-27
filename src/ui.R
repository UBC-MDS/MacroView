library(shiny)

ui <- navbarPage('MacroView', # App title goes here!
                 tabPanel('Dashboard', # first navbar page
                          titlePanel("Where our main dashboard lives"),
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
                                          choices=c('Energy', 'Protein'),
                                          selected='Energy'),
                              sliderInput(inputId='topK',
                                          label='Choose top K food to rank',
                                          min=2,
                                          max=44,
                                          value=10)
                            ),
                           
                            mainPanel(
                              plotOutput(outputId = 'sortedChart')
                            )
                          )
              )

)
