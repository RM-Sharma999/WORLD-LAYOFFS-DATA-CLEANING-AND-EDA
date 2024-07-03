#Data cleaning:

#Creating a copy of the table layoffs_data:
DROP TABLE IF EXISTS world_layoffs.layoffs_cleaned;

CREATE TABLE world_layoffs.layoffs_cleaned
LIKE world_layoffs.layoffs_data;

INSERT INTO world_layoffs.layoffs_cleaned
SELECT * FROM world_layoffs.layoffs_data;

SELECT * FROM world_layoffs.layoffs_cleaned;

#1) Remove duplicates:
-- [Using temp tables to handle duplicate rows!]

CREATE TEMPORARY TABLE duplicate_table(
  `Company` text,
  `Location_HQ` text,
  `Industry` text,
  `Laid_Off_Count` INT,
  `Percentage` text,
  `Date` text,
  `Source` text,
  `Funds_Raised` text,
  `Stage` text,
  `Date_Added` text,
  `Country` text,
  `List_of_Employees_Laid_Off` INT,
  `row_num` INT
);

INSERT INTO duplicate_table
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY Company, Location_HQ, Industry, Laid_Off_Count, Percentage, `Date`, Funds_Raised, Stage, Country) AS row_num	
FROM world_layoffs.layoffs_cleaned;

SELECT * -- (DELETE)
FROM duplicate_table
WHERE row_num > 1;

ALTER TABLE duplicate_table
DROP COLUMN row_num;

TRUNCATE TABLE world_layoffs.layoffs_cleaned;

INSERT INTO world_layoffs.layoffs_cleaned
SELECT * FROM duplicate_table;

#2) Standardize the Data:
SELECT Company, TRIM(Company)
FROM world_layoffs.layoffs_cleaned;

UPDATE world_layoffs.layoffs_cleaned
SET Company = TRIM(Company);

-- Checking for any spelling errors:
SELECT DISTINCT Location_HQ
FROM world_layoffs.layoffs_cleaned
ORDER BY Location_HQ;

SELECT DISTINCT Industry
FROM world_layoffs.layoffs_cleaned
ORDER BY Industry;

SELECT DISTINCT Country
FROM world_layoffs.layoffs_cleaned
ORDER BY Country;

-- Changing the Date column to Standard formart:
UPDATE world_layoffs.layoffs_cleaned
SET `Date` = STR_TO_DATE(`Date`,'%Y-%m-%dT%H:%i:%s.%fZ');

ALTER TABLE world_layoffs.layoffs_cleaned
MODIFY COLUMN `Date` DATE;

-- Changing the datatypes of columns:
ALTER TABLE world_layoffs.layoffs_cleaned
MODIFY COLUMN Laid_Off_Count INT;

ALTER TABLE world_layoffs.layoffs_cleaned
MODIFY COLUMN Funds_Raised INT;

-- Replacing all blank values with Null Values in columns:
UPDATE world_layoffs.layoffs_cleaned
SET Laid_Off_Count = NULL
WHERE Laid_Off_Count = '';

UPDATE world_layoffs.layoffs_cleaned
SET Funds_Raised = NULL
WHERE Funds_Raised = '';

#3) NULL values, Blank Values or any other misleading values:
SELECT t1.Company, t1.Industry, t2.Industry
FROM world_layoffs.layoffs_cleaned t1
JOIN world_layoffs.layoffs_cleaned t2
	ON t1.Company = t2.Company
WHERE t1.Industry = 'Other'
AND t2.Industry != 'Other';

UPDATE world_layoffs.layoffs_cleaned AS t1
JOIN world_layoffs.layoffs_cleaned AS t2
	ON t1.Company = t2.Company
SET t1.Industry = t2.Industry
WHERE t1.Industry = 'Other'
AND t2.Industry != 'Other';


SELECT *
FROM world_layoffs.layoffs_cleaned;

-- SELECT t1.Company, t1.Location_HQ, t1.Industry, t1.Date, t1.Stage, t2.Stage
-- FROM world_layoffs.layoffs_cleaned t1
-- JOIN world_layoffs.layoffs_cleaned t2
-- 	ON t1.Company = t2.Company
-- WHERE t1.Stage = 'Unknown'
-- AND t2.Stage != 'Unknown';

#4) Remove any unwanted row or columns:
SELECT * 
FROM world_layoffs.layoffs_cleaned
WHERE Laid_Off_Count IS NULL
AND Percentage IS NULL;

DELETE
FROM world_layoffs.layoffs_cleaned
WHERE Laid_Off_Count IS NULL
AND Percentage IS NULL;

ALTER TABLE world_layoffs.layoffs_cleaned
DROP COLUMN Date_Added,
DROP COLUMN List_of_Employees_Laid_Off;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--  Exploratory Data Analysis:
-- Date Range:
SELECT MIN(`Date`), MAX(`Date`)
FROM world_layoffs.layoffs_cleaned;

-- Max Layoffs:
SELECT MAX(Laid_Off_Count)
FROM world_layoffs.layoffs_cleaned;

-- Max and Min Percentage_Layoff:
SELECT MAX(Percentage), MIN(Percentage) 
FROM world_layoffs.layoffs_cleaned;

-- Layoff Count of Companies with 100% Layoffs:
SELECT *
FROM world_layoffs.layoffs_cleaned
WHERE Percentage = 1
ORDER BY Laid_Off_Count DESC;

-- Funds Raised by Companies with 100% Layoffs:
SELECT *
FROM world_layoffs.layoffs_cleaned
WHERE Percentage = 1
ORDER BY Funds_Raised DESC;

-- Total Layoffs per Company:
SELECT Company, SUM(Laid_Off_Count) AS Layoff_Count_per_Company
FROM world_layoffs.layoffs_cleaned
GROUP BY Company
ORDER BY 2 DESC;

-- Layoff_Count_per_Company_HQ:
SELECT Company, Location_HQ, SUM(Laid_Off_Count) AS Layoff_Count_per_Location_HQ
FROM world_layoffs.layoffs_cleaned
GROUP BY Company, Location_HQ
ORDER BY 3 DESC;

-- Layoff_Count_per_Industry:
SELECT Industry, SUM(Laid_Off_Count) AS Layoff_Count_per_Industry
FROM world_layoffs.layoffs_cleaned
GROUP BY Industry
ORDER BY 2 DESC;

-- Layoff_Count_per_Location:
SELECT Location_HQ, SUM(Laid_Off_Count) AS Layoff_Count_per_Location
FROM world_layoffs.layoffs_cleaned 
GROUP BY Location_HQ 
ORDER BY 2 DESC;

-- Layoff_Count_per_Country:
SELECT Country, SUM(Laid_Off_Count) AS Layoff_Count_per_Country
FROM world_layoffs.layoffs_cleaned
GROUP BY Country
ORDER BY 2 DESC;

-- Layoff_Count_per_Year:
SELECT YEAR(`Date`), SUM(Laid_Off_Count) AS Layoff_Count_per_Year
FROM world_layoffs.layoffs_cleaned
GROUP BY YEAR(`Date`)
ORDER BY 1 DESC;

-- Layoff_Count_per_Stage:
SELECT Stage, SUM(Laid_Off_Count) AS Layoff_Count_per_Stage
FROM world_layoffs.layoffs_cleaned
GROUP BY Stage
ORDER BY 2 DESC;

-- Rolling_Total by every month and year:
WITH Rolling_Total AS (
	SELECT SUBSTRING(`Date`, 1, 7) AS `MONTH`, SUM(Laid_Off_Count) AS Total_layoff
	FROM world_layoffs.layoffs_cleaned
	GROUP BY `MONTH`
	ORDER BY 1
)
SELECT `MONTH`, Total_layoff, SUM(Total_layoff) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Rolling_Total by every month per year:
WITH Rolling_Total AS (
	SELECT SUBSTRING(`Date`, 1, 7) AS `MONTH`, SUM(Laid_Off_Count) AS Total_layoff
	FROM world_layoffs.layoffs_cleaned
	GROUP BY `MONTH`
	ORDER BY 1
)
SELECT `MONTH`, Total_layoff, SUM(Total_layoff) OVER (PARTITION BY SUBSTRING(`MONTH`, 1, 4) ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Ranking every Company with Total_Layoffs per Year:
WITH Company_Year (Company, Years, Total_Layoffs) AS (
	SELECT Company, YEAR(`Date`), SUM(Laid_Off_Count)
	FROM world_layoffs.layoffs_cleaned
	GROUP BY Company, YEAR(`Date`)
)
SELECT *,
DENSE_RANK() OVER (PARTITION BY Years ORDER BY Total_Layoffs DESC) AS Ranking
FROM Company_Year
ORDER BY Ranking;

-- Top Five Ranking Companies with Total_Layoffs per Year:
WITH Company_Year (Company, Years, Total_Layoffs) AS (
	SELECT Company, YEAR(`Date`), SUM(Laid_Off_Count)
	FROM world_layoffs.layoffs_cleaned
	GROUP BY Company, YEAR(`Date`)
),
Company_Year_Rank AS (
	SELECT *,
	DENSE_RANK() OVER (PARTITION BY Years ORDER BY Total_Layoffs DESC) AS Ranking
	FROM Company_Year
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5;
