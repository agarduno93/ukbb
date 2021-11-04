fullfilename <- Sys.getenv("BASELINE")
data_all <- read.csv(gzfile(fullfilename))
#data <- subset(data_all, select=c("time", "acc"))
filename <- fullfilename
#filename <- strsplit(fullfilename, split = "/")
#filename <- filename[[1]][length(filename[[1]])]
  
single_result <-rbind((sum(as.numeric(data_all$imputed)))/2)
single_result <- cbind(filename = filename, single_result)
colnames(single_result)<-c("filename", "missingData_min")
print(single_result)

outDir <- Sys.getenv("DATAMISSING")
setwd(outDir)
write.csv(single_result, paste(substring(filename,1,17),sep="","-MissingData_min.csv"))

