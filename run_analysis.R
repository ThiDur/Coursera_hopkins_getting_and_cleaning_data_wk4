library(dplyr)
library(stringr)
# Getting and estracting the data
tbl_train_values <- read.table(unz('getdata_projectfiles_UCI HAR Dataset.zip', 'UCI HAR Dataset/train/X_train.txt'), header=FALSE)
tbl_train_activities <- read.table(unz('getdata_projectfiles_UCI HAR Dataset.zip', 'UCI HAR Dataset/train/y_train.txt'), header=FALSE)
tbl_train_subjects <- read.table(unz('getdata_projectfiles_UCI HAR Dataset.zip', 'UCI HAR Dataset/train/subject_train.txt'), header=FALSE)

tbl_test_values <- read.table(unz('getdata_projectfiles_UCI HAR Dataset.zip', 'UCI HAR Dataset/test/X_test.txt'), header=FALSE)
tbl_test_activities <- read.table(unz('getdata_projectfiles_UCI HAR Dataset.zip', 'UCI HAR Dataset/test/y_test.txt'), header=FALSE)
tbl_test_subjects <- read.table(unz('getdata_projectfiles_UCI HAR Dataset.zip', 'UCI HAR Dataset/test/subject_test.txt'), header=FALSE)

# tbl_activity_labesl <- read.csv('activity_labels.txt')
tbl_features <- read.csv(unz('getdata_projectfiles_UCI HAR Dataset.zip', 'UCI HAR Dataset/features.txt'), header=FALSE, sep='-')
 
# Merges the training and the test sets to create one data set.
tbl_train <- cbind(tbl_train_values, tbl_train_activities, tbl_train_subjects)
tbl_test <- cbind(tbl_test_values, tbl_test_activities, tbl_test_subjects)

rm(tbl_train_values, tbl_train_activities, tbl_train_subjects)
rm(tbl_test_values, tbl_test_activities, tbl_test_subjects)

tbl_total <- rbind(tbl_train, tbl_test)
write.csv(tbl_total, "tbl_total.csv")
rm(tbl_train, tbl_test)

# Extracts only the measurements on the mean and standard deviation for each measurement.
selected_columns <- c(which(tbl_features$V2 == "mean()" | tbl_features$V2 == "std()"), 562, 563)
tbl_total_mean_std <- tbl_total[ ,selected_columns]
save_ing <- tbl_total_mean_std

# Uses descriptive activity names to name the activities in the data set
lbls <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING" , "LAYING")
lvls <- c(1, 2, 3, 4, 5, 6)
tbl_total_mean_std <- mutate(tbl_total_mean_std, V1.1=factor(V1.1, levels=lvls, labels=lbls))

# Appropriately labels the data set with descriptive variable names.
tbl_used_features <- tbl_features[which(tbl_features$V2 == "mean()" | tbl_features$V2 == "std()"), ]
write.csv(tbl_used_features, "tbl_used_features.csv")
column_names <- with(tbl_used_features, str_replace(paste(str_replace(V1, "\\d*\\s", ""), " ", V2, " ", V3), "\\s*$", ""))
column_names <- c(column_names, "activity", "subject")

colnames(tbl_total_mean_std) <- column_names
tibble_total_mean_std <- as_tibble(tbl_total_mean_std)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
total_means <- tibble_total_mean_std %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

# Write output to file "tidy_data.txt"
write.table(total_means, "tidy_data.txt", quote=FALSE, row.names=FALSE)