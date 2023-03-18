library(shinytest2)

test_that("{shinytest2} recording: main-dash_plot-sliders-button", {
  app <- AppDriver$new(name = "main-dash_plot-sliders-button", seed = 123, height = 656, 
      width = 1235)
  app$click("selectSliders")
  app$expect_values()
})


test_that("{shinytest2} recording: main-dash_plot-manual-button", {
  app <- AppDriver$new(name = "main-dash_plot-manual-button", seed = 123, height = 656, 
      width = 1235)
  app$click("selectText")
  app$expect_values()
})


test_that("{shinytest2} recording: main-dash_food-entry", {
  app <- AppDriver$new(name = "main-dash_food-entry", seed = 123, height = 656, width = 1235)
  app$set_inputs(select_food4 = "Mango")
  app$set_inputs(g4 = 150)
  app$expect_values()
  app$click("selectSliders")
  app$expect_values()
})
