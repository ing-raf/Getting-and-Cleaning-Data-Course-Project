The `run_analysis.R` is found in the root of the repository, while the original Samsung data is under the `/data` directory. The output daata set is called `output_data_set.txt` and is available under the `/data` directory. Apart from `output_data_set.txt`, all other files and folders under the `/data` directory come from the original data set.

# Preliminary operations

The `run_analysis.R` script first loads the training and test data sets. In the original Samsung data set, the training and test sets are splitted across three files (where `*` is either `train` or `test` for the training and test set respectively):

* `data/*/X_*.txt` containing the feature vector with the measrements (563 column)
* `data/*/y_*.txt` containing the activity code (1 column)
* `data/*/subject_test` containing the ID of the subject (1 column)

Therefore, the first step is to rebuild the data sets. The column names for the feature vector is to be found in the `./data/features.txt` file, so the script reads this file first, to use the appropriate column name when reading the feature vector file. Then the script reads the three files containing the training set and binds their columns together tor build the training set. The same operation is done for the test set.

# 1. Merge the training and test set to create one data set.

Once the two data sets have been rebuilt, it is sufficient to bind their rows together to create a single data set, since the saame column names have been used for reading the two data sets.

# 2. Extract only the measurements on the mean and standard deviation for each measurement.

This can be done easily by working on the column names, since means and standard deviations are characterised by `mean()` and `-std()` respectively in their names in the original data set.

# 3. Use descriptive activity names to name the activities in the data set.

The encoding of the activities is to be found in the `./data/activity_label.txt` file. Hence this file is read, and the number in the `label` column of the data set is used as index to obtain the corresponging activity name.

# 4. Appropriately label the data set with descriptive variable names.

This is again done working on the column names, by expanding the various parts of each column name according to their meaning described in the original codebook, which is too be found in the `./data/features_info.txt` file.

# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

The new data set is created by firstly grouping the original data set by subject and activity label, then by summarising the data set with `mean` as aggregation function. 

Finally, the resulting data  set is written in the `./data/output_data_set.txt` output file.