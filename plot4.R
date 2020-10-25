# Download the zip file
zipURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "./data/PeerGradedAssignment1.zip"
download.file(zipURL, destfile = zipFile, method = "curl")

# Load data into a data frame called "power"
fileDetails <- unzip(zipFile, list=TRUE)
power <- read.table( unz(zipFile, fileDetails[1,1]), 
                     header=TRUE, sep=";", na.strings=c("N/A","?"))

# Make the Dates column into R Date type
library(dplyr)
power <- mutate( power, Date = as.Date(Date, format= "%d/%m/%Y") )

# Filer for dates
power <- subset(power, Date >= as.Date('2007-02-01 ',format='%Y-%m-%d'))
power <- subset(power, Date <= as.Date('2007-02-02 ',format='%Y-%m-%d'))

# Make a DateTime column in the data frame
install.packages("lubridate")
library(lubridate)
power <- mutate( power, Date = as.Date(Date, format= "%d/%m/%Y") )
power <- mutate( power, Time = hms(Time) )
power <- mutate( power, DateTime = Date + Time )

# Plot the graph
# FIRST MAKE FRAME WITH 2 ROWS AND TWO COLUMNS
# mfcol MEANS FILL COLUMN BY COLUMN
par(mfcol = c(2, 2))

# TOP LEFT
plot(power$DateTime, power$Global_active_power, 
     type = "l", 
     xlab="", 
     ylab = "Global Active Power (kilowatts)") 

# BOTTOM LEFT
plot(power$DateTime, power$Sub_metering_1, 
     type = "l", 
     xlab="", 
     ylab = "Energy sub metering")

lines(power$DateTime, power$Sub_metering_2, 
      type = "l", col='red')

lines(power$DateTime, power$Sub_metering_3, 
      type = "l", col='blue')

# TOP RIGHT
plot(power$DateTime, power$Voltage, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Voltage")

# BOTTOM RIGHT
plot(power$DateTime, power$Global_reactive_power, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Global_reactive_power")

# Copy to PNG file
dev.copy(png, filename = "plot4.png",
         units = "px",
         width = 480, 
         height = 480, 
         bg = "white")

# Close the PNG devices
dev.off()
dev.off()
dev.cur()