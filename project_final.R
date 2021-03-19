## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)

#get and donload the data 

rawDataDir <- "./rawData"
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", "rawData.zip", sep = "")
dataDir <- "./data"

if (!file.exists(rawDataDir)) {
  dir.create(rawDataDir)
  download.file(url = rawDataUrl, destfile = rawDataDFn)
}
##this is if you prefeer unzip but i don't prefeer this form
#if (!file.exists(dataDir)) {
#  dir.create(dataDir)
# unzip(zipfile = rawDataDFn, exdir = dataDir)
#}

##read the paths of the tables
new_dyr <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset"
## change the directory whit setwd(new_dyr)
arch <- c(list.files())
##read labels and Names
activity_labs <- read.table(arch[1])[, 2] 
features <- read.table(arch[3])[,2]
# extract de measures for each feature 
extract <- grepl("mean|sdt", features)
##load y_test, x_test and subjetc_test use file.choose because this command have choose the file with
##graphic interface 
X_test <- read.table(file.choose())
y_test <- read.table(file.choose()) 
subject_test<- read.table(file.choose())
##rename x_test
names(X_test) <- features

#extract the measures standar desviation and mean
X_test <- X_test[,extract]
#load activity labels
y_test[,2] <-activity_labs[y_test[,1]]
names(y_test) <- c("Activity_id", "Activity_label")
names(subject_test) <- "subject"
##Bind the data
Test_Data <- cbind(subject_test, y_test, X_test)

##load the train data
x_train <-read.table(file.choose())
y_train <- read.table(file.choose())
subject_train <-read.table(file.choose())
##rename xtrain
names(x_train) <- features
##extract
x_train <- x_train[, extract]
##load the activity labels 
y_train[,2] <- activity_labs[y_train[,1]]
names(y_train) <- c("Activity_id", "Activity_label")
names(subject_train) <- "subject"
##bind the tables 
train_data <- cbind(subject_train, y_train, x_train)
head(Test_Data)
#bind all data
DF <-rbind(Test_Data, train_data) 
##melt  the data frame

id_labs <- c("subject", "Activity_id", "Activity_label")
alabs <- setdiff(colnames(DF), id_labs)
meldat <- melt(DF, id = id_labs, measure.vars = alabs)
##calculate the mean function with dcast
all_new <- dcast(meldat, subject + Activity_label ~ variable, mean)
path_project <-  "/home/rodrigo/Documentos/final_project_getting_and_clening_data/all_new.txt"
## write file txt with new data frame
write.table(all_new, file = path_project)
  
  


