library(shinytest2)

test_that("{shinytest2} recording: food4-entry", {
  app <- AppDriver$new(name = "food4-entry", seed = 123, height = 656, width = 1235)
  app$set_inputs(select_food4 = "Mango")
  app$set_inputs(g4 = 150)
  app$expect_values()
})


test_that("{shinytest2} recording: food5-entry", {
  app <- AppDriver$new(name = "food5-entry", seed = 123, height = 656, width = 1235)
  app$set_inputs(select_food5 = "Kiwifruit")
  app$set_inputs(g5 = 100)
  app$expect_values()
})


test_that("{shinytest2} recording: manual-input-boxes", {
  app <- AppDriver$new(name = "manual-input-boxes", seed = 123, height = 656, width = 1235)
  app$set_inputs(proteinText = "99")
  app$set_inputs(carbText = "27")
  app$set_inputs(fatText = "1")
  app$set_inputs(fatText = "101")
  app$set_inputs(fatText = "101.5")
  app$expect_values()
})
