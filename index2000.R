#install.packages("data.table")
library(data.table)
rm(list=ls())

setwd("/scratch/groups/jzeitzer/UKBB/Data/Outputs/timeSeries/")

file.list <- list.files() # gets list of files - assumes your working directory is where the files are

check.csv <- function(csv.path){ #checks your criteria
  
  the.csv <- fread(file = csv.path, header = TRUE)
  
  acc_max <- max(the.csv$acc_med)
  
  
  #your criteria
  #meets.criteria <- ifelse(sampled.years > 4 & min.samples.per.year >= 4 & min.f1A >=4, TRUE, FALSE) 
  
  #test criteria
  meets.criteria <- ifelse(acc_max >= 2000, TRUE, FALSE)
  
  return(meets.criteria)  
} 

check.files <- sapply(file.list, check.csv) # checks if files meet criteria, as above, assumes that file.list has the whole path, which it will if your working directory is where the files are

files.to.write <- file.list[check.files] # subsets list of files to move

Files_more_than_2000<-as.data.table(files.to.write)

write.csv(Files_more_than_2000, "/scratch/groups/jzeitzer/UKBB/Data/Index/Files_more_than_2000.csv")

