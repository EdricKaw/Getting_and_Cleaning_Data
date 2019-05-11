library(dplyr)

filename <- "Coursera_DS3_Final.zip"
setwd("C:/Users/EdricKaw/Documents/CERTS/Coursera/Coursera_Courses/03_Getting_And_Cleaning_Data/Course_Project/UCI HAR Dataset")
list.files()

activities <- read.table("activity_labels.txt" ,col.names = c("code","activity") )
features <- read.table("features.txt",col.names = c("n","functions") )
subject_test <- read.table("test/subject_test.txt",col.names = c("subject") )
x_test <- read.table("test/x_test.txt",col.names = features$functions)
y_test <- read.table("test/y_test.txt",col.names = "code")
subject_train <- read.table("train/subject_train.txt",col.names = "subject")
x_train <- read.table("train/x_train.txt",col.names = features$functions) 
y_train <- read.table("train/y_train.txt",col.names = "code")

### 1. Merges the training and the test sets to create one data set. ###

merged_x <- rbind(x_train, x_test)
merged_y <- rbind(y_train, y_test)
merged_subject <- rbind(subject_train, subject_test)
merged_data <- cbind(merged_subject, merged_y, merged_x)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. ### 

fields <- colnames(merged_data)
fields[grep(".[Mm][Ee][Aa][Nn].|.[Ss][Tt][Dd].",fields)]
data1 <- merged_data %>% select(subject, code, fields[grep(".[Mm][Ee][Aa][Nn].|.[Ss][Tt][Dd].",fields)])


### 3. Uses descriptive activity names to name the activities in the data set ###

data1 <- data1 %>% mutate(code = activities[data2$code,2] )


### 4. Appropriately labels the data set with descriptive variable names.  ###

names(data1)[2] = "activity"
names(data1)<-gsub("Acc", "Accelerometer", names(data1))
names(data1)<-gsub("Gyro", "Gyroscope", names(data1))
names(data1)<-gsub("BodyBody", "Body", names(data1))
names(data1)<-gsub("Mag", "Magnitude", names(data1))
names(data1)<-gsub("^t", "Time", names(data1))
names(data1)<-gsub("^f", "Frequency", names(data1))
names(data1)<-gsub("tBody", "TimeBody", names(data1))
names(data1)<-gsub("-mean()", "Mean", names(data1), ignore.case = TRUE)
names(data1)<-gsub("-std()", "STD", names(data1), ignore.case = TRUE)
names(data1)<-gsub("-freq()", "Frequency", names(data1), ignore.case = TRUE)
names(data1)<-gsub("angle", "Angle", names(data1))
names(data1)<-gsub("gravity", "Gravity", names(data1))

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ###

final_data <- data1 %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(final_data, "FinalData.txt", row.name=FALSE)

