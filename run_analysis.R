##Feb 13,2014
## Project 1  - Getting & Cleaning Data 

#Adding required libraries
library(httr)
library(reshape)
library(ggplot2)
library(plyr)
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
fpath[5]
#using read.table function to read all the files 
activity.labels<- read.table(fpath[1])
features <- read.table(fpath[2])
# train.acc.total.x<- read.table(fpath[27])
# train.acc.total.y<- read.table(fpath[28])
# train.acc.total.z<- read.table(fpath[29])
feature.labels <- features$V2
X_test <- read.table(fpath[17])
Y_test <- read.table(fpath[18])

X_train <- read.table(fpath[31])
Y_train <- read.table(fpath[32])
all_x_data <- rbind(X_test,X_train)
all_y_data <- rbind(Y_test,Y_train)

str(all_y_data)
names(all_y_data) <- "activity.code"
names(activity.labels) <- c("activity.code","activity.label")
unique(Y_test$V1)

all_data <- cbind(all_y_data,all_x_data)
str(all_data)

merged_data <- join(all_data,activity.labels,by="activity.code")
names(merged_data)
str(merged_data$activity.label)

subject_train <- read.table(fpath[30])
subject_test <- read.table(fpath[16])
all_subject_data <- rbind(subject_test,subject_train)
all <- cbind(all_subject_data,merged_data)

names(all)

mean.var <- grep("-mean",names(all))
mean.variables <- names(all)[mean.var]

std.var <- grep("-std",names(all))
std.variables <- names(all)[std.var]

namestoselect <- subset(names(all), names(all)%in% c(mean.variables,std.variables))

tidy.data <- subset(all, select =c("V1","activity.label",namestoselect))
str(tidy.data)
names(tidy.data)[1] <- "subject"


mdata <- melt(tidy.data, id=c("subject","activity.label")) 
str(mdata)

subjmeans <- cast(mdata, subject + activity.label~variable, mean)
str(subjmeans)
write.csv(subjmeans,"solution.csv")
