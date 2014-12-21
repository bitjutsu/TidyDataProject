library(reshape2);
library(plyr);

# 1. Merges the training and the test sets to create one data set.
# Load both data sets:
data_test <- read.table('test/X_test.txt');
# Add the subjects/positions columns (and give them names)
positions_test <- read.table('test/y_test.txt', col.names=c('position'));
subjects_test <- read.table('test/subject_test.txt', col.names=c('subject'));
data_test <- cbind(data_test, positions_test);
data_test <- cbind(data_test, subjects_test);

data_train <- read.table('train/X_train.txt');
# Add the subjects/positions columns (and give them names)
positions_train <- read.table('train/y_train.txt', col.names=c('position'));
subjects_train <- read.table('train/subject_train.txt', col.names=c('subject'));
data_train <- cbind(data_train, positions_train);
data_train <- cbind(data_train, subjects_train);

# Merge data sets:
data <- rbind(data_test, data_train);

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Only keep means and std deviations - not meanFreqs
# Columns with meanFreqs: 294, 295, 296, 373, 374, 375, 452, 453, 454, 513, 526, 539, 552
# Columns with means: 1, 2, 3, 41, 42, 43, 81, 82, 83, 121, 122, 123, 161, 162, 163, 201, 214, 227, 240, 253, 266, 267, 268, 345, 346, 347, 424, 425, 426, 503, 516, 529, 542
# Columns with stds:  4, 5, 6, 44, 45, 46, 84, 85, 86, 124, 125, 126, 164, 165, 166, 202, 215, 228, 241, 254, 269, 270, 271, 348, 349, 350, 427, 428, 429, 504, 517, 530, 543
meanIndices <- c(1, 2, 3, 41, 42, 43, 81, 82, 83, 121, 122, 123, 161, 162, 163, 201, 214, 227, 240, 253, 266, 267, 268, 345, 346, 347, 424, 425, 426, 503, 516, 529, 542);
stdIndices <-  c(4, 5, 6, 44, 45, 46, 84, 85, 86, 124, 125, 126, 164, 165, 166, 202, 215, 228, 241, 254, 269, 270, 271, 348, 349, 350, 427, 428, 429, 504, 517, 530, 543);

meanColumns <- paste0('V', meanIndices);
stdColumns <- paste0('V', stdIndices);

columns <- c(meanColumns, stdColumns, 'subject', 'position');

filtered_data <- data[columns];

# 3. Uses descriptive activity names to name the activities in the data set
# Rename all of the positions as per activity_labels.txt:
labels <- c('Walking', 'WalkingUpstairs', 'WalkingDownstairs', 'Sitting', 'Standing', 'Laying');
filtered_data$position <- factor(filtered_data$position, labels=labels);

# 4. Appropriately labels the data set with descriptive variable names.
dimensions <- c('X', 'Y', 'Z');
meanColumnNames <- c(
    paste0('TimeMeanBodyAccelerometer', dimensions),
    paste0('TimeMeanGravityAccelerometer', dimensions),
    paste0('TimeMeanBodyAccelerometerJerk', dimensions),
    paste0('TimeMeanBodyGyroscope', dimensions),
    paste0('TimeMeanBodyGyroscopeJerk', dimensions),
    'TimeMeanBodyAccelerometerMagnitude',
    'TimeMeanGravityAccelerometerMagnitude',
    'TimeMeanBodyAccelerometerJerkMagnitude',
    'TimeMeanBodyGyroscopeMagnitude',
    'TimeMeanBodyGyroscopeJerkMagnitude',
    paste0('FrequencyMeanBodyAccelerometer', dimensions),
    paste0('FrequencyMeanBodyAcceleromterJerk', dimensions),
    paste0('FrequencyMeanBodyGyroscope', dimensions),
    'FrequencyMeanBodyAccelerometerMagnitude',
    'FrequencyMeanBodyAccelerometerJerkMagnitude',
    'FrequencyMeanBodyGyroscopeMagnitude',
    'FrequencyMeanBodyGyroscopeJerkMagnitude'
);

stdDeviationColumnNames <- c(
    paste0('TimeStdDeviationBodyAccelerometer', dimensions),
    paste0('TimeStdDeviationGravityAccelerometer', dimensions),
    paste0('TimeStdDeviationBodyAccelerometerJerk', dimensions),
    paste0('TimeStdDeviationBodyGyroscope', dimensions),
    paste0('TimeStdDeviationBodyGyroscopeJerk', dimensions),
    'TimeStdDeviationBodyAccelerometerMagnitude',
    'TimeStdDeviationGravityAccelerometerMagnitude',
    'TimeStdDeviationBodyAccelerometerJerkMagnitude',
    'TimeStdDeviationBodyGyroscopeMagnitude',
    'TimeStdDeviationBodyGyroscopeJerkMagnitude',
    paste0('FrequencyStdDeviationBodyAccelerometer', dimensions),
    paste0('FrequencyStdDeviationBodyAcceleromterJerk', dimensions),
    paste0('FrequencyStdDeviationBodyGyroscope', dimensions),
    'FrequencyStdDeviationBodyAccelerometerMagnitude',
    'FrequencyStdDeviationBodyAccelerometerJerkMagnitude',
    'FrequencyStdDeviationBodyGyroscopeMagnitude',
    'FrequencyStdDeviationBodyGyroscopeJerkMagnitude'
);

columnNames <- c(meanColumnNames, stdDeviationColumnNames, 'Subject', 'Position');
names(filtered_data) <- columnNames;

# Make the data set skinny:
skinny <- melt(filtered_data, id=c('Subject', 'Position'));

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Average each variable for each position by subject
averages <- ddply(skinny, .(Subject, Position, variable), summarize, ave(value));

# Remove duplicate rows:
averages <- unique(averages);

# Rename the last column back to value:
names(averages)[names(averages) == '..1'] <- 'value';

# Save the dataset:
if (!file.exists('data')) {
    dir.create('data');
}
write.table(averages, 'data/AverageActivityTidy.txt', row.names=FALSE);
