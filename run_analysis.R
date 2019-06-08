library(dplyr)
library(data.table)
df_train_x <- fread("./UCI HAR Dataset/train/X_train.txt")
df_valid_x <- fread("./UCI HAR Dataset/test/X_test.txt")
df_train_y <- fread("./UCI HAR Dataset/train/y_train.txt")
df_valid_y <- fread("./UCI HAR Dataset/test/y_test.txt")
features <- fread("./UCI HAR Dataset/features.txt")

# 1. merge x and y
df_x <- bind_rows(df_train_x,df_valid_x)
df_y <- bind_rows(df_train_y,df_valid_y)

# 2. extract names
variable.names <- features$V2[grep("mean|std", features$V2)]
df_x_new <- as.data.frame(df_x)[ ,grep("mean|std", features$V2)]
colnames(df_x_new) <- variable.names

# name the df_train_x
colnames(df_train_x) <- features$V2

# rename y
mapper <- fread("./UCI HAR Dataset/activity_labels.txt")
df_y <- df_y %>% left_join(mapper,by='V1')

# bind activity
df_new <- bind_cols(df_x_new,df_y)

# subject data
subject_train <- fread("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- fread("./UCI HAR Dataset/test/subject_test.txt")
subject <- bind_rows(subject_train,subject_test)
colnames(subject) <- "subject"

df_new <-bind_cols(df_new,subject)

df_new %>%
  group_by(V1,V2,subject) %>%
  summarise_all(mean) -> df_average
