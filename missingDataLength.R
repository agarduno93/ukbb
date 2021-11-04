
library(dplyr)
fullfilename <- Sys.getenv("BASELINE")
data_all <- read.csv(gzfile(fullfilename))
filename <- fullfilename

numbers<-(rle.seq3 = rle(data_all$imputed) )
numbers<-as.data.frame(unclass(numbers))
colnames(numbers)<-c("duration","imputed")
numbers<-subset(numbers, imputed==1)

x<-data_all %>% filter(imputed - lag(imputed) > 0)
x<-subset(x, select=c("time"))
all<-cbind(numbers,x)
colnames(all)<-c("imputed","duration","start_missing_data")

single_result <- cbind(filename = filename, all)
print(single_result)

outDir <- Sys.getenv("DATAMISSING")
setwd(outDir)
write.csv(single_result, paste(substring(filename,1,17),sep="","-MissingData_length.csv"))
