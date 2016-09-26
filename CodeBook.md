---
title: "Code Book"
author: "James Matthews"
date: "September 25, 2016"
output: html_document
---

##Coursera - Getting and Cleaning Data - Final Project

###This CodeBook.md file explains the actions performed on the datasets that resulted in a tidy dataset that shows the average values for the variables specified in the Final Project instructions.

##Helping the Reviewer
###Load the data using the following command:
###data <- read.table("./FinalProjDataOut.txt",header=TRUE,quote="")

This is an R Markdown document as part of the Final Project for Coursera's Getting and Cleaning Data course.  

The data for this project was obtained from the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

###To replicate this analysis described within this Code Book, the associated R script, Run_Analysis.R, assumes all files from that .zip file have been downloaded and stored into the working directory. That is, there are no files within subfolders of the working directory. 

As stated in the instructions for this final project, the purpose of this project is to demonstrate an ability to collect, work with and clean a data set. The goal is to prepare tidy data that can be used for analysis. 

####The file Run_Analysis.R performs the following tasks:

*Merges the training and the test sets to create one data set.

*Extract only the measurements on the mean and standard deviation for each measurement.

*Use descriptive activity names to name the activities in the data set.

*Appropriately label the data set with descriptive variable names.

*From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

To merge the training and test sets, we need to identify the files used for the training and test sets. We do not need all files from the zip file. The data files we will be using are:
subject_test.txt
X_test.txt
y_test.txt
subject_train.txt
X_train.txt
y_train.txt

The README.txt extracted from the zip file provides an explanation for each of those files. 

'subject_test.txt' and 'subject_train.txt' contain the integer identifiers for the subjects who performed the activities. The test file shows the subjects who were chosen for the testing set, while the train file shows the subjects who were chosen for the training set. Subjects are identified by number from 1 to 30. Each row identifies the integer identity of the subject. 

'X_test.txt' and 'X_train.txt' are the training dataset and the testing dataset showing output for the 561 features, with each feature value being separated by a space, and each set of 561 values separated by a return. Each of the 561 features are shown in the 'features.txt' file that came from the source zip file. 

'y_test.txt' and 'y_train.txt' contain the integer labels that correspond to the type of activity performed. From the activity_labels.txt file from the source zip file, the integer labels correspond to one each of the following activities:

1 = WALKING

2 = WALKING_UPSTAIRS

3 = WALKING_DOWNSTAIRS

4 = SITTING

5 = STANDING

6 = LAYING


The next step was to load the data from the txt files into R. Then, load the feature names into R to be able to add descriptive variable names. The feature names come from the file 'features.txt' that was in the source zip file. The second variable in 'features.txt' contains the name.

The data was loaded into the following R objects named:
featurenames
subjecttest
subjecttrain
xtestdata
xtraindata
ytestdata
ytraindata

The next step was to add a descriptive name to subjecttest and subjecttrain. Because these are the number identifier of each subject, I named the column SubjectID.

Then, add a descriptive name to ytestdata and ytraindata. Because the data in these datasets represent activity IDs, I named the column ActivityID.

With the names of the columns created, it was time to begin merging the SubjectIDs and ActivityIDs with the test and train X datasets that contain the values for the 561 variables. After these cbind operations, I had a merged training set and a merged testing set, each with SubjectID, ActivityID, and values for all 561 variables. 

I then used rbind to add the joined test data to the joined train data to have a single dataset with all SubjectIDs from test and train datasets. 

This completes the first task of the final project. The second task is to extract the mean and standard deviation of each measurement. To do this, I needed to find the names of the columns in the merged dataset that contained "mean()" and "std()". 

Note, there are factors that start with "angle(" and contain the name "Mean". According to the features_info.txt file, these measure the angle between specific factors and the mean of other factors. As the instructions for the final project say to extract the mean and standard deviation for each measurement, and these angle() factors are a calculation on the measurements, I did not include the "angle()" factors.

To extract just the "mean()" I had to first search for and extract the "mean" string using grepl. This also gave me columns with "meanFreq", so I needed to perform a second grepl to find the "Freq" string and extract from its negation.

Once the std() and mean() fields were extracted, I used cbind to join the datasets. But, I lost the ActivityID and SubjectID, so I needed to add those back onto my meanstddata dataset by using cbind on the first two columns of my merged data.

Next, I labeled the ActivityID from an integer to a descriptive value using factor(). This completed the fourth task in the final project instructions.

The final task for the final project was to create an independent, tidy dataset showing the average of each variable for each activity and each subject. Because the reshaped dataset created to this point has more than one row for each subject and activity, it is not tidy. To get it tidy, I first used melt to shape the labeleddata dataset into a long and narrow dataset, and then I appled dcast on it to create a reshaped dataset that provided one row for each Subject-Activity pair that shows the average value for each of the mean() and std() columns from labeleddata dataset.

The last step was to write the data back out to a new txt file that I called FinalProjDataOut.txt

