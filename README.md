# Task 1: Netflix Data Cleaning and Preprocessing

## Objective
The objective of this task is to clean and prepare the Netflix Movies and TV Shows dataset by handling missing values, duplicate records, inconsistent formats, unclear column names, and incorrect data types.

## Tools Used
- Python
- Pandas
- Jupyter Notebook

## Files Included
- `task1_data_cleaning_notebook.ipynb` - Jupyter notebook containing the full cleaning process
- `netflix_titles.csv` - original raw dataset
- `cleaned_netflix_titles.csv` - final cleaned dataset
- `netflix_cleaning_summary.csv` - summary of cleaning changes

## Cleaning Steps Performed
- Loaded and inspected the Netflix dataset
- Checked missing values and duplicate rows
- Cleaned column names by making them lowercase and replacing spaces with underscores
- Removed duplicate rows if any were present
- Standardized text values and Netflix categorical values
- Fixed rows where duration values were incorrectly stored in the rating column
- Converted `date_added` into datetime format
- Converted `release_year` into a numeric column
- Filled missing `director`, `cast`, `country`, `rating`, and `duration` values with `Unknown`
- Filled missing `date_added` values using the most common date
- Checked possible outliers using the IQR method
- Exported the cleaned dataset and cleaning summary

## Short Summary
In this task, I cleaned and preprocessed the Netflix Movies and TV Shows dataset using Python Pandas. I identified and handled missing values, checked for duplicate records, standardized text values, converted date formats, fixed data types, and renamed column headers into a clean and uniform format. I also corrected rows where duration values were placed under the rating column. The final cleaned dataset is ready for further analysis or visualization.
