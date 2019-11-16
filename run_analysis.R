## Getting and Cleaning Data Course Project

# Libraries ----
library(tidyverse)

# Download data ----
file_name <- "UCI HAR Dataset.zip"

if (!file.exists(file_name)) {
  file_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(file_URL, file_name, method = "curl")
}

if (!file.exists("UCI HAR Dataset")) {
  unzip(file_name)
}

# Import data ----

# Training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)

# Test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)

# Labels
feature_labels <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

# Merge data ----
# Subject
subject <- rbind(subject_train, subject_test)
colnames(subject) <- "Subject"

# Activity
activity <- rbind(y_train, y_test)
colnames(activity) <- "Activity"

# Features
features <- rbind(x_train, x_test)
colnames(features) <- feature_labels$V2

# Combine Subject, Activity, and Features
data <- cbind(subject, activity, features)

# Extract Mean & STD measures ----
required_cols <- grep(".*Mean.*|.*Std.*", colnames(data), ignore.case = TRUE)
extracted_data <- data[,c(1:2, required_cols)]

# Descriptive Activity names ----
extracted_data <- extracted_data %>%
  left_join(activity_labels, by = c("Activity" = "V1")) %>%
  rename(ActivityName = V2) %>%
  select(Subject, Activity, ActivityName, everything(), -Activity)

# Clean variable names ----
colnames(extracted_data) <- gsub("Acc", "Accelerometer", colnames(extracted_data))
colnames(extracted_data) <- gsub("Gyro", "Gyroscope", colnames(extracted_data))
colnames(extracted_data) <- gsub("BodyBody", "Body", colnames(extracted_data))
colnames(extracted_data) <- gsub("Mag", "Magnitude", colnames(extracted_data))
colnames(extracted_data) <- gsub("^t", "Time", colnames(extracted_data))
colnames(extracted_data) <- gsub("^f", "Frequency", colnames(extracted_data))
colnames(extracted_data) <- gsub("tBody", "TimeBody", colnames(extracted_data))
colnames(extracted_data) <- gsub("-mean()", "Mean", colnames(extracted_data), ignore.case = TRUE)
colnames(extracted_data) <- gsub("-std()", "STD", colnames(extracted_data), ignore.case = TRUE)
colnames(extracted_data) <- gsub("-freq()", "Frequency", colnames(extracted_data), ignore.case = TRUE)
colnames(extracted_data) <- gsub("angle", "Angle", colnames(extracted_data))
colnames(extracted_data) <- gsub("gravity", "Gravity", colnames(extracted_data))

# Subset with averages ----
# Take the average of each variable for each activity for each subject
tidy_data <- aggregate(. ~ Subject + ActivityName, extracted_data, mean)
  
# Output data ----
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
