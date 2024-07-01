--  Exploratory Data Analysis:
-- Date Range:
SELECT MIN(`Date`), MAX(`Date`)
FROM layoffs_cleaned;

-- Max Layoffs:
SELECT MAX(Laid_Off_Count)
FROM layoffs_cleaned;

-- Max and Min Percentage_Layoff:
SELECT MAX(Percentage), MIN(Percentage) 
FROM layoffs_cleaned;

-- Layoff Count of Companies with 100% Layoffs:
SELECT *
FROM layoffs_cleaned
WHERE Percentage = 1
ORDER BY Laid_Off_Count DESC;

-- Funds Raised by Companies with 100% Layoffs:
SELECT *
FROM layoffs_cleaned
WHERE Percentage = 1
ORDER BY Funds_Raised DESC;

-- Total Layoffs per Company:
SELECT Company, SUM(Laid_Off_Count) AS Layoff_Count_per_Company
FROM layoffs_cleaned
GROUP BY Company
ORDER BY 2 DESC;

-- Layoff_Count_per_Company_HQ:
SELECT Company, Location_HQ, SUM(Laid_Off_Count) AS Layoff_Count_per_Location_HQ
FROM layoffs_cleaned
GROUP BY Company, Location_HQ
ORDER BY 3 DESC;

-- Layoff_Count_per_Industry:
SELECT Industry, SUM(Laid_Off_Count) AS Layoff_Count_per_Industry
FROM layoffs_cleaned
GROUP BY Industry
ORDER BY 2 DESC;

-- Layoff_Count_per_Location:
SELECT Location_HQ, SUM(Laid_Off_Count) AS Layoff_Count_per_Location
FROM layoffs_cleaned 
GROUP BY Location_HQ 
ORDER BY 2 DESC;

-- Layoff_Count_per_Country:
SELECT Country, SUM(Laid_Off_Count) AS Layoff_Count_per_Country
FROM layoffs_cleaned
GROUP BY Country
ORDER BY 2 DESC;

-- Layoff_Count_per_Year:
SELECT YEAR(`Date`), SUM(Laid_Off_Count) AS Layoff_Count_per_Year
FROM layoffs_cleaned
GROUP BY YEAR(`Date`)
ORDER BY 1 DESC;

-- Layoff_Count_per_Stage:
SELECT Stage, SUM(Laid_Off_Count) AS Layoff_Count_per_Stage
FROM layoffs_cleaned
GROUP BY Stage
ORDER BY 2 DESC;

-- Rolling_Total by every month and year:
WITH Rolling_Total AS (
	SELECT SUBSTRING(`Date`, 1, 7) AS `MONTH`, SUM(Laid_Off_Count) AS Total_layoff
	FROM layoffs_cleaned
	GROUP BY `MONTH`
	ORDER BY 1
)
SELECT `MONTH`, Total_layoff, SUM(Total_layoff) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Rolling_Total by every month per year:
WITH Rolling_Total AS (
	SELECT SUBSTRING(`Date`, 1, 7) AS `MONTH`, SUM(Laid_Off_Count) AS Total_layoff
	FROM layoffs_cleaned
	GROUP BY `MONTH`
	ORDER BY 1
)
SELECT `MONTH`, Total_layoff, SUM(Total_layoff) OVER (PARTITION BY SUBSTRING(`MONTH`, 1, 4) ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Ranking every Company with Total_Layoffs per Year:
WITH Company_Year (Company, Years, Total_Layoffs) AS (
	SELECT Company, YEAR(`Date`), SUM(Laid_Off_Count)
	FROM layoffs_cleaned
	GROUP BY Company, YEAR(`Date`)
)
SELECT *,
DENSE_RANK() OVER (PARTITION BY Years ORDER BY Total_Layoffs DESC) AS Ranking
FROM Company_Year
ORDER BY Ranking;

-- Top Five Ranking Companies with Total_Layoffs per Year:
WITH Company_Year (Company, Years, Total_Layoffs) AS (
	SELECT Company, YEAR(`Date`), SUM(Laid_Off_Count)
	FROM layoffs_cleaned
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