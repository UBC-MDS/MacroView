library(shiny)

ui <- navbarPage('MacroView', # navbar!
                 tabPanel('A', # first navbar page
                          titlePanel("Where our main dashboard lives"),
                          sidebarLayout(
                            sidebarPanel("You can add Input function here"), # sidebar panel inside the first navbar page
                            mainPanel(
                              tabsetPanel( # there are two tabs in the main panel 
                                tabPanel('tab-1',
                                         "First panel"
                                ),
                                tabPanel('tab-2',
                                         "Second panel"
                                         
                                )
                              )
                            )
                          )
                        ),
                 tabPanel('B', 'A Page to display some other static information'), # second navbar tab.
                 tabPanel('Histogram', # third navbar tab. We added here the UI elements we coded in L1
                          titlePanel("Old Faithful Geyser Data ("),
                          sidebarLayout(
                            sidebarPanel( # the slider input is in the sidebar
                              sliderInput(inputId='bins',
                                          label='i am label',
                                          min=2,
                                          max=50,
                                          value=20)
                            ),
                            mainPanel( # The histogram plot is the main panel
                              plotOutput(outputId = 'hist')
                              )
                            )
                          )
  
)
