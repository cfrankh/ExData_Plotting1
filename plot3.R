# Create "data" subdirectort of current working directory
if (!file.exists("data")) {
    dir.create("data")
}

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
#install.packages("lubridate")
library(lubridate)
power <- mutate( power, Date = as.Date(Date, format= "%d/%m/%Y") )
power <- mutate( power, Time = hms(Time) )
power <- mutate( power, DateTime = Date + Time )

# Plot the graph
plot(power$DateTime, power$Sub_metering_1, 
     type = "l", 
     xlab="", 
     ylab = "Energy sub metering")

lines(power$DateTime, power$Sub_metering_2, 
      type = "l", col='red')

lines(power$DateTime, power$Sub_metering_3, 
      type = "l", col='blue')

# Copy to PNG file
dev.copy(png, filename = "plot3.png",
         units = "px",
         width = 480, 
         height = 480, 
         bg = "white")

# Close the PNG devices
dev.off()
dev.off()
dev.cur()