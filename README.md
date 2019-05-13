# Readme

## Getting and estracting the data
Data from getdata_projectfiles_UCI HAR Dataset.zip is loaded:

* UCI HAR Dataset/train/X_train.txt
* UCI HAR Dataset/train/y_train.txt
* UCI HAR Dataset/train/subject_train.txt
* UCI HAR Dataset/test/X_test.txt
* UCI HAR Dataset/test/y_test.txt
* UCI HAR Dataset/test/subject_test.txt
* UCI HAR Dataset/features.txt

using read.table and unz functions.

## Merges the training and the test sets to create one data set
The datasets 

The train data and test data are binded into two separate tables using the cbind function. The order of the binds were values, activities and then subjects. Finally the train and test tables are combined in one total table using the rbind function.

## Extracts only the measurements on the mean and standard deviation for each measurement.
The columens with measures on the mean and standard deviation were taken by taking the column indices of the total table that correspond to the row-indices of the features table that have either "mean()" or "std()" in it. That is done by loading the features data as "-" separated and filtering on the second column where the data entry should equal "mean()" or "std()".
To the filtered total table the columns 562 and 563 (activity and subject) were added.

## Uses descriptive activity names to name the activities in the data set
The names contained by the features file were put into a list that was subsequently added as factors to the activities column of the dataset using the factor function.

## Appropriately labels the data set with descriptive variable names.
Column names were given by taking the features table and performing the same filter step on the columns as was done on the total table. Then the three columns in the feature table (type of variabl, e.g. fBodyAcc, the type of measurement, e.g. mean(), and possible additional info like Z axis) where then put into one variable by:
1) Cleaning the type of variable for leading numbers and whitspaces (rownumber was also given but not needed) using str_replace
2) Putting the values of all columns together in one column using paste
3) Cleaning the output for training whitespaces usign  str_replace again

Finally the names "activity" and "subject" where added to the list.
The list was then inserted into the column names of the total table.

## From the data set in step 4, creates a second, independent tidy data set with the 
Now the total table was grouped and summarised by using group_by and summarise_all with the function mean.

## Write output to file "tidy_data.txt"
Finally the output was written to the file "tidy_data.txt" using write.table.