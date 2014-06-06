
# R code file that constructs the PLOT 1 for the Projet 1. The Code File include
# the code for reading the data so that the plot can be fully reproduced. It 
# also creates the PNG file.

filename = "household_power_consumption.txt"

# check if the data is in the current working directory. If not, download and unzip file.
if(!file.exists(filename)){
        cat("Download and unzip data file for Project 1 in current working directory:\n", 
            getwd(), "\n please wait ...\n")
        temp <- tempfile()
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, temp)
        unzip(temp)
        unlink(temp)
        dateDownloaded <- date()
        cat("download and unzipping done.\n")
}

# check if sqldf package is installed and load the package
if (!"sqldf" %in% installed.packages()) install.packages("sqldf")
library(sqldf)

# load the file with read.csv.sql() and read only rows in 1/2/2007 and 2/2/2007
# no NA values available in this subset, so no need to deal with :)
dataf <- read.csv.sql(filename, 
        sql = "select * from file where Date in ('1/2/2007', '2/2/2007')",
        header = TRUE, sep = ";")
closeAllConnections()

# add a new column datetime with the combined Data and Time column
dataf$datetime <- paste(dataf$Date, dataf$Time)
dataf$datetime <- strptime(dataf$datetime, "%d/%m/%Y %H:%M:%S")
dataf$datetime <- as.Date(dataf$datetime)

# get and save aspects of the LOCALE for the R process for my case i am in
# AUSTRIA and use the locale "German_Austria.1252", so the x axes labels are 
# "Do" instead of "Thu" ("Donnerstag" instead of "Thursday")  / "Fr" for "Fri" /
# "Sa" for "Sat"
mylocation <- Sys.getlocale("LC_TIME")

# set Time Location to C locale (which is the default for the C language and
# reflects North-American usage) so it is in North-American Englisch and from
# now on it appears Thu/Fri/Sat
Sys.setlocale("LC_TIME", "C")              

# Open PNG device; create 'plot1.png' in my working directory
png(file = "plot1.png", width = 480, height = 480)

# ready for PLOT 1
par(mfrow = c(1,1))
hist(dataf$Global_active_power,xlab = "Global Active Power (kilowatts)", 
     col = "red", main = "Global Active Power")

# Close the PNG file device and write file
dev.off()

# switch back to the origianl LOCALE for date/time processing
Sys.setlocale("LC_TIME", mylocation)


