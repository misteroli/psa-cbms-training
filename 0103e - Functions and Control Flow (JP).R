#===============================================================================
# 1. Write a for loop that prints the numbers from 1 to 10, each on a new line.
#===============================================================================
for (i in 1:10) {
  print(i)
}

#===============================================================================
# 2. Write a for loop that iterates over a vector of names of 5 people near you
#    (seat mates) and prints a greeting for each name (e.g., “Hello, John!”).
#===============================================================================
seat_mates <- c("Nick", "JC", "Boss Shie", "Ralph", "Alyssa")
for(i in seq_along(seat_mates)) {
  output <- paste0("Hello, ", seat_mates[i],"!")
  print(output)
}


#===============================================================================
# 3. Given the following code, write a for loop that prints the full path of
#    each file in the files vector:
#===============================================================================
data_files <- list.files("data/sample-txt")
for(i in data_files) {
  print(paste("data/sample-txt", i))
}
