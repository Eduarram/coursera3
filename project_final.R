library(reshape2)

######################get and donload the data######################################## 

rawDataDir <- "./rawData"
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", "rawData.zip", sep = "")
dataDir <- "./data"

if (!file.exists(rawDataDir)) {
  dir.create(rawDataDir)
  download.file(url = rawDataUrl, destfile = rawDataDFn)
}

#####################################################################################
#read the paths of the tables and create a new variable call arch with the all files#
#in the directory.                                                                  #
#####################################################################################
new_dyr <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset"
arch <- c(list.files())


#####################Read labels and Names###########################################

activity_labs <- read.table(arch[1])[, 2] 
features <- read.table(arch[3])[,2]

#######################extract de measures for each feature#########################

extract <- grepl("mean|sdt", features)

######################create a paths of the tables##################################

subject_test_path <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset/test/subject_test.txt"
X_test_path <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset/test/X_test.txt"
y_test_path <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset/test/Y_test.txt"

##################read the test tables###############################################

X_test <- read.table(x_test_path)
y_test <- read.table(y_test_path) 
subject_test<- read.table(subject_test_path)

####rename the columns of the table################################################# 

names(X_test) <- features

##########extract the measures stander deviation and mean###########################

X_test <- X_test[,extract]

########################load activity labels########################################

y_test[,2] <-activity_labs[y_test[,1]]
names(y_test) <- c("Activity_id", "Activity_label")
names(subject_test) <- "subject"

#########################Bind the data#############################################

Test_Data <- cbind(subject_test, y_test, X_test)

############################load the paths of the train data#######################

subject_train_path <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset/train/subject_train.txt"
X_train_path <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset/train/X_train.txt"
Y_train_path <- "/home/rodrigo/Escritorio/data_corsera/UCI HAR Dataset/train/Y_train.txt"

####################read the train tables########################################

x_train <-read.table(X_train_path)
y_train <- read.table(Y_train_path)
subject_train <-read.table(subject_train_path)

#####rename the x_train columns##################################################

names(x_train) <- features

######extract mean, stands deviation and load the activity labels################

x_train <- x_train[, extract]
y_train[,2] <- activity_labs[y_train[,1]]
names(y_train) <- c("Activity_id", "Activity_label")
names(subject_train) <- "subject"

#########################bind the columns of train tables#########################

train_data <- cbind(subject_train, y_train, x_train)
head(Test_Data)

#########################bind the data for rows###################################

DF <-rbind(Test_Data, train_data)

#######################melt  the data frame########################################

id_labs <- c("subject", "Activity_id", "Activity_label")
alabs <- setdiff(colnames(DF), id_labs)
meldat <- melt(DF, id = id_labs, measure.vars = alabs)

#################calculate the mean function with dcast############################

all_new <- dcast(meldat, subject + Activity_label ~ variable, mean)
path_project <-  "/home/rodrigo/Documentos/final_project_getting_and_clening_data/all_new.txt"

#####################3## write file txt with new data frame#########################

write.table(all_new, file = path_project)
  
  


