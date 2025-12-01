#1
for(i in 1:10) {
  print(i)
}



#2
names <- c("Sam", "Alas", "Jim", "Sheng", "Drew")
for(i in names) {
  print(paste("Hello,", i, "!"))
}


#3
sum_even <- 0
for(i in 1:100) {
  if(i %% 2 == 0) {
    sum_even <- sum_even + i
  }
}
print(sum_even)



#4
nums <- c(3, 8, 15, 22, 29)
for(i in nums) {
  if(i %% 2 == 0) {
    print(paste(i, "is even"))
  } else {
    print(paste(i, "is odd"))
  }
}



#5
data_files <- list.files("C:/Users/Tea/Downloads/Other Training Materials/data/sample-txt")
for(i in data_files) {
  print(paste("C:/Users/Tea/Downloads/Other Training Materials/data/sample-txt", i, sep = "/"))
}


