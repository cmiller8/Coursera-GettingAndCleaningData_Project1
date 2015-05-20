#Load libraries
library(data.table)
library(car)
library(dplyr)

#The purpose of this file is to load and label all the data from the Samsung Accelerometer datasets

#First let's get the feature list in order to set that as the column header list
feature <- read.csv("features.txt", header=F, sep=" ")

#Let's get the get the test data
test <- read.table("test/X_test.txt", header=F, col.names=feature$V2, row.names=NULL)
#Get only the mean and std columns and merge that
test <- test[ , grepl("mean" , names( test ) ) | grepl( "std" , names( test ) ) ]
#Remove the meanFreq points
test <- test[ , !grepl("meanFreq" , names( test ) ) ]

#Get the activity and subject data
Activity <- read.table("test/y_test.txt", sep=" ", header=F, col.names="Activity")
test$Activity <- Activity$Activity
Subject <- read.table("test/subject_test.txt", sep=" ", header=F, col.names="Subject")
test$Subject <- Subject$Subject

#Assign a new column that signifies that this is test data
test$Type <- "TEST"

#Let's get the get the train data
train <- read.table("train/X_train.txt", header=F, col.names=feature$V2, row.names=NULL)
#Get only the mean and std columns and merge that
train <- train[ , grepl("mean" , names( train ) ) | grepl( "std" , names( train ) ) ]
train <- train[ , !grepl("meanFreq" , names( train ) ) ]

#Get the activity and subject data
Activity <- read.table("train/y_train.txt", sep=" ", header=F, col.names="Activity")
train$Activity <- Activity$Activity
Subject <- read.table("train/subject_train.txt", sep=" ", header=F, col.names="Subject")
train$Subject <- Subject$Subject

#Assign a new column that signifies that this is test data
train$Type <- "TRAIN"

#Concat the two new lists
total_data <- rbindlist(list(test,train))

#Add a new column which converts Activity into a word
total_data$ActivityWord <- recode(total_data$Activity, "1 = 'WALKING'; 2 = 'WALKING_UPSTAIRS'; 3 = 'WALKING_DOWNSTAIRS'; 4 = 'SITTING'; 5 = 'STANDING'; 6 = 'LAYING'" )

#Output a file
write.table(total_data, file ="total_data.csv")

#Aggregate across the activity and subject and export a file
total_data$ActivityWord <- NULL
total_data$Type <- NULL
Aggr_Mean_Activity <- total_data %.% group_by(Activity) %.% summarise_each(funs(mean))

write.table(Aggr_Mean_Activity, file ="total_csv_average.csv")


