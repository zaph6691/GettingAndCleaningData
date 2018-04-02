# GettingandCleaningData

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.You will be required to submit:
>
1. a tidy data set as described below
2. a link to a Github repository with your script for performing the analysis
3. codeBook.md that describes the variables, the data, and any work that you performed to clean up the data 
4. README.md that explains how all of the scripts work and how they are connected.  
>
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
> 
> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

> Here are the data for the project: 

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
> 
> You should create one R script called run_analysis.R that does the following. 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set.
> 4. Appropriately labels the data set with descriptive activity names.
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
> 
> Good luck!

# Code explanations

First the data was loaded into dataframes, because the columns have no names "header" was set to FALSE.
```R
library(dplyr)

## Load the data into variables.
activity <- read.table("activity_labels.txt", header = FALSE)
features <- read.table("features.txt", header = FALSE)[2]
subjecttrain <- read.table("./train/subject_train.txt", header = FALSE)
xtrain <- read.table("./train/X_train.txt",  header = FALSE)
ytrain <- read.table("train/y_train.txt", header = FALSE)
subjecttest <- read.table("./test/subject_test.txt", header = FALSE)
xtest <- read.table("./test/X_test.txt", header = FALSE)
ytest <- read.table("./test/y_test.txt", header = FALSE)
```
Then the test set and training set were attached.
```R
## Connect all data.
data <- rbind(xtrain, xtest)
```

Then descriptive names were added to the columnes of the dataset.
```R
## Name the columns.
names(data)<-features[, 1]
```
Then all the relevant cases (average and standard deviation) were extracted.
```R
## Extract the measurements on the mean and standard deviation for each 
## measurement.  
data <- data[grepl("mean|std", names(data), ignore.case = TRUE)]
```
Then descriptive names were given to the activities and they were attached to
the dataset.
```R
## Name the activities in the data set with descriptive activity names.
y <- rbind(ytrain, ytest)
subject <- rbind(subjecttrain, subjecttest)
y <- merge(y, activity, by.x = "V1", by.y = "V1")[2]
data <- cbind(subject, y, data)
```
Then the additional columns were named descriptivly.
```R
## Label the data set with descriptive variable names.
names(data)[1:2] <- c("ID", "Activity")
```

Last a new dataset was created that keeps the average values for each test
candidate and each activity.
```R
## Create a second, independent tidy data set with the average of each variable
## for each activity and each subject.
data2 <- data %>% 
        group_by(ID, Activity) %>%
        summarize_all(mean)
```