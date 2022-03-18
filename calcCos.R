#install.packages("dplyr")
#install.packages("lubridate")
#install.packages("padr")
#install.packages("ActCR")
#install.packages("cosinor")
#install.packages("cosinor2")
#install.packages("minpack.lm")

library("dplyr")
library("lubridate")
library("padr")
library("ActCR")
library("cosinor")
library("cosinor2")

fullfilename <- Sys.getenv("BASELINE")
filename <- strsplit(fullfilename, split = "/")
filename <- filename[[1]][length(filename[[1]])]

data_all<- data.frame(read.csv(fullfilename)) #read time and data columns
AXData <- subset(data_all, select=c("time", "acc_med"))
colnames(AXData) <- c("time", "data") #rename columns for clarity
AXData$time <- ymd_hms(AXData$time, tz = "GMT") #reformat time

#trimming .csv to only complete days
dayfilter <- ceiling_date(AXData$time[1], "day")
dayfilter2 <- floor_date(AXData$time[nrow(AXData)], "day")
AXData <- AXData %>% filter(time >= dayfilter & time < dayfilter2)


#create data frame to fill in with metrics
outputData <- as.data.frame(matrix(nrow=1,ncol=9))
colnames(outputData) <- c("Filename", "Amplitude", "Mesor", "Acrophase", "F_stat", #filename and cosinor variables (4)
                           "Amplitude_ext", "Mesor_ext", "Acrophase_ext", "F_pseudo") #ActCR variables (4)

outputData$Filename <- filename

##cosine fit
AXData$count <- 1:nrow(AXData)
fit <- cosinor.lm(data ~ time(count), data = AXData, period = 2880) #set period if using different sample rate
fittable <- summary(fit)[1]$transformed.table
outputData$Amplitude[1] <- fittable[2,1] #amplitude
outputData$Mesor[1] <- fittable[1,1] #intercept is mean activity (mesor)
outputData$Acrophase[1] <- ((fittable[3,1]/2)/pi)*24+12 #acrophase
outputData$F_stat[1] <- as.numeric(cosinor.detect(fit)[1,1]) #fstat

###ActCR
#downsample data to 1 minute (ActCR requires 1440 samples x days)
AXData2 <- AXData %>%
  thicken('min') %>%
  group_by(time_min) %>%
  summarise(min_data = mean(data), .groups = 'drop')
colnames(AXData2) <- c("time", "data")

#extended cosinor
extendactfit <- ActExtendCosinor(
  AXData2$data,
  window = 1,
  lower = c(0, 0, -1, 0, -3),
  upper = c(Inf, Inf, 1, Inf, 27))

outputData$Amplitude_ext <- extendactfit$amp
outputData$Mesor_ext <- extendactfit$MESOR
outputData$Acrophase_ext <- extendactfit$acrotime
outputData$F_pseudo <- extendactfit$F_pseudo

outDir <- Sys.getenv("DATACOS")
setwd(outDir)
write.csv(outputData, paste(substring(filename,1,17),sep="","-Cosinor.csv"))
