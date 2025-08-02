CREATE database project;

USE project;

SELECT *
FROM bajaj
;

SELECT *
FROM superstore
;

SELECT *
FROM hrdata
;

SELECT *
FROM emptable
;


-- Data Cleaning
 
SET SQL_SAFE_UPDATES = 0;

UPDATE superstore
SET `Order Date` = str_to_date(`Order Date`,'%m/%d/%Y')
;

UPDATE superstore
SET `Ship Date` = str_to_date(`Ship Date`,'%m/%d/%Y')
;

UPDATE superstore
SET Sales = REPLACE(Sales,'$','')
;

UPDATE superstore
SET Sales = REPLACE(Sales,',','')
;

UPDATE superstore
SET Profit = REPLACE(profit,'$','')
;

UPDATE superstore
SET Profit = REPLACE(profit,'(','-')
;

UPDATE superstore
SET Profit = REPLACE(profit,')','')
;

UPDATE superstore
SET Profit = REPLACE(profit,',','')
;

UPDATE bajaj
SET Date = str_to_date(Date,'%d-%M-%Y')
;

ALTER table hrdata
RENAME column ï»¿id TO id
;

ALTER table hrdata
ADD COLUMN full_name VARCHAR(50) AFTER last_name 
;

ALTER table hrdata
DROP COLUMN full_name
;

UPDATE hrdata
SET full_name =
		CONCAT(first_name,' ', last_name)
;

SELECT birthdate,
CASE
	WHEN birthdate LIKE '%-%-%' THEN str_to_date(birthdate,'%d-%m-%Y')
    WHEN birthdate LIKE '%/%/%' THEN str_to_date(birthdate,'%m/%d/%Y')
ELSE NULL 
END AS parsed_date
FROM hrdata
;

ALTER TABLE hrdata
ADD COLUMN formatted_birthdate DATE AFTER birthdate
;

UPDATE hrdata
SET formatted_birthdate = CASE
	WHEN birthdate LIKE '%-%-%' THEN str_to_date(birthdate,'%d-%m-%Y')
    WHEN birthdate LIKE '%/%/%' THEN str_to_date(birthdate,'%m/%d/%Y')
ELSE NULL 
END
;

SELECT hire_date,
CASE
	WHEN hire_date LIKE '%-%-%' THEN str_to_date(hire_date,'%d-%m-%Y')
    WHEN hire_date LIKE '%/%/%' THEN str_to_date(hire_date,'%m/%d/%Y')
ELSE NULL 
END AS parsed_date
FROM hrdata
;

UPDATE hrdata
SET hire_date = CASE
	WHEN hire_date LIKE '%-%-%' THEN str_to_date(hire_date,'%d-%m-%Y')
    WHEN hire_date LIKE '%/%/%' THEN str_to_date(hire_date,'%m/%d/%Y')
ELSE NULL 
END
;

-- Superstore

-- QUESTION 1
SELECT
	`Sub-Category`,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY `Sub-Category`
HAVING SUM(Quantity) > (SELECT
			AVG(Quantity)
			FROM superstore)
AND SUM(Profit) <= 0
ORDER BY Total_Quantity DESC
;

-- QUESTION 2
SELECT
	Market,
    ROUND(AVG(Discount),2) AS AVG_Discount,
    ROUND(AVG(Profit),2) AS Average_Profit
FROM superstore
GROUP BY Market
;

-- QUESTION 3
SELECT
	Segment,
    ROUND(AVG(Discount),2) AS AVG_Discount,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY Segment
;

-- QUESTION 4
SELECT
	City,
    ROUND(SUM(Quantity),2) AS Total_Quantity,
    ROUND(SUM(Profit),2) AS Total_Poofit
FROM superstore
GROUP BY City
ORDER BY Total_Quantity DESC
;

-- QUESTION 5
SELECT
	Market,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    ROUND((SUM(Sales) - SUM(Profit)),2) AS Profit_Disparity
FROM superstore
GROUP BY Market
ORDER BY Profit_DIsparity DESC
;

-- QUESTION 6
SELECT
	Region,
    Segment,
    AVG(DATEDIFF(`Order Date`, `Ship Date`)) AS AVG_Ship_Delay
FROM superstore
GROUP BY Region, Segment
ORDER BY AVG_Ship_Delay DESC
;

-- QUESTION 7
SELECT
	YEAR(`Order Date`) AS Order_Year,
   	QUARTER(`Order Date`) AS Order_Quarter,
    	ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY
	YEAR(`Order Date`),
  	QUARTER(`Order Date`)
ORDER BY Total_Profit DESC
;

-- QUESTION 8
SELECT
	MONTHNAME(`Order Date`) AS Order_Month,
    	ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY MONTHNAME(`Order Date`)
ORDER BY Total_Profit
;


-- bajaj-2003

-- QUESTION 9
SELECT
	Date,
    DAYNAME(Date),
    `Prev Close`,
    `Open Price`,
    `Close Price`
    FROM bajaj
    WHERE `Open Price` < `Prev Close`
    AND `Close Price` > `Open Price`
    ;
    
    -- COUNT PER DAY
    SELECT
    DAYNAME(Date) AS Day_of_week,
    COUNT(*) AS Occurences 
    FROM bajaj
    WHERE `Open Price` < `Prev Close`
    AND `Close Price` > `Open Price`
    GROUP BY DAYNAME(Date)
    ORDER BY Occurences DESC
    ;
    
-- QUESTION 10
SELECT
	Date,
    `High Price`
FROM bajaj
WHERE `High Price` >= 1000
;

-- QUESTION 11
SELECT
	Date,
    DAYNAME(Date),
    `Total Traded Quantity`,
    Turnover
