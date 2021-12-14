library("nparACT")
 
all_data <- data.frame()

fullfilename <- Sys.getenv("BASELINE")
data_all <- read.csv(fullfilename)  #gzfile(fullfilename))
data <- subset(data_all, select=c("time", "acc_med"))
filename <- strsplit(fullfilename, split = "/")
filename <- filename[[1]][length(filename[[1]])]
  
if (grepl("ZERODIV", fullfilename)) {
  all_data <- rbind(all_data, cbind(filename = fullfilename, setNames(data.frame(matrix(ncol = 7, nrow = 1)), c("IS", "IV", "RA", "L5", "L5_starttime", "M10", "M10_starttime"))))
} else {
  single_result <- nparACT_base("data", SR = 2/60, plot = F,fulldays = F)
  print(single_result)
  single_result <- cbind(filename = filename, single_result)
  all_data <- rbind(all_data, single_result)
}

outDir <- Sys.getenv("DATAIVIS")
setwd(outDir)
write.csv(all_data, paste(substring(filename,1,17),sep="","-IVIS.csv"))
