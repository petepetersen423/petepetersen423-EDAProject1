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
png("plot1.png", width=480, height=480)
hist(dfpowerDateNeeded$Global_active_power, 
     col = "red", 
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")
dev.off()
