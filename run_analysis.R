# Load libraries used in the script
library(readr)
library(dplyr)

# 0 - READ DATA PROPERLY

# Read column names. Note that the feature names are in the second column
features <- read_delim("./data/features.txt", delim = " ", col_names = FALSE, col_types = "-c")
numColumns <- nrow(features)

# In order to avoid parsing problems, read all columns as character
colTypes <- paste(rep("c", numColumns), collapse="")

# Read and  rebuild the training set
X_train <- read_delim("./data/train/X_train.txt", delim = " ", col_names = features[[1]], col_types = colTypes)
labels_train <- read_delim("./data/train/y_train.txt", delim = " ", col_names = "label", col_types = "c")
subject_train <- read_delim("./data/train/subject_train.txt", delim = " ", col_names = "subject", col_types = "c")
X_train <- bind_cols(subject_train, labels_train, X_train)

# Read and rebuild the test set
X_test <- read_delim("./data/test/X_test.txt", delim = " ",col_names = features[[1]], col_types = colTypes)
labels_test <- read_delim("./data/test/y_test.txt", delim = " ", col_names = "label", col_types = "c")
subject_test <- read_delim("./data/test/subject_test.txt", delim = " ", col_names = "subject", col_types = "c")
X_test <- bind_cols(subject_test, labels_test, X_test)

# Now parse all columns as numeric
X_train <- mutate_all(X_train, as.numeric)
X_test <- mutate_all(X_test, as.numeric)

# 1 - MERGE DATA SETS

# Bind the two data sets
X <- bind_rows(X_train, X_test)

# 2 - EXTRACT MEANS AND STANDARD DEVIATIONS

# The selected column names will be useful later
colNames <- names(X)
colNames <- c("subject", "label", colNames[grep("mean\\(\\)", colNames)], colNames[grep("std\\(\\)", colNames)])
X <- select(X, colNames)

# 3 - ASSIGN DESCRITPTIVE ACTIVITY NAMES

# The endoding of the activities is in the first column of the activity label file
activity_labels = read_delim("./data/activity_labels.txt", delim = " ", col_names = c("label", "description"), col_types = "nc")
# Use the encoding in the label column in the data set as index for retrieving the corresponding activity label
X <- mutate(X, label=pull(activity_labels[label, ], "description"))

# 4 - ASSIGN DESCRIPTIVE VARIABLE NAMES

# Expand column names according to the codebook
colNames <- sub("^t", "Time-", colNames)
colNames <- sub("^f", "Frequency-", colNames)
colNames <- sub("Acc", "Acceleration", colNames)
colNames <- sub("Gyro", "AngularVelocity", colNames)
colNames <- sub("Mag", "Magnitude", colNames)
colNames <- sub("mean\\(\\)", "mean", colNames)
colNames <- sub("std\\(\\)", "std", colNames)
colNames <- sub("BodyBody", "Body", colNames)
names(X) <- colNames

# 5 - CREATE A SEPARATE DATA SET OF AVERAGES

# Group by subject and labels
Y <- X %>% group_by(subject, label) %>% summarise(across(everything(), mean, .names = "averaged-{.col}"), .groups = "keep")

#Write output data
write.table(Y, file = "./data/output_data_set.txt", row.names = FALSE)