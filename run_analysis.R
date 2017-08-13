
###Script for Coursera Getting and Cleaning Data Course Project by slgr

#load dplyr
library(dplyr)

#download data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")

#list zip contents and get training and test data including feature and activity lables
ziplist <- unzip("Dataset.zip")
activities <- read.table(ziplist[1], header = FALSE)
features <- read.table(ziplist[2], header = FALSE)
testdatasubj <- read.table(ziplist[14], header = FALSE)
testdata <- read.table(ziplist[15], header = FALSE)
testdatalabels <- read.table(ziplist[16], header = FALSE)
traindatasubj <- read.table(ziplist[26], header = FALSE)
traindata <- read.table(ziplist[27], header = FALSE)
traindatalabels <- read.table(ziplist[28], header = FALSE)

#get variable names from features file
colnames(testdata) <- features$V2
colnames(traindata) <- features$V2

#merge the training and the test sets to create one data set
traindatafull <- cbind(traindata, traindatalabels, traindatasubj)
testdatafull <- cbind(testdata, testdatalabels, testdatasubj)
alldata <- rbind(traindatafull, testdatafull)

#Appropriately labels the data set with descriptive variable names
colnames(alldata)[562] <- "activity"
colnames(alldata)[563] <- "subject"

#Uses descriptive activity names to name the activities in the data set
alldata <- merge(alldata,activities, by.x = "Activity", by.y = "V1")
colnames(alldata)[564] <- "activitytext"

#extract only the measurements on the mean and standard deviation for each measurement
meancols <- grep("mean()",colnames(alldata))
stdcols <- grep("std()",colnames(alldata))
cols <- c(563,564,meancols,stdcols)
reduceddata <- alldata[,cols]

#create a second, independent tidy data set with the average of each variable for each activity and each subject
meanreduceddata <- group_by(reduceddata,subject,activitytext)
finaldata <- summarise_all(meanreduceddata,funs(mean))

#write the final file for submission
write.table(finaldata, file = "finaldata.txt", row.name=FALSE)
