library(shinytest2)

test_that("{shinytest2} recording: main-dashboard_plot-sliders", {
  app <- AppDriver$new(name = "main-dashboard_plot-sliders", height = 968, width = 1832)
  app$set_inputs(carbSlider = 64)
  app$set_inputs(proteinSlider = 31)
  app$click("selectSliders")
  app$expect_values()
})


test_that("{shinytest2} recording: main-dashboard_plot-manual", {
  app <- AppDriver$new(name = "main-dashboard_plot-manual", height = 968, width = 1832)
  app$set_inputs(proteinText = "250")
  app$set_inputs(carbText = "10")
  app$set_inputs(fatText = "100")
  app$click("selectSliders")
  app$click("selectText")
  app$expect_values()
})


test_that("{shinytest2} recording: main-dashboard_food-entry", {
  app <- AppDriver$new(name = "main-dashboard_food-entry", height = 968, width = 1832)
  app$set_inputs(select_food1 = "Salmon, smoked")
  app$set_inputs(g1 = 1000)
  app$set_inputs(select_food4 = "Peanut butter, natural")
  app$set_inputs(g4 = 100)
  app$set_inputs(select_food3 = "Apple with skin (7cm.diam)")
  app$set_inputs(select_food2 = "Quinoa, cooked")
  app$set_inputs(select_food5 = "Yogourt, vanilla or fruit, 1-2% M.F.")
  app$set_inputs(g5 = 1)
  app$set_inputs(g5 = 2)
  app$set_inputs(g5 = 3)
  app$click("selectSliders")
  app$expect_values()
})


test_that("{shinytest2} recording: main-dashboard_download-reports", {
  app <- AppDriver$new(name = "main-dashboard_download-reports", height = 968, width = 1832)
  app$click("selectSliders")
  app$expect_download("download_sliders")
  app$expect_values()
  app$click("selectText")
  app$expect_download("download_manual")
})

