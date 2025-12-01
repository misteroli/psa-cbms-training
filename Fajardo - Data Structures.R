#1
v_odd <- seq(1, 20, 2)
v_odd

#2
v_even <- seq(50, 100, by = 2)
v_even

#3
v <- v_odd + v_even
v
sum(v)

#4
v2 <- v
v2[1] <- 1000
v2[length(v2)] <- 2000
sum(v2)

#5
v3 <- v2[v2 > 100]
length(v3)


v4 <- c(rep(2, 20), NA_real_, rep(3, 4), 5:200 * 6, rep(NA_real_, 4))

#6
length(v4)

#7
sum(is.na(v4))

#8
mean(v4, na.rm = TRUE)
mean(v4)

#9
v5 <- v4[!is.na(v4)]
v5

#10
m <- mean(v4, na.rm = TRUE)
v6 <- v4
v6[is.na(v6)] <- m
v6




v7 <- c(
  "F", "O", "G", "V", "G", "O", "J", "S", "E", "Y", "S", 
  "K", "Y", "E", "X", "H", "Z", "M", "U", "U", "Y", "J"
)

#11
unique(v7)


#12
v7[v7 != "X" & v7 != "Y" & v7 != "Z"]


#13
v7[v7 == "X" | v7 == "Y" | v7 == "Z"]


#14
which(v7 == "X" | v7 == "Y" | v7 == "Z")


#15
sort(v7)


#16
table(v7)


#17
person <- list(
  name = "Mark",
  age = 28,
  hobbies = c("reading", "traveling", "swimming")
)


#18
person$age


#19
person$address <- "123 Main St"


#20
person$hobbies[2]


#21
starwars[, c("name", "height", "mass")]


#22
starwars[starwars$height > 200, ]



#23
starwars[order(starwars$mass, decreasing = TRUE), ]




#24
starwars$bmi <- starwars$mass / (starwars$height/100)^2



#25
starwars[starwars$bmi > 25, ]

