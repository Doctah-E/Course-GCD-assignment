# Final assignment Course Getting cleaning data

setwd("C:/Surfdrive/R/Coursera/Getting and cleaning data/Course-GCD-assignment/UCI HAR Dataset")
library(dplyr)
library(summarytools)
library(stringr)

##  1. Look at X train file
### width variables 16 (counted in Notepad++)
### 561 features according to features.txt
x_train <- read.fwf("train/X_train.txt", widths = rep(16, 561), header = F)
x_train <- as_tibble(x_train)
x_train          # looks ok. 7352 cases; 561 variables

## 2. Add column names (from features.txt)
### (Assignment step 4)
feat <- read.delim("features.txt", sep = " ", header = F)
### do names contain duplicates?
which(duplicated(feat$V2))
### yes, several. what are the names?
names(x_train)[which(duplicated(feat$V2))]   # several variables appear 3 times
### do they consist of the same values?
### e.g. "fBodyAcc-bandsEnergy()-1,8"
which(names(x_train)=="fBodyAcc-bandsEnergy()-1,8")
cor(x_train[, c(303, 317, 331)])
### not the same values
### However, they don't contain means or SD's, so they will be removed anyway (Step 2)
### So assign names anyway
names(x_train) <- feat$V2

## 3. Add column that represents type of activity (from Y_train.txt)
### Each row represents activity, in both x and y
### First the codes
y_train <- read.fwf("train/Y_train.txt", widths = 1, header = F)
### Then the labels from activity_labels.txt and convert to factor with labels
### (Assignment step 3)
labs <- read.delim("activity_labels.txt", sep = " ", header = F)
labs
y_train$V1 <- factor(y_train$V1, levels = 1:6, labels = c(labs[,2]))
attributes(y_train$V1)
### Change name of first column to activity
names(y_train)[1] <- "activity"
### Add finally put y and x together 
train <- cbind(y_train, x_train)

## 4. Add column with person identification (subject_train.txt)
subj_train <- read.fwf("train/subject_train.txt", widths = 2, header = F)
freq(subj_train$V1)
train <- cbind(subj_train, train)
### call it "person"
names(train)[1] <- "person"

## 5. Then follow exactly the same procedure for the test data
x_test <- read.fwf("test/X_test.txt", widths = rep(16, 561), header = F)
x_test <- as_tibble(x_test)
x_test          # looks ok. 2947 cases; 561 variables
names(x_test) <- feat$V2
y_test <- read.fwf("test/Y_test.txt", widths = 1, header = F)
y_test$V1 <- factor(y_test$V1, levels = 1:6, labels = c(labs[,2]))
names(y_test)[1] <- "activity"
test<- cbind(y_test, x_test)
subj_test <- read.fwf("test/subject_test.txt", widths = 2, header = F)
test <- cbind(subj_test, test)
names(test)[1] <- "person"

## 6. Now we are ready to combine train and test 
data <- rbind(train, test)
### And we don't need the other df's any longer
rm(feat, labs, test, train, x_test, x_train, y_test, y_train, subj_test, subj_train)

## 7. Use only variables that are a mean or SD (Assignment step 2)
### Keep first column with the person and second with activity
names(data)
keep <- grep("[Mm]ean|[Ss]td", names(data))
keep
data <- data[,c(1, 2, keep)]

## 8. Create a tibble now that the duplicate names are gone
data <- as_tibble(data)
data            # looks good

## 9. Create a new datasets with means of all vars by person-activity
Aggregated <- data %>% 
    group_by(person, activity) %>% 
    summarise(across(everything(), list(mean)))
### clean up labels
names(Aggregated)[3:88] <- str_sub(names(Aggregated)[3:88], end = -3)

save(Aggregated, file = "Aggregated.RData")






