#===============================================================================
# 1. Using the starwars dataset, select the columns that ends with “color”.
#===============================================================================
library(dplyr)
select(starwars, name, ends_with("color"))


#===============================================================================
# 2. Filter the dataset to include only characters who are from Tatooine and
#    human species.
#===============================================================================
human_tatooine = filter(starwars, species == "Human" & homeworld == "Tatooine")
print(human_tatooine)


#===============================================================================
# 3. Create a new column height_in that converts height from centimeters to
#    inches and get the average height by homeworld.
#===============================================================================
avg_h = mutate(starwars, height_in = height  * 0.39370079)

summarize(
  group_by(starwars, homeworld),
  average_height = mean(height  * 0.39370079, na.rm = TRUE)
)


#===============================================================================
# 4. Summarize the number of characters by species and gender and sort the
#    result in descending order.
#===============================================================================
View(
arrange(
  summarize(
    group_by(filter(starwars, !is.na(species)), species, gender),
    count = n()
  ), desc(count)
)
)

#or (with NA)

View(
  arrange(
    summarize(
      group_by(starwars, species, gender),
      count = n()
    ), desc(count)
  )
)


#===============================================================================
# 5. Mutate the value of sex column to 8 for all NA values, 1 for male,
#    2 for female, and 3 for hermaphroditic, 4 for none.
#===============================================================================
mutate(starwars,
  sex = case_when(
    is.na(sex) ~ 8,
    sex == "male" ~ 1,
    sex == "female" ~ 2,
    sex == "hermaphroditic" ~ 3,
    sex == "none" ~ 4
  )
)

View(starwars)