FROM bajaj
WHERE `Total Traded Quantity` < 1000 
AND Turnover > 50000
;

    -- COUNT PER DAY
 SELECT
    DAYNAME(Date) AS Day_of_week,
    COUNT(*) AS Occurences
FROM bajaj
WHERE `Total Traded Quantity` < 1000 
AND Turnover > 50000
GROUP BY DAYNAME(Date)
ORDER BY Occurences DESC
;
   
-- QUESTION 12
SELECT
	Date,
        `High Price`,
        `Low Price`,
        ROUND((`High Price` - `Low Price`),2) AS Price_Range
FROM bajaj
WHERE (`High Price` - `Low Price`) > 100
;

-- QUESTION 13
SELECT
	YEAR(Date) AS Year,
    ROUND(AVG(`Close Price`),2) AS AVG_Closing_Price
FROM bajaj
GROUP BY Year
ORDER BY Year
;

-- QUESTION 14
SELECT
	YEAR(Date) AS Year,
    SUM(`Total Traded Quantity`) AS `Total_Shares_Traded`
FROM bajaj
GROUP BY Year
ORDER BY Year
;

-- QUESTION 15
SELECT
	Year,
    ROUND(AVG(Turnover),2) AS AVG_Turnover
		FROM (
			SELECT
			YEAR(Date) As Year,
			Turnover
                	FROM bajaj
			 ) AS Yearly
GROUP BY Year
ORDER BY AVG_Turnover DESC
LIMIT 1
;

-- QUESTION 16
SELECT
	Year,
    ROUND(AVG(`Total Traded Quantity`),2) AS AVG_Traded_Quantity
		FROM (
			SELECT
			YEAR(Date) As Year,
			`Total Traded Quantity`
                	FROM bajaj
			 ) AS Yearly
GROUP BY Year
HAVING AVG(`Total Traded Quantity`) < 5000
;

-- QUESTION 17
SELECT
	YEAR(Date) AS Year,
    MONTHNAME(Date) AS Month,
    ROUND(AVG(`Close Price`),2) AS AVG_Close_Price
FROM bajaj
GROUP BY Month, Year  
HAVING AVG(`Close Price`) > 500
ORDER BY Month 
;


-- hrdata

-- QUESTION 18
SELECT
	gender,
    COUNT(*) AS employee_count
FROM hrdata
GROUP BY gender
;

-- QUESTION 19
SELECT 
	department,
    COUNT(*) AS remote_employees
FROM hrdata
WHERE location = 'Remote'
GROUP BY department
;

-- QUESTION 20
SELECT 
	location,
	COUNT(*) AS employee_count
FROM hrdata
GROUP BY location
;

-- QUESTION 21a
SELECT
	race,
    COUNT(*) AS employee_count
FROM hrdata
GROUP BY race
;

-- QUESTION 21b
SELECT 
	location_state,
	COUNT(*) AS employee_count
FROM hrdata
GROUP BY location_state
ORDER BY employee_count DESC
;

-- QUESTION 22
SELECT
	COUNT(*) AS terminated_employees
FROM hrdata
WHERE termdate IS NOT NULL
AND termdate <> ''
;

-- QUESTION 23
SELECT 
	full_name,
    hire_date,
    DATEDIFF(CURDATE(),hire_date) AS days_served
FROM hrdata
WHERE termdate IS NULL OR termdate = ''
ORDER BY days_served DESC
LIMIT 1;

-- QUESTION 24
SELECT 
	race,
    COUNT(*) AS terminated_count
FROM hrdata
WHERE termdate IS NOT NULL
AND termdate <> ''
GROUP BY race
;

-- QUESTION 25
SELECT
	CASE
	WHEN TIMESTAMPDIFF(YEAR, formatted_birthdate, CURDATE()) < 30 THEN 'Under 30'
        WHEN TIMESTAMPDIFF(YEAR, formatted_birthdate, CURDATE()) BETWEEN 30 AND 39 THEN '30-39'
        WHEN TIMESTAMPDIFF(YEAR, formatted_birthdate, CURDATE()) BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
	END AS age_group,
    COUNT(*) AS employee_count
FROM hrdata
GROUP BY age_group
ORDER BY age_group
;

-- QUESTION 26
SELECT 
	YEAR(hire_date) AS hire_year,
    COUNT(*) AS hires
FROM hrdata
GROUP BY hire_year
ORDER BY hire_year
;

-- QUESTION 27
SELECT 
	department,
    ROUND(AVG(DATEDIFF(curdate(),hire_date)/365),2) AS Average_years_tenure
FROM hrdata
WHERE termdate IS NULL OR termdate = ''
GROUP BY department
ORDER BY Average_years_tenure DESC
;

-- QUESTION 28
SELECT
	AVG(DATEDIFF(
			IF(termdate IS NULL OR termdate = '', CURDATE(), STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')),
					hire_date)
                    	/365) AS avg_employed_years 
FROM hrdata
;

-- QUESTION 29
SELECT
	department,
	SUM(
		CASE
		WHEN termdate IS NOT NULL AND termdate <> ''
            THEN 1 ELSE 0 END) 
            * 100 / COUNT(*) AS turnover_rate
FROM hrdata
GROUP BY department
ORDER BY turnover_rate DESC
LIMIT 1
;

-- emptable

-- QUESTION 30
SELECT 
	department
FROM (
	  SELECT
		department,
        COUNT(*) AS total_employees,
        SUM(
		CASE
		WHEN formatted_hire_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
                THEN 1 ELSE 0
                END) AS recent_hires
		FROM emptable
        GROUP BY department
	   ) AS dept_summary
WHERE (recent_hires / total_employees) * 100 > 50
;
