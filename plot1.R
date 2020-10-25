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

# Create the histogram as specified
hist(power$Global_active_power,
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency",
     main = "Global Active Power",
     col = "red")

# Copy the plot to a PNG file
dev.copy(png, filename = "plot1.png",
         units = "px",
         width = 480, 
         height = 480)

# Close the PNG devices
dev.off()
dev.off()
dev.cur()
