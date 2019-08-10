library(dplyr)

if(file.exists("household_power_consumption.txt")){
        data0 <- read.table("household_power_consumption.txt", sep=";", 
                            na.strings = "?", stringsAsFactors = FALSE, header = TRUE) 
}else if(file.exists("exdata-data-household_power_consumption.zip")){
        data0 <- read.table(unzip("exdata-data-household_power_consumption.zip"), sep=";", 
                            na.strings = "?", stringsAsFactors = FALSE, header = TRUE)
}else{
        tmp <- tempfile()
        url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
        download.file(url, tmp)
        data0 <- read.table(unzip(tmp), sep=";", 
                            na.strings = "?", stringsAsFactors = FALSE, header=TRUE)
        unlink(tmp)
}
DowloadDate <- Sys.Date()

data0 <- tbl_df(data0)
data <- filter(data0, Date=="2/2/2007"|Date=="1/2/2007")
data <- mutate(data, Date_Time=paste(Date, Time, sep=" "))
data$Date_Time <- strptime(data$Date_Time, format = "%d/%m/%Y %H:%M:%S")
data[, 3:9] <- lapply(data[,3:9], as.numeric)

with(data, plot(Date_Time, Global_active_power, type="l"))

dev.copy(png, file="plot2.png")
dev.off()
