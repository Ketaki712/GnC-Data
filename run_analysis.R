##Feb 13,2014
## Project 1  - Getting & Cleaning Data 

#Adding required libraries
require(httr)
require(reshape)
require(ggplot2)
require(plyr)
# get the file url
dataurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# create a temporary directory
td = tempdir()
# create the placeholder file
tf = tempfile(tmpdir=td, fileext=".zip")
# download into the placeholder file
download.file(dataurl, tf)
# get the name of the first file in the zip archive
fname = unzip(tf, list=TRUE)$Name
# unzip the file to the temporary directory
unzip(tf, files=fname, exdir=td, overwrite=TRUE)
# fpath is the full path to the extracted file
fpath = file.path(td, fname)
#using read.table function to read all the files 
#use fpath to enlist all the files and choose which ones to read.
activity.labels<- read.table(fpath[1])
features <- read.table(fpath[2])
## the second column of features contains the desired variable names ie measurement of all 561 features for test and train data
feature.labels <- features$V2
## Reading in the test data
X_test <- read.table(fpath[17]) ##contains the measurement of 561 features 
Y_test <- read.table(fpath[18]) ## contains activity code for the number of observations of test data
## Reading in the train data
X_train <- read.table(fpath[31])##contains the measurement of 561 features 
Y_train <- read.table(fpath[32])## contains activity code for the number of observations of train data
##Combining the measurement data from test and train datasets
all_x_data <- rbind(X_test,X_train)
## Using the variable names from features.text to label the columns with meaningful names
names(all_x_data) <- feature.labels
## Combining the activity codes from test and train for all observations
all_y_data <- rbind(Y_test,Y_train)
## Labeling the column as 'activity.code'
names(all_y_data) <- "activity.code"
##Labeling the columns of activity.labels that maps the various activity codes to descriptive activity names
names(activity.labels) <- c("activity.code","activity.label")
## Adding the activity code column to all observations by combining 'x' and 'y'
all_data <- cbind(all_y_data,all_x_data)
##Adding Activity Label by joining with the activity.labels table
merged_data <- join(all_data,activity.labels,by="activity.code")
str(merged_data$activity.label)
## Each of the observation actually belongs to subjects (30 volunteers)
## Reading in the subject data 
subject_train <- read.table(fpath[30])
subject_test <- read.table(fpath[16])
##Combining train and test level observations for subject
all_subject_data <- rbind(subject_test,subject_train)
## Adding the subject column to the previously merged data
all <- cbind(all_subject_data,merged_data)

### Identifying the measurements that are mean()- assumption if the variable has -mean at the end 
mean.var <- grep("-mean",names(all))
mean.variables <- names(all)[mean.var]

### Identifying the measurements that are stddev() - assumption if the variable has -std 
std.var <- grep("-std",names(all))
std.variables <- names(all)[std.var]

##Putting all of the columns selected using above 2 conditions in a vector
namestoselect <- subset(names(all), names(all)%in% c(mean.variables,std.variables))

## Filtering to required number of columns - subject, activity label, and measurements denoting mean and std. deviation
tidy.data <- subset(all, select =c("V1","activity.label",namestoselect))
str(tidy.data)
## Labeling the first column with a meaningful name
names(tidy.data)[1] <- "subject"


##Step 5 of the project - generating independent tidy data set
##melting to group by subject and activity label
mdata <- melt(tidy.data, id=c("subject","activity.label")) 
str(mdata)
## using cast to compute means of all columns by subject and activity name
subjmeans <- cast(mdata, subject + activity.label~variable, mean)
str(subjmeans)
## the data set generated above is a wide-form tidy data set and required output.
## The assignment only requires .txt, but .csv is also generated here for easy readability. 
write.csv(subjmeans,"tidy.csv")
write.table(subjmeans,file="tidy.txt",row.name=FALSE )


