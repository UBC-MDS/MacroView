## Reflection, Week 2

We were able to implement most of the desired baseline functionality of our dashboard this week, with only a few components changed/ missing. 

The complexity of our dashboard is not with the visualisation, but with the multiple interlocking and conditional inputs. For example, the sliders are set up such that shifting one slider equally adjusts the other two such that they always sum to 100, we can conditionally select which set of inputs are used for plotting, etc. Getting this to work as intended was a lot of trial and error and fairly high effort as this was our first experience with reactive programming. 

Overall this week we were able to implement the baseline functionality successfully, and now need to focus on visual customization and making the user experience more convenient. 

#### Key changes from the original design:

* We added an extra “Statistics” Tab, with visualisation ranking food by nutrient, as an additional feature so that all four group members would have a task/ visualisation role
* Changed main plot to a single axis for simplicity. Plot is in terms of calories by total/ nutrient. Note that two people were responsible for the main plot. One person coded the target inputs/ target visualisation, another the food inputs/ food bar plot. These are separate reactive elements
* Didn’t get conditional table rendering (only rendering the specific table of macronutrients currently plotted instead of both at once). We believe we know how to set this up now, but haven’t had time to implement yet.
* It was easier to have plotting tied to an action button than update dynamically for every single possible input change (or conditionally depending on which inputs are active). We would have needed an observer/ plot statement block for all inputs,  ~17 of them, instead of just for the buttons.
* We set a fixed number of dropdowns rather than having them dynamically generated as needed. Not sure how to do this or if it's possible, will look into it.

#### To do/ future improvements:

* We generated extra information tabs for in-app documentation, but havent populated them yet as we were focused on functionality this week.
* We need to work on themes/ visualisation customization to make it more appealing
* Ideally we need to add more entry boxes or find a way to make sure a new one is generated when all are used.
* We should change up the colouring/ marks used in the main plot to make it more appealing. We are waiting to decide on the overall theme so that it matches.
* Matching food inputs with the dataset is a little frustrating as some of the food names are non intuitive. Some form of regex matching, or even very simple NLP would be helpful to make usage less frustrating
* We are still waiting on one set of primary visualisations (pie charts displaying remaining proportion/ grams for each macronutrient). We are hoping to have this complete before the milestone 2 release date.
