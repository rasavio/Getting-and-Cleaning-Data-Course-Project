# Code Book

This document describes the transformations conducted by *run_analysis.R* in order to produce the *tidy_data.csv* file.

## Data Set
The *Human Activity Recognition Using Smartphones Data Set* is built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment. 

Source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones!
Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip!


## Input Data
The following files from the *UCI HAR Dataset.zip* are used as inputs to the R Script:

* `features.txt` contains the name of the features in the data sets.
* `activity_labels.txt` contains metadata on the different types of activities.
* `subject_train.txt` contains information on the subjects from whom data is collected.
* `subject_test.txt` contains information on the subjects from whom data is collected.
* `X_train.txt` contains variable features that are intended for training.
* `X_test.txt` contains variable features that are intended for testing.
* `Y_train.txt` contains the activities corresponding to X_train.txt.
* `Y_test.txt` contains the activities corresponding to X_test.txt.

## Transformation Steps
### Import Data
The required input files are into the environment as follows:

**Training data**

* `subject_train.txt` read as `subject_train`.
* `X_train.txt` read as `x_train`.
* `Y_train.txt` read as `y_train`.

**Test data**

* `subject_test.txt` read as `subject_test`
* `X_test.txt` read as `x_test`
* `Y_text.txt` read as `y_test`

**Labels**

* `features.txt` read as `feature_labels`
* `activity_labels.txt` read as `activity_labels`

### Merge data
* The subjects in `subject_train` and `subject_test` are merged to create `subject`, with the column name of "Subject".
* The activities in `y_train` and `y_test` are merged to create `activity`, with the column name of "Activity".
* The features in `x_train` and `y_test` are merged to created `features`, with column names taken from `feature_labels`.
* `subject`, `activity`, and `features` are merged to created `data`.

### Extract Mean & STD Measures
* Columns relating to Mean or Standard Deviation measures are identified using regular expressions.
* A subset of `data`, called `extracted_data` is created by selecting only the `Subject`, `Activity`, and above identified Mean and Standard Deviation measures.

### Create descriptive activity names
The values in the `Activity` column, which are IDs, are replaced with the corresponding descriptive text labels from `activity_labels`.

### Clean variable names
The field names contain acronyms, such as `Acc` or `Gyro`, are updated to use the complete word though the use of text substitution. 

### Aggregate Tidy Data set
A second, independent tidy data set with the average of each variable for each activity and each subject is create from the `extracted_data` table as `tidy_data`.

## Output Tidy Data
The final data set, `tidy_data`, is exported as txt file.