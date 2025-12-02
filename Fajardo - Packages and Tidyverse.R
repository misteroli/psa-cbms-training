#1
select(starwars, name, ends_with("color"))


#2
x = filter(starwars, species == "Human" & homeworld == "Tatooine")
print(x)


#3
avg_h = mutate(starwars, height_in = height  * 0.39370079)

summarize(
  group_by(starwars, homeworld), 
  average_height = mean(height  * 0.39370079, na.rm = TRUE)
)

summarize(
  group_by(starwars, homeworld), 
  average_height = mean(height, na.rm = TRUE)
)




#4

View(
arrange(
  summarize(
    group_by(filter(starwars, !is.na(species)), species, gender),
    count = n()
  ), desc(count)
)
)

#or

View(
  arrange(
    summarize(
      group_by(starwars, species, gender),
      count = n()
    ), desc(count)
  )
)




#5
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

help(is.na)
