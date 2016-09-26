#Coursera - Getting and Cleaning Data - Final Project

#The purpose of this project is to demonstrate an ability to collect, 
#work with, and clean a data set. The goal is to prepare tidy data that 
#can be used for later analysis. 

#The data was obtained from the following URL:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#this R script assumes the data from the above URL has been unzipped and all
#files have been placed into the working directory.

#load the dplyr package
library(dplyr)

#The first order of business is to load the data into R from the txt files.
xtraindata <- read.table("./X_train.txt",header=FALSE,quote="")
ytraindata <- read.table("./Y_train.txt",header=FALSE,quote="")
subjecttrain <- read.table("./subject_train.txt",header=FALSE,quote="")
xtestdata <- read.table("./X_test.txt",header=FALSE,quote="")
ytestdata <- read.table("./Y_test.txt",header=FALSE,quote="")
subjecttest <- read.table("./subject_test.txt",header=FALSE,quote="")

#Then, load in the 561 variable names from the features.txt source file 
featurenames <- read.table("./features.txt",header=FALSE,quote="")

#Using featurenames, rename the column names in xtestdata and xtraindata
#Note: we can do this because there are equal number of col names as variables.
colnames(xtestdata) <- featurenames$V2
colnames(xtraindata) <- featurenames$V2

#rename subjecttest and subjecttrain with column name SubjectID
colnames(subjecttest) <- c("SubjectID")
colnames(subjecttrain) <-c("SubjectID")

#Then, add a descriptive name to ytestdata and ytraindata. 
#The data in these datasets represent activity IDs
colnames(ytestdata) <- c("ActivityID")
colnames(ytraindata) <- c("ActivityID")

#Now, we can begin merging the testing and training sets.

#First, cbind the test and train ActivityIDs to the xtestdata and xtraindata datasets
activityandxtestdata <- cbind(ytestdata,xtestdata)
activityandxtraindata <- cbind(ytraindata,xtraindata)

#Second, cbind the test and train Subject IDs to the activityandxtestdata 
# and activityandxtraindata datasets. The result is a dataset with the 
#SubjectID, ActivityID, and associated values for each of the 562 variables.
joinedtestdata <- cbind(subjecttest,activityandxtestdata)
joinedtraindata <- cbind(subjecttrain,activityandxtraindata)

#rbind the merged train and merged test datasets to create one dataset that 
#contains all data for all subjects.
merged <- rbind(joinedtestdata,joinedtraindata)

#The instructions for the final project tell us we only want the mean and 
#standard deviation for each measurement.  

#extract all column names containing "mean" and place into new dataset
extractmean <- merged[,grepl("mean",names(merged))]

#some of the column names have "meanFreq" which is not what we want, so extract those
extractonlymean <- extractmean[,!grepl("Freq",names(extractmean))]

#extract all column names from merged that contain std
extractstd <- merged[,grepl("std()",names(merged))]

#cbind extractonlymean and extractstd to get all the data columns we want
meanstddata <- cbind(extractonlymean,extractstd)

#need to add back on SubjectID and ActivityID columns
meanstddata2 <- cbind(merged[,1:2],meanstddata)

#I now have a dataset with SubjectID, ActivityID and only data for the columns
#that measured std() or mean().

labeleddata <- meanstddata2 #creates a backup to use, so not to destroy prior work

labeleddata$ActivityID <- factor(labeleddata$ActivityID, levels=1:6, 
     labels=c("Walking","Walk_Upstairs", "Walk_Downstairs","Sitting","Standing","Laying"))

#melt the data to get the value of each variable in a long and narrow form
melted <- melt(labeleddata,id=c("SubjectID","ActivityID"))

#use dcast to get the average of each variable for each subject and activity
reshaped <- dcast(melted,SubjectID + ActivityID ~ variable, mean)

#now that we have our data the way we want it - tidy - need to export to a txt
write.table(reshaped,file="FinalProjDataOut.txt",sep="\t")






