#Reading, naming and subsetting power consumption data

fileURL<- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
download.file(fileURL, destfile = "./household_power_consumption.zip")
unzip("./household_power_consumption.zip")

data <- read.table("household_power_consumption.txt",skip=1,sep=";")
names(data) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
subdata <- subset(data,data$Date=="1/2/2007" | data$Date =="2/2/2007")

library(dplyr)
library(lubridate)

#Transforming the Date and Time vars from characters into objects of type Date and POSIXlt respectively and casting data to numeric classes
subdata <- subdata %>% mutate(Date = as.POSIXct(dmy_hms(as.character(paste(Date, Time)))),
                              Global_active_power = as.numeric(as.character(Global_active_power)),
                              Global_reactive_power = as.numeric(as.character(Global_reactive_power)),
                              Voltage = as.numeric(as.character(Voltage)),
                              Sub_metering_1 = as.numeric(as.character(Sub_metering_1)),
                              Sub_metering_2 = as.numeric(as.character(Sub_metering_2)),
                              Sub_metering_3 = as.numeric(as.character(Sub_metering_3))) 

# initiating a composite plot with many graphs
par(mfrow=c(2,2))

# calling the basic plot function that calls different plot functions to build the 4 plots that form the graph
with(subdata,{
        plot(subdata$Date,subdata$Global_active_power,type="l",  xlab="",ylab="Global Active Power")  
        plot(subdata$Date,subdata$Voltage, type="l",xlab="datetime",ylab="Voltage")
        plot(subdata$Date,subdata$Sub_metering_1,type="n",xlab="",ylab="Energy sub metering")
        with(subdata,lines(Date,as.numeric(as.character(Sub_metering_1))))
        with(subdata,lines(Date,as.numeric(as.character(Sub_metering_2)),col="red"))
        with(subdata,lines(Date,as.numeric(as.character(Sub_metering_3)),col="blue"))
        legend("topright", lty=1, col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), cex = 0.6)
        plot(subdata$Date,as.numeric(as.character(subdata$Global_reactive_power)),type="l",xlab="datetime",ylab="Global_reactive_power")
})

dev.copy(png, file ="plot4.png", width=480, height=480)
dev.off()
