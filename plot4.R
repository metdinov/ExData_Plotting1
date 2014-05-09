##
## Exploratory Data Analysis Project 1
## Plot 4
##
## IMPORTANT: Assumes data is placed in the same folder as the script
##

library(sqldf)

# Read in only the data from the dates 2007-02-01 and 2007-02-02
dataFile <- 'household_power_consumption.txt'
sqlQuery <- 'select * from file where Date = "1/2/2007" OR Date = "2/2/2007"'
classes <- rep('character', 9)
householdData = read.csv.sql(dataFile, sql = sqlQuery, sep = ';', colClasses = classes)

# Handle '?' as NAs (read.csv.sql does not accept a na.strings argument)
for (i in 3:ncol(householdData)) {
	householdData[, i] = ifelse(householdData[, i] == '?', NA, as.numeric(householdData[, i]))
}

# Merge Date and Time variables into one, and format it correctly as a POSIXlt object
householdData$dateTime <- paste(householdData$Date, householdData$Time)
householdData$dateTime <- strptime(householdData$dateTime, format = '%d/%m/%Y %H:%M:%S')

# Plot 4 (If the data frame is already loaded in memory, just execute these next lines to create the plot)
png('plot4.png', width = 480, height = 480)
par(mfcol = c(2,2))
plot(householdData$dateTime, householdData$Global_active_power, type = 'l', lwd=1, ylab = 'Global Active Power', xlab = "")
plot(householdData$dateTime, householdData$Sub_metering_1, type = 'l', ylab = 'Energy sub metering', xlab = '')
lines(householdData$dateTime, householdData$Sub_metering_2, type = 'l', col = 'red')
lines(householdData$dateTime, householdData$Sub_metering_3, type = 'l', col = 'blue')
colors <- c("black", "red", "blue")
meters <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legend('topright', meters, lty = 1, bty = 'n', col = colors)
plot(householdData$dateTime, householdData$Voltage, type = 'l', xlab = 'datetime', ylab = 'Voltage')
plot(householdData$dateTime, householdData$Global_reactive_power, type = 'l', xlab = 'datetime', ylab = 'Global_reactive_power')
dev.off()