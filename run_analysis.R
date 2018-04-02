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

## Connect all data.
data <- rbind(xtrain, xtest)

## Name the columns.
names(data)<-features[, 1]

## Extract the measurements on the mean and standard deviation for each 
## measurement.  
data <- data[grepl("mean|std", names(data), ignore.case = TRUE)]

## Name the activities in the data set with descriptive activity names.
y <- rbind(ytrain, ytest)
subject <- rbind(subjecttrain, subjecttest)
y <- merge(y, activity, by.x = "V1", by.y = "V1")[2]
data <- cbind(subject, y, data)

## Label the data set with descriptive variable names.
names(data)[1:2] <- c("ID", "Activity")

## Create a second, independent tidy data set with the average of each variable
## for each activity and each subject.
data2 <- data %>% 
        group_by(ID, Activity) %>%
        summarize_all(mean)

