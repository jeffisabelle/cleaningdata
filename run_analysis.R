library(dplyr)

DATA_PATH <- "data"
ZIP_PATH <- paste(DATA_PATH, "dataset.zip", sep = "/")
DATASET_PATH <- paste(DATA_PATH, "UCI HAR Dataset", sep = "/")
DATA_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## create data folder if it doesnt exists
createDataDir <- function(path) {
    if(!dir.exists(path)) dir.create(path)
}

## download project files to data folder
downloadData <- function(url, zipPath) {
    if(!file.exists(zipPath)) {
        download.file(url, destfile = zipPath, method="curl")
    }
}

## unzip downloaded file
unzipData <- function(zipPath) {
    unzip(zipPath, exdir = "./data")
}

## prepare data to be worked
prepareData <- function() {
    createDataDir(DATA_PATH)
    downloadData(URL, ZIP_PATH)
    unzipData(ZIP_PATH)
}

## get features as a vector
getFeatures <- function(){
    features_path <- paste(DATASET_PATH, "features.txt", sep = "/")
    features <- read.table(features_path)
    features[, 2]  # 2nd column is the actual features
}

## get activity labels
getLabels <- function() {
    labelsPath <- paste(DATASET_PATH, "activity_labels.txt", sep = "/")
    read.table(labelsPath)
}

## get subjects as a vector
getSubjects <- function(folder) {
    subject_filename <- paste("subject_", folder, ".txt", sep = "")
    subject_path <- paste(DATASET_PATH, folder, subject_filename, sep = "/")
    subject <- read.table(subject_path)
    subject
    ## su[, 2]  # 2nd column is the actual features
}

## heavy lifting. laods data into memory after applying
## needed transformations
loadData <- function(folder) {
    features <- getFeatures()
    labels <- getLabels()

    x_name <- paste("x_", folder, ".txt", sep = "")
    x_path <- paste(DATASET_PATH, folder, x_name, sep = "/")
    x <- read.table(x_path, header = FALSE)
    colnames(x) <- features
    selectColumns <- grep("*std*|*mean*", features)
    x <- x[, selectColumns]

    y_name <- paste("y_", folder, ".txt", sep = "")
    y_path <- paste(DATASET_PATH, folder, y_name, sep = "/")
    y <- read.table(y_path)
    activities <- merge(y, labels, by = "V1")

    subjects <- getSubjects(folder)

    x <- cbind(activity=activities$V2, x)
    x <- cbind(subject=subjects$V1, x)
    x
}

## creates a second, independent tidy data set with the average of
## each variable for each activity and each subject.
averages <- function(data) {
    data %>%
        group_by(subject, activity) %>%
        arrange(subject, activity) %>%
        summarise_each(funs(mean))
}


## start process
process <- function() {
    prepareData()
    testData <- loadData("test")
    trainData <- loadData("train")
    allData <- rbind(trainData, testData)
    averagedData <- averages(allData)

    outputPath <- paste(DATA_PATH, "output.txt", sep="/")
    write.table(averagedData, outputPath, row.names = FALSE, sep=",")
    averagedData
}

process()
