Description of data and transformations
=======================================

The [original dataset] contains accelerometer and gyroscope sensor signals from different activities. The details on how the data is obtained, sampled, and filtered is illustrated on the [research website].

The R script `run_analysis.R` has the following methods which transform the dataset in some manner which finally results into tidy data:

* `mergeTestTrain`

    As seen from the dataset, there are 561 feature vectors on which observations are made and divided into test and train data. This function takes in the directory of the dataset i.e. "UCI HAR Dataset" as input and merges the two datasets to return a unified data frame. The following are the datasets to be merged:
   * *train/X_train.txt*: A 7352x561 train dataset containing the 561 feature vectors as columns and 7352 observations for different subjects performing different activities as rows.
   * *test/X_test.txt*: A 2947x561 test dataset similar to the train dataset.

    The result of the merging is a 10299x561 data frame with the first 7352 rows containing the train dataset and the last 2947 rows containing the test dataset.

* `extractMeanStdData`

    This function takes two inputs: directory of the dataset i.e. "UCI HAR Dataset" and the 10299x561 merged data frame obtained from the `mergeTestTrain` function called `merged_data`. It returns a data frame with only those features that contain either **mean** or **standard deviation** of the underlying signal. To extract the required features, it uses the following data:
    * *features.txt*: This is a 561x2 dataset containing the feature number as the first column and the name of the feature as the second. The features containing the mean and standard deviation have a pattern `mean(` and `std(` respectively. These features are of the type: **tBodyAcc-mean()-X**, **tGravityAcc-mean()-X**, **tBodyGyro-mean()-X**, etc.

    The feature numbers obtained from the above file can be directly mapped to the column numbers of the `merged_data` data frame. Using this relation, the function extracts the feature numbers containing the relevant pattern, makes a new data frame from `merged_data` containing those relevant features, and labels the features in that extracted data frame. The result is a 10299x66 data frame where the 66 columns indicate the patterns containing the mean and standard deviation.

* `getLabeledActivities`

    This function takes the directory of the dataset i.e. "UCI HAR Dataset" as input and returns a labeled activity data frame. It uses the following files to generate the result:
    * *activity\_labels.txt*: This is 6x2 dataset containing the activity number as the first column and the activity name as the second. The activity name is a set of 6 activities: WALKING, WALKING\_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
    * *train/y_train.txt*: This is a 7352x1 dataset containing the activity number for 7352 train observations.
    * *test/y_test.txt*: This is a 2947x1 dataset containing the activity number for 2947 test observations.

    The result is a 10299x1 data frame containing the merged result with the first 7352 rows as train and the last 2947 rows as test data. The activity numbers in data frame are mapped to activity names obtained from *activity_labels.txt*. The name of the column is set to "Activity".

* `getAttachedSubjectActivity`

    This function takes two inputs: directory of the dataset i.e. "UCI HAR Dataset" and the 10299x66 extracted data frame obtained from the `extractMeanStdData` function called `extracted_data`. It returns a data frame with by binding the subject data, labeled activity data, and the `extracted_data`. The following files are used for generating this result:
    * *train/subject_train.txt*: A 7352x1 dataset containing 7352 rows of train data having the subject number in the range 1-30 that participated in the experiment.
    * *test/subject_test.txt*: A 2947x1 dataset containing 2947 rows of test data having the subject number in the range 1-30 that participated in the experiment.

    This function merges the subject test and train data to form a 10299x1 data frame containing the first 7352 rows as train and the last 2947 rows as test data. The name of the column is set to "Subject". Finally it combines the subject data frame, the activity labels data frame obtained by calling the `getLabeledActivities`, and the `extracted_data` in that order to return a 10299x68 data frame.
    
* `getMeanPerSubjectActivity`

    This function takes an input as the 10299x68 data frame obtained from the `getAttachedSubjectActivity` function called `combined_data` and returns a data frame containing the mean of each feature per subject per activity. It uses functions `melt`, `ddply`, and `dcast` from the R libraries `reshape2` and `plyr`. The result is a 180x68 data frame containing the subject as first column, activity as second, and the average of each feature vector for that subject and activity. Note that there are 180 rows because there are 30 subjects performing 6 activities.

* `main`

    This function takes two inputs: directory of the dataset which by default is "UCI HAR Dataset" and the path to where the output file should be written which by default is the current working directory. This function uses the functions `mergeTestTrain`, `extractMeanStdData`, `getAttachedSubjectActivity`, and writes the result to `tidy_data.txt` file. The result file contains 181 rows with the first row containing th column names and the other 180 rows containing data for 30 subjects doing 6 activities. The columns are tab separated containing the average of each feature per subject per activity.

[original dataset]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
[research website]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
