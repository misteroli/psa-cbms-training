
#1
for (i in 1:10) {
  print(i)
}

#2
seat_mates <- c("Nick", "JC", "Boss Shie", "Ralph", "Alyssa")
for(i in seq_along(seat_mates)) {
  output <- paste0("Hello, ", seat_mates[i],"!")
  print(output)
}


#3
data_files <- list.files("data/sample-txt")
for(i in data_files) {
  print(paste("data/sample-txt", i))
}
