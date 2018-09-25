# Tomatosim

This is a Rails application that implements a coding challenge provided by Agrilyst. The application is a simple simulator for the growth of a
tomato plant. After creating (and naming!) your tomato, you take turns adding Nitrogen, Phosphorus, Potassium, Water, and Light to your plant (using a value from 0 to 100). Each nutrient except sunlight has an associated "half-life" that represents the amount of time it takes for that nutrient to dissipate from the environment. If you keep each nutrients at the proper levels, your roots and plants will grow and a tomato will be produced!

To run the app, 

1. clone the repository `cd` into the directory

2. run `bundle install`. 

3. create the sqlite database schema by running `rake db:migrate`

4. start the application by running `rails s`

5. navigate your web browser to http://localhost:3000/


You can run a small suite of tests by running `rspec`.

Enjoy!