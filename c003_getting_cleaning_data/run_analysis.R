#Coursera
#Getting and Cleaning Data
#Course Project

#Antony Hallam
#23-10-2015

###################################################################################
#Load the data into R
#getting the features
features <- as.character(read.csv("UCI HAR Dataset\\features.txt",sep="",header=F)[,2])
actLab <- read.csv("UCI HAR Dataset\\activity_labels.txt",sep="",header=F,colClasses = c('integer','character'))
#Logical list of mean and std values from features
stdmeanInd <- which(grepl('mean',features) | grepl('std',features))

#getting the gyro data
dTrain <- read.csv("UCI HAR Dataset\\train\\X_train.txt",sep="",header=F,col.names = features)
dTest <- read.csv("UCI HAR Dataset\\test\\X_test.txt",sep="",header=F,col.names = features)
#subset to only required fields to reduce memory load
dTrain <- dTrain[,stdmeanInd]
dTest <- dTest[,stdmeanInd]


#getting the subject index
subTrain <- read.csv("UCI HAR Dataset\\train\\subject_train.txt",sep="",header=F,col.names = 'Subject Number')
subTest <- read.csv("UCI HAR Dataset\\test\\subject_test.txt",sep="",header=F,col.names = 'Subject Number')

#getting the activity index
actTrain <- read.csv("UCI HAR Dataset\\train\\Y_train.txt",sep="",header=F,col.names = "Activity Number")
actTest <- read.csv("UCI HAR Dataset\\test\\Y_test.txt",sep="",header=F,col.names = "Activity Number")

#merge training data
dTrain['Subject Number'] <- subTrain['Subject.Number']
dTrain['Activity Number'] <- actTrain['Activity.Number']

#merge test data
dTest['Subject Number'] <- subTest['Subject.Number']
dTest['Activity Number'] <- actTest['Activity.Number']

#merge all data
data <- rbind(dTrain,dTest)

#map activity labels
acn  <- data$`Activity Number`
data['Activity Labels'] <- mapvalues(acn,actLab$V1,actLab$V2)

#move to data_table and summarise
library(data.table)
dt_data  <- as.data.table(data)
s_data  <- dt_data[, lapply(.SD, mean), by = c('Subject Number','Activity Labels')]
setorder(s_data,"Subject Number")

#Output Cleaned Data
write.table(s_data ,file = 'cleaned_data.txt', row.names = F)

#Build Code Book for Markdown

s_data_names['Index']  <- c(1:82)
s_data_names['Features']  <- colnames(s_data)
colnames(s_data_names)  <- c('Index','Features')
write.table(s_data_names ,file = 'cleaned_data_cb.txt', row.names = F)