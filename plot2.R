#Reading, naming and subsetting power consumption data

fileURL<- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
download.file(fileURL, destfile = "./household_power_consumption.zip")
unzip("./household_power_consumption.zip")

data <- read.table("household_power_consumption.txt",skip=1,sep=";")
names(data) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
subdata <- subset(data,data$Date=="1/2/2007" | data$Date =="2/2/2007")

library(dplyr)
library(lubridate)

#Transforming the Date and Time vars from characters into objects of type Date and POSIXlt respectively
subdata <- subdata %>% mutate(Date = as.POSIXct(dmy_hms(as.character(paste(Date, Time)))),
                           Global_active_power = as.numeric(as.character(Global_active_power)))

#create plot
with(subdata, plot(Date,Global_active_power, type="l", xlab = "", ylab = "Global Active Power (kilowatts)"))
