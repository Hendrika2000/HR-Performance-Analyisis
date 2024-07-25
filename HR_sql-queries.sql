-- Total active and terminated employees
SELECT
	COUNT(Hiredate) TotalHired,
	SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',1,0)) TotalActive_Employee,
	COUNT(Hiredate) - SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',1,0)) TotalTerminated
FROM humanresources;

-- Percentage of employees who have terminated from the total number of employees.
SELECT 
    (COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END) / COUNT(*)) * 100 AS turnover_rate
FROM humanresources;

-- Analyze the distribution of employees' performance ratings
SELECT 
    performance_rating, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY performance_rating;

-- Total Terminated by Performance Rating
SELECT
Performance_Rating,
	SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',0,1))
FROM humanresources
GROUP BY Performance_Rating;

-- Look at the gender distribution within the company.
SELECT 
    gender, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY gender;

-- Analyze the number of resignations by gender
SELECT 
    gender, 
    COUNT(*) AS number_of_resignations
FROM humanresources
WHERE termdate IS NOT NULL
GROUP BY gender;

-- Total Employee for each education level
SELECT
	Education_level,
	performance_rating,
	COUNT(employee_ID) OVER(PARTITION BY Education_Level) TotalEmployeeByEducation_Level
FROM humanresources
ORDER BY TotalEmployeeByEducation_Level DESC;

-- Analyze the distribution of job positions within the company and the total of terminated by job positions
SELECT 
    job_title, 
    COUNT(*) AS number_of_employees,
    (COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END))
FROM humanresources
GROUP BY job_title;

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

-- Employee Distribution by Age Groups
SELECT
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) < 25 THEN '<25'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 25 AND 34 THEN '25-34'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 35 AND 44 THEN '35-44'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 45 AND 54 THEN '45-54'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 THEN '55+'
        ELSE ''
    END AS age_groups,
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY age_groups;

-- Analyzes the number of resignations by age groups
SELECT
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) < 25 THEN '<25'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 25 AND 34 THEN '25-34'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 35 AND 44 THEN '35-44'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 45 AND 54 THEN '45-54'
        WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 THEN '55+'
        ELSE ''
    END AS age_groups,
    COUNT(*) AS number_of_resignations
FROM humanresources
WHERE termdate IS NOT NULL
GROUP BY age_groups;


-- Total number of employees and the number of terminated by age groups
SELECT
    age_groups,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) AS number_of_terminated
FROM (
    SELECT
        CASE 
            WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) < 25 THEN '<25'
            WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 25 AND 34 THEN '25-34'
            WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 35 AND 44 THEN '35-44'
            WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) BETWEEN 45 AND 54 THEN '45-54'
            WHEN TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 55 THEN '55+'
            ELSE ''
        END AS age_groups,
        termdate
    FROM humanresources
) AS grouped
GROUP BY age_groups;
