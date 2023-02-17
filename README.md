# MacroView

## Group Members

-   Austin Shih @austin-shih
-   Chester Wang @ChesterAiGo
-   Jakob Thoms @J99thoms
-   Samson Bakos @samson-bakos

## App Description

The purpose of this app is to allow for daily tracking of calorie/ macronutrient intake.

There will be four main graphics displayed by the app, one primary visualisation and three smaller macronutrient specific graphs (one for each of protein, carbs, fat). In the top right, the primary graphic shows current nutrients consumed as a bar plot, with fixed horizontal lines representing user set targets. In the bottom right, specific macro proportions (current/ target) values will be displayed, along with pie-charts visualizing them as a percentage.

There are two user input panels. The first (leftmost) sidebar sets daily targets. Users can opt to input targets in one of two ways: the sliders (top left) or entry fields (bottom left). The sliders are used to input a calorie amount (a slider from 0 to 10000) and the relative percentages of macronutrients (3 linked sliders that will always sum to 100%). The entry fields allow text-based entry of custom macronutrient values that will then automatically calculate the calories. Changing these values will move the target lines in the main graph, and the relative proportions shown in the nutrient specific graphs. Typically, users will set these values once upon opening app.

The second entry bar (center) will be a series of dropdown menus. Users can browse or search our dataset, a database of common foods with nutrient contents. Upon selecting a food, users will input a quantity (in grams), representing the amount they ate. The visualizations will then update showing their current daily total with respect to their goals. Users will interact with this bar as they eat throughout the day and reset at the end of day (could possibly add a convenient reset button to allow users to keep their targets but wipe food).

A top tab bar will be added, linking to an About page (app description), Data page (dataset description, possibly link to the available XML booklet), and a button to download the current main page as a .html doc (for meal planning).

## Example Sketch

![](img/sketch.png)

## License

Please refer to the License File [here](https://github.com/UBC-MDS/MacroView/blob/main/LICENSE)
