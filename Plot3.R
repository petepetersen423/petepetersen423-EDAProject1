library(data.table)
library(tidyr)
library(readr)
library(dplyr)
library(lubridate)

if(!file.exists("./data")){dir.create("./data")}
fileurl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
download.file(fileurl,destfile ="./data/PowerConsumption.zip", method='curl' )
unzip("./data/PowerConsumption.zip",exdir="./data") 

dfpower <- read.table("./data/household_power_consumption.txt"
                      ,stringsAsFactors = FALSE
                      ,header=TRUE
                      ,sep=";")
dfpower$Date <- dmy(dfpower$Date)
dfpower$Time <- hms(dfpower$Time)
dfcolNames <-dfpower %>% 
  select_if(is.character) %>% colnames()

dfpower[,dfcolNames] = lapply(dfpower[,dfcolNames,], as.numeric)

nas <-complete.cases(dfpower)
dfpower <- dfpower[nas==TRUE,]
dfpowerDateNeeded <- dfpower[between(dfpower$Date, 
                                     ymd("2007-02-01"),
                                     ymd("2007-02-02" ))
                             == TRUE ,]
png("plot3.png", width=480, height=480)
plot(dfpowerDateNeeded$Date + dfpowerDateNeeded$Time,dfpowerDateNeeded$Sub_metering_1, 
     col = "black", 
     ylab = "Energy Sub Metering",
     xlab = "Days",
     main = "Sub Metering",
     type = "l")
lines(dfpowerDateNeeded$Date + dfpowerDateNeeded$Time,dfpowerDateNeeded$Sub_metering_2, 
     col = "red", 
     type = "l")
lines(dfpowerDateNeeded$Date + dfpowerDateNeeded$Time,dfpowerDateNeeded$Sub_metering_3, 
      col = "blue", 
      type = "l")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black","red", "blue"), lty=1, cex=0.8)
dev.off()
#add comment