-- Total active and terminated employees
SELECT
	COUNT(Hiredate) TotalHired,
	SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',1,0)) TotalActive_Employee,
	COUNT(Hiredate) - SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',1,0)) TotalTerminated
FROM humanresources;

-- Total Terminated by Performance Rating

SELECT
Performance_Rating,
	SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',0,1))
FROM humanresources
GROUP BY Performance_Rating;

-- Total Employee for each education level
SELECT
	Education_level,
	performance_rating,
	COUNT(employee_ID) OVER(PARTITION BY Education_Level) TotalEmployeeByEducation_Level
FROM humanresources
ORDER BY TotalEmployeeByEducation_Level DESC;

-- The employees that have salary higher than the average sales across all orders
SELECT
*
FROM (
SELECT
    hiredate,
    termdate,
    CONCAT(first_name, ' ' ,last_name) FullName,
    Education_Level,
    Job_Title,
    Performance_Rating,
    salary,
    ROUND(AVG(salary) OVER(), 2) AvgSalary
FROM humanresources
)t 
WHERE salary > AvgSalary 
ORDER BY salary DESC;

-- Ranking salaries for each education level
SELECT
* FROM (
SELECT
    hiredate,
    CONCAT(first_name, ' ' ,last_name) FullName,
    Education_Level,
    Job_Title,
    salary,
    DENSE_RANK() OVER (PARTITION BY education_level ORDER BY salary DESC) AS Ranking
FROM humanresources
ORDER BY salary DESC
)t
WHERE Ranking <= 3;