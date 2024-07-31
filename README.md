![](https://github.com/RM-Sharma999/WORLD-LAYOFFS-DATA-CLEANING-AND-EDA/blob/main/Global%20Layoffs%20(Starting%20from%20March%202020).png)

## GLOBAL LAYOFFS (Starting From March 2020)

# Background
Considering the recent layoffs in big tech companies and various other sectors, many questions arised in my mind with regards to the cause and effects of this problem. In order to uncover the insights to this Layoff Trend, I decided to do a bit of Exploratory data analysis on the World Layoffs dataset from Kaggle.com and found out that tens of thousands of people have lost jobs across 57 countries, 2586 companies and 31 industries starting from the year 2020 to the current yeat 2024.

# About the Dataset
As stated above, the dataset was obtained from Kaggle.com https://www.kaggle.com/datasets/theakhilb/layoffs-data-2022. It reports the layoffs across 57 countries and 31 industries from 2020 to 2024, the data has twelve columns out of which only nine were useful for EDA. These columns are: company(name of the layoff company), location(location of the company headquarters), industry(industry of the company), total laid_off(number of employees laid off), percentage laid_off(percentage of employees laid off), date(date of layoff), stage(stage of company funding), country(the country where company resides), fund_raised(fund raised by the company in Million $). 


![](https://i.imgur.com/OEYzKPw.png)

# Data Cleaning Process
The data was loaded into MYSQL and therefore converted into a database table, then i created a duplicate table to work upon and clean the data with the following steps below:

1. Found and removed any duplicate rows using temp tables.

2. Standardized the Data, checked for any spelling errors, converted the Date column to Standard formart. 

3. Changed the datatypes of two columns, replaced all blank values with Null Values in columns.

4. Dealt with any NULL values, Blank Values or any other misleading values.

5. Removed any unwanted row or columns.

# Data Analysis AND Visualization
I Utilized SQL to perform Exploratory Data Analysis on the Layoffs Data and used the insights gathered to create some visualizations using Tableau.
