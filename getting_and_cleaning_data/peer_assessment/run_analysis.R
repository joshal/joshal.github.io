## The source data is obtained from:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## 1. Merge the training and the test feature sets to create one data set
##
## Input is the data directory path
## output is a data frame containing the merged data
mergeTestTrain <- function(directory) {
    train_feature_path <- file.path(directory, "train", "X_train.txt")
    test_feature_path <- file.path(directory, "test", "X_test.txt")

    rbind(read.table(train_feature_path), read.table(test_feature_path))
}

## 2. Extract only the measurements on the mean and standard deviation for each measurement
##
## Input is the data directory path and the merged data obtained from mergeTestTrain
## output is a data frame containing the extracted data based on the pattern
extractMeanStdData <- function(directory, merged_data) {
    features_path <- file.path(directory, "features.txt")
    features <- read.table(features_path, stringsAsFactors=FALSE)
    colnames(merged_data) <- features[,"V2"]
    
    mean_std_columns <- grep("mean\\(|std\\(", features[,"V2"])
    merged_data[,c(mean_std_columns)]
}

## 3. Label activity data
##
## Input is the data directory path
## output is a data frame containing the merged train and test data for activities as labels
getLabeledActivities <- function(directory){
    activity_labels_path <- file.path(directory, "activity_labels.txt")
    train_activity_path <- file.path(directory, "train", "y_train.txt")
    test_activity_path <- file.path(directory, "test", "y_test.txt")
    
    labeled_activity_data <- rbind(read.table(train_activity_path),
                                   read.table(test_activity_path))
    colnames(labeled_activity_data) <- "Activity"
    
    activity_labels <- read.table(activity_labels_path, stringsAsFactors=FALSE)
    activity_labels_to_name_map <- setNames(activity_labels$V2, activity_labels$V1)
    labeled_activity_data$Activity <- sapply(labeled_activity_data$Activity,
                                             function(x) activity_labels_to_name_map[[as.character(x)]])
    labeled_activity_data
}

## 4. Combine with subject data
##
## Input is the data directory path and the extracted data obtained from extractMeanStdData
## output is a combined data frame containing the columns Subject, Activity, Feature1..Feature66
getAttachedSubjectActivity <- function(directory, extracted_data){
    train_subject_path <- file.path(directory, "train", "subject_train.txt")
    test_subject_path <- file.path(directory, "test", "subject_test.txt")
    
    subject_data <- rbind(read.table(train_subject_path),
                          read.table(test_subject_path))
    colnames(subject_data) <- "Subject"
    
    activity_data <- getLabeledActivities(directory)
    
    cbind(subject_data, activity_data, extracted_data)
    
}

## 5. Create  independent tidy data set with the average of each variable 
## for each activity and each subject. 
##
## Input is the combined_data obtained from getAttachedSubjectActivity
## output is a data frame containing the columns Subject, Activity, Feature1..Feature66
## with values for features containing the average per subject per activity
getMeanPerSubjectActivity <- function(combined_data){
    library(reshape2)
    library(plyr)
    # Create a tall skinny data set with Subject, Activity, variable, value as columns
    melted_data <- melt(combined_data, id.vars=c("Subject","Activity"))
    # Calculate the mean per Subject, Activity, variable from the melted dataset
    ddplyed_data <- ddply(melted_data,
                          .(Subject, Activity, variable),
                          summarize, 
                          mean=mean(value))
    # Covert the data back to short fat data set with Subject, Activity, Feature1, Feature2...
    dcast(ddplyed_data, Subject+Activity~variable, value.var="mean")
}

## Use all the functions to write the resulting data in tidy_data.txt
main <- function(directory="UCI HAR Dataset", where_to_write='.'){
    merged_data <- mergeTestTrain(directory)
    extracted_data <- extractMeanStdData(directory, merged_data)
    labeled_data <- getAttachedSubjectActivity(directory, extracted_data)
    tidy_data <- getMeanPerSubjectActivity(labeled_data)
    tidy_data_path <- file.path(where_to_write, "tidy_data.txt")
    write.table(tidy_data, file=tidy_data_path, sep="\t", row.names=FALSE)
}

## Run the main function when the file is sourced
main()