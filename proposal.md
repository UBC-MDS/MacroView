# Motivation and Purpose

# Description of Data

The dataset used in this dashboard comes from the Nutrient Value of Some Common Foods published by Health Canada. This [booklet](https://www.canada.ca/en/health-canada/services/food-nutrition/healthy-eating/nutrient-data/nutrient-value-some-common-foods-2008.html) contains the nutrient values of 1100 commonly consumed foods in Canada from 19 categories. Each category is contained in a separate .csv file, which can be accessed [here](https://open.canada.ca/data/en/dataset/a289fd54-060c-4a96-9fcf-b1c6e706426f). A combined .csv file of all the food items was used to create this dashboard.

The dataset includes 22 columns for each categorized food group. 19 of those columns lists important nutrient values of each food item. For the purposes of this dashboard, which explicitly focuses on macro nutrients, the columns `Food Name`, `Weight (g)`, `Energy (kcal)`,  `Protein (g)`, `Carbohydrate (g)`, and `Total Fat (g)` will be used to visualize nutrient intake and targets.

The column `Food Name` will be used to identify and search for a particular food item. `Weight (g)` along with `Energy (kcal)`will be used to determine the unit energy per gram of each food item. `Protein (g)`, `Carbohydrate (g)`, and `Total Fat (g)` will be used to visualize the macro make-up of each food item.
# Research Question and Usage Scenarios

## Research Question

As aforementioned, our goal in creating this app is to assist individuals who wish to track their nutrition but don't know where to begin or are not satisfied with existing apps for various reasons. In order to accomplish this goal, we will focus on the following research questions in the development of our dashboard:

1.  What is the duration required for users to become familiar with the usage of MacroView?
2.  Which demographic groups (i.e. in terms of age, gender, education level, etc.) are more likely to find MacroView useful?
3.  What measurements / metrics can we use to evaluate the level of engagement and satisfaction of our users with the app?
4.  How can we design the app to be more user-friendly and visually attractive for our users?

## Usage Scenarios

Bob is a UBC student who wants to keep track of his nutrition. He understands the importance of having a healthy diet but lives on a tight budget.

Frustrated with existing platforms (which have recently moved to much more aggressive premium business models -- i.e. MyFitnessPal, Lifesum), Bob is in search of a nutrition tracking platform that is free, publicly accessible and uses reliable datasets. 

Bob needs to be able to quickly [look up ingredients] from a reliable database, and have the platform pull up the most relevant values. Bob generally makes healthy choices, so he’s not too concerned with micronutrients -- he is mostly concerned with macronutrients to synergize with his exercise and manage his weight.

When using the app, Bob will [weigh out the food] he is making for himself, and enter the amounts as he goes. He wants to see his current totals of macronutrients for the day and his remaining amounts in both written and visualization formats (e.g. a barplot with a target bar).
