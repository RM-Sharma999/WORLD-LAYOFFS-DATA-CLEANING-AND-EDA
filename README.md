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
I Utilized SQL to perform Exploratory Data Analysis on the Layoffs Data and used the insights gathered to create some visualizations using Tableau. There were many possible visualizations using the insights gathered, but i created the following Visualizations:

# Funds Raised By Top 20 Companies
This bubble chart Visualization displays the funds raised by the top 20 companies, with each bubble representing a company. The size of the bubbles indicates the amount of funds raised, with larger bubbles representing higher amounts. For instance, Netflix has raised the most funds, as shown by the largest bubble, followed by other companies like Meta, Uber, and WeWork. The chart effectively highlights the comparative fundraising levels among these companies.

![](https://i.imgur.com/id4VV2U.png)

# Layoffs Per Industry
This horizontal bar chart displays the number of layoffs across various industries. The industries are listed on the left, with the corresponding number of layoffs represented by the length of the bars plus the extra layoffs label at the end of the bar. The Retail industry has experienced the highest number of layoffs, followed closely by the Consumer and Other sectors. The chart provides a clear comparison of layoffs across different industries, highlighting the sectors most affected.

![](https://i.imgur.com/W5d9ZV9.png)

# Global Layoff Map
This World Map Visualization illustrates the distribution of layoffs across various countries worldwide. Each country is shaded differently, with labels indicating the number of layoffs recorded in that location. The United States shows the highest number of layoffs at 406,643, followed by other countries such as Canada, Brazil, the United Kingdom, and others. The map provides a geographical overview of the impact of layoffs, highlighting the countries most affected.

![](https://i.imgur.com/HdGjst3.png)

# Annual Layoffs Comparison(From the Years 2020 to 2024)
This pie chart Visualization shows the distribution of layoffs over five years. The sectors of the pie represent different years, with percentages indicating the proportion of total layoffs that occurred each year. The chart highlights that the highest percentage of layoffs occurred in 2023 (43.90%), followed by 2022 (27.41%). The smallest portion is from 2021 (2.64%). This visualization provides a clear comparison of layoffs by year, emphasizing the most and least affected timeframes.

![](https://i.imgur.com/yMVKgWR.png)
