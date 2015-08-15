setwd("E:/Coursera/5-Reproducible Research/Week 2/RepData_PeerAssessment1")
raw <- read.csv("activity.csv")
str(raw)
library(lubridate) 
raw$date <- ymd(raw$date)

library(reshape2)
melted <- melt(raw, id.vars = "date", measure.vars = "steps")
decasted <- dcast(melted, date ~ variable, sum, na.rm = TRUE)
hist(decasted$steps, breaks = 10)
median(decasted$steps)
mean(decasted$steps)


melted2 <- melt(raw, id.vars = "interval", measure.vars = "steps")
decasted2 <- dcast(melted2, interval ~ variable, mean , na.rm = TRUE)
plot(x = decasted2$interval, y = decasted2$steps, type = "l",
     ylab = "Average Steps per Interval", xlab = "Interval ID")

unique(raw$interval)[max(decasted2$steps)]

sum(is.na(raw$steps))

nas <- which(is.na(raw$steps))
naInterval <- raw[nas,3]
values <- sapply(naInterval, function(x) decasted2[decasted2$interval == x, 2])
rawfilled <- raw
rawfilled[which(is.na(rawfilled$steps)),1] <- values

meltedfilled <- melt(rawfilled, id.vars = "date", measure.vars = "steps")
decastedfilled <- dcast(meltedfilled, date ~ variable, sum)
hist(decastedfilled$steps, breaks = 10, main = "Histogram of Average Steps per Day", xlab = "Average Steps per Day")
median(decastedfilled$steps)
mean(decastedfilled$steps)

rawfilled$day <- weekdays(rawfilled$date)
dayname <- c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
status <- c (rep("weekday", 5),rep("weekend", 2))
daygroup <- data.frame(dayname, status)
rawfilled$status <- sapply(rawfilled$day, function(x) daygroup[daygroup$dayname == x, 2])
dataMelt <- melt(rawfilled, id.vars = c("status", "interval") ,measure.vars = "steps")
FinalDT <- dcast(dataMelt, status + interval ~ variable , mean)
library(ggplot2)
qplot(x = FinalDT$interval, y = FinalDT$steps, data = FinalDT ,facets = status~. ,geom = "line")


