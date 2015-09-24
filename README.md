# Course Project for Cleaning Data #

This document describes, `run_analysis.R` file.

The script can be broken into 3 parts

* Downloading and Preparing Data
* Loading Data and Transformations
* Calculations and Writing Data

Whole process is started with the call of the function `process`

## 1 - Downloading and Preparing Data ##

The function, `prepareData` does the following in order

* Creates Data Directory
* Download Data Files
* Unzip Downloaded Files

The code itself is quite straightforward for these functions
and doesn't need extra explanation.

## 2 - Loading Data ##

After gathering data and extracting it, the `loadData` function
has been called with the `folder` argument. `folder` argument
shoul be either `train` or `test`.

The `loadData` function does quite a lot.

It first read the `features` and `activity labels`, then use these to build new one big table.

Then it selects the columns that are only related with the `standard deviation` or `mean`.

Lastly, it reads the `subjects` for every observation, and bind it with the real data.

Both train data and test data loaded with this function and binded together in the main process.

## 3 - Calculations and Writing Data ##

After loading the data, and selected the columns we actually care, we use here `averages` method to
group the data with `subject` and `activity`. Then we use the `summarise_each` function from `dplyr`
to calculate the mean of every variable within grouped data.
