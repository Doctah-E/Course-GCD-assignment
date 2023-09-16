# Course-GCD-assignment

The codebook that describes the data generated in the final step of the assignment is generated in the Codebook.Rmd file, which produces codebook.pdf.

This document explains the steps taken in the run_analysis.R file. These are also explained in the script itself. 

Note: the order of the operations deviates slightly from the instructions. However, the result should be the same. E.g. I found it easier to provide columns with names right away (after opening the data).

### Step 1
After setting the working directory and loading necessary packages, the training data were openened. The file was in fixed format, with a width of 16 for each variable, and 561 variables in total. 

### Step 2
The names of the columns were taken from features.txt. They contained duplicate labels (not Tidy), but I kept them because the duplicates are dropped later on. 

### Step 3
The activities were added to the data (they were taken from Y_train.txt). The labels had to come from a different file: activity_labels.txt. This variable was converted into a factor and the data were then combined (starting with the activity column).

### Step 4
The person identification variable (1 through 30) was added to the data, and labelled "person".

### Step 5
All the previous steps were repeated on the test data.

### Step 6
The train and test data were combined.

### Step 7
Variables that have *mean* or *std* in their names were kept, the others were removed. (with the exception of person and activity)

### Step 8
The data were converted to a tibble dataset, which was possible because the duplicates had been removed.

### Step 9
The data were aggregated to the person-activity level by taking the means of all variables. The result was stored in a dataframe called Aggregated and saved. 



