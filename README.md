# GnC-Data
##### This document describes how to use run_analysis.R on the Samsung Data. It includes downloading the dataset, unzip, reading the individual files, combining the test and train data and finally cleaning and filtering to produce a wide form of tidy data.

#######Downloading the data set 

* The code does not assume that the dataset exists in the working directory. So, lines upto line #22 are about downloading and unzipping the required dataset

###### Reading the individual files and combining the test and train data

Lines 23-57 read the differnet files where measurements and variable names exist and also combine the test and train data as follows:

*  Read in the X-test and X-train and use rbind to combine the test and train data for the 561 features vectors for all observations
*  Meaningful variable names for the above is obtained from features.txt and used to rename the variables in all X dataset
*  Similarly read in the Y-test and Y-train and use rbing to combine the activity code of test and train data for corresponding observations in X
*  Join this dataset with Activity labels to get a description of the activity code
*  Now combine the measurement vectors with the corresponding activity code and label by using cbind on all X and Y data
*  The remaining task is to identify which observation corresponds to which subject.
*  This is present in the respective subject- train and subject test data. Combine the test and train using rbind. And then combine this with the larger dataset using cbind

###### Identifying measurements denoting mean and std. deviation Lines 58-74

The assumption for this selection criteria is that the variable name contains either -mean or -std
* Search for variable names that meet the above criteria.
* Filter the dataset to only those columns matching the above criteria along with subject and activity labels 

###### Step 5 of the project - generating independent tidy data set - Lines 75-87

* Melting to group by subject and activity label
* Using cast to compute means of all columns by subject and activity label
* write the output to both a .txt and .csv file
