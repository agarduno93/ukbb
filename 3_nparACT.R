rm(list=ls())
library("nparACT")
imputed <- Sys.getenv("DATACSV")

files <- list.files(path=imputed,
                    pattern="*.csv", full.names=TRUE, recursive=FALSE)

all_data <- data.frame()

counter <- 0

for (i in files){
  tryCatch({
  counter <- counter + 1
  print(i)
  fullfilename <- read.csv(i)
  fullfilename<- subset(fullfilename, select=c("time", "acc"))
  filename <- strsplit(i, split = "/")
  filename <- filename[[1]][length(filename[[1]])]
  
  if (grepl("ZERODIV", filename)) {
    all_data <- rbind(all_data, cbind(filename = filename, setNames(data.frame(matrix(ncol = 7, nrow = 1)), c("IS", "IV", "RA", "L5", "L5_starttime", "M10", "M10_starttime"))))
  } else {
    single_result <- nparACT_base("fullfilename", SR = 2/60, plot = F)
    print(single_result)
    single_result <- cbind(filename = filename, single_result)
    all_data <- rbind(all_data, single_result)
  }
  },error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

setwd("/scratch/groups/jzeitzer/UKBB/Data/IVIS")
write.csv(all_data, "IVIS_data_Batch_test.csv")
