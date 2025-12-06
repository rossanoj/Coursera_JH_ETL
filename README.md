# Getting and Cleaning Data - Course Project

## Project Overview

This project demonstrates the ability to collect, work with, and clean a data set using R. The goal is to prepare tidy data that can be used for later analysis. The project uses the **Human Activity Recognition Using Smartphones Dataset**.

## Dataset

The dataset represents data collected from the accelerometers of Samsung Galaxy S smartphones. It includes measurements from 30 volunteers performing six different activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while wearing the smartphone.

## Files in this Repository

- `run_analysis.R`: Main script that performs all data processing steps
- `README.md`: This file, explaining the project and script functionality
- `data/`: Directory containing the raw data files
- `datos_resumen_tidy.txt`: Output file containing the tidy dataset (generated after running the script)

## Script Functionality (`run_analysis.R`)

The script performs the following operations according to the project requirements:

### Step 1: Merge Training and Test Sets

- Reads training data (`X_train.txt`, `y_train.txt`, `subject_train.txt`)
- Reads test data (`X_test.txt`, `y_test.txt`, `subject_test.txt`)
- Reads feature names (`features.txt`) and activity labels (`activity_labels.txt`)
- Combines training and test datasets using `rbind()`
- Assigns appropriate column names from the features file
- Creates a complete dataset combining subjects, activities, and measurements

### Step 2: Extract Mean and Standard Deviation Measurements

- Identifies columns containing mean() and std() measurements using `grep()`
- Filters the dataset to include only:
  - Subject identifier
  - Activity identifier
  - Mean and standard deviation measurements (66 variables)
- Uses `dplyr::select()` for efficient column selection

### Step 3: Use Descriptive Activity Names

- Replaces numeric activity codes (1-6) with descriptive names:
  - 1 → WALKING
  - 2 → WALKING_UPSTAIRS
  - 3 → WALKING_DOWNSTAIRS
  - 4 → SITTING
  - 5 → STANDING
  - 6 → LAYING
- Converts activity column to a factor with meaningful labels

### Step 4: Label Dataset with Descriptive Variable Names

- Transforms abbreviated variable names into more readable Spanish descriptive names:
  - `^t` → `tiempo` (time domain signals)
  - `^f` → `frecuencia` (frequency domain signals)
  - `Acc` → `Acelerometro` (accelerometer)
  - `Gyro` → `Giroscopio` (gyroscope)
  - `Mag` → `Magnitud` (magnitude)
  - `Body` → `Cuerpo` (body)
  - `Gravity` → `Gravedad` (gravity)
  - `mean()` → `Media` (mean)
  - `std()` → `DesviacionEstandar` (standard deviation)
- Removes hyphens and corrects duplicate "BodyBody" strings

### Step 5: Create Independent Tidy Dataset with Averages

- Groups data by subject and activity using `dplyr::group_by()`
- Calculates the mean of each measurement variable for each subject-activity combination
- Results in 180 observations (30 subjects × 6 activities)
- Arranges data by subject and activity for better readability
- Exports the tidy dataset to `datos_resumen_tidy.txt`

## How to Run the Script

1. Ensure you have R installed with the `dplyr` package:
   ```r
   install.packages("dplyr")
   ```

2. Set your working directory to the project folder:
   ```r
   setwd("path/to/Coursera_JH_ETL")
   ```

3. Ensure the `data/` directory contains all required dataset files

4. Run the script:
   ```r
   source("run_analysis.R")
   ```

5. The script will create `datos_resumen_tidy.txt` in the working directory

## Output

The final output (`datos_resumen_tidy.txt`) contains:
- 180 rows (30 subjects × 6 activities)
- 68 columns (subject ID, activity name, and 66 averaged measurements)
- Each row represents the average of all measurements for a specific subject performing a specific activity
- The file is space-delimited and can be read back into R using:
  ```r
  data <- read.table("datos_resumen_tidy.txt", header = TRUE)
  ```

## Requirements

- R (version 3.5 or higher recommended)
- dplyr package
- Raw data files in the `data/` directory

## Acknowledgments

This project is part of the **Getting and Cleaning Data** course from the Johns Hopkins University Data Science Specialization on Coursera.