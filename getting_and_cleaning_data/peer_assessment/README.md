Peer Assessment Quiz
====================

## Overview

The purpose of this quiz is to get hands-on training for reading, merging, and cleaning a real dataset obtained from a [research] involving human activity recognition for subjects performing different activities.

The contents here are as follows:
* `run_analysis.R`

    This is the R script used to transform the data obtained from source dataset that is divided into several files containing test, train, activity, subjects, features etc. into a unified file containing a subset of features.

* `CodeBook.md`

    This file contains the overview of the variables, dataset, and the transformations used to run analysis on the source data.


## Running the analysis

1. Download and unzip the [dataset] and place it in your local directory e.g. */home/\<user_name\>/coursera/*
2. Place the `run_analysis.R` script in the same directory i.e. */home/\<user_name\>/coursera/*
3. In R studio do the following:
    * Set the working directory to where the script is located: `setwd("/home/<user_name>/coursera/")`
    * Source the script in your workspace: `source("run_analysis.R")`
4. The result is a file `tidy_data.txt` in the local directory  */home/\<user_name\>/coursera/* which contains the average of the required features per subject and activity which is guidelined in `CodeBook.md`

[research]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
[dataset]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
