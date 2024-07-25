1. Employee Demographics:

-- Age Distribution:
SELECT 
    TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) AS age, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY age;

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

-- Gender Distribution
SELECT 
    gender, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY gender;

-- Education Level Distribution
SELECT 
    education_level, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY education_level;


2. Job and Department Analysis:

-- Job Title Distribution
SELECT 
    job_title, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY job_title;

-- Department Distribution
SELECT 
    department, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY department;

3. Salary Analysis

-- Salary Distribution:
SELECT 
    salary, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY salary;

-- Average Salary by Department:
SELECT 
    department, 
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;

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

4. Performance Analysis
-- Analyze the distribution of employees' performance ratings
SELECT 
    performance_rating, 
    COUNT(*) AS number_of_employees
FROM humanresources
GROUP BY performance_rating;

-- Average Performance Rating by Department:
SELECT 
    department, 
    AVG(performance_rating) AS average_performance_rating
FROM humanresources
GROUP BY department;

5. Turnover Analysis
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

-- Total Terminated by Performance Rating
SELECT
Performance_Rating,
	SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',0,1))
FROM humanresources
GROUP BY Performance_Rating;

-- Analyze the number of terminated employee by gender
SELECT 
    gender, 
    COUNT(*) AS number_of_resignations
FROM humanresources
WHERE termdate IS NOT NULL
GROUP BY gender;

-- Analyze the distribution of job positions within the company and the total of terminated by job positions
SELECT 
    job_title, 
    COUNT(*) AS number_of_employees,
    (COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END))
FROM humanresources
GROUP BY job_title;

-- Analyzes the number of terminated employee by age groups
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


-- Total number of employees and the number of terminated employee by age groups
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

6. Hiring Trends
-- Number of Hiring per Year
SELECT 
    YEAR(hiredate) AS hire_year, 
    COUNT(*) AS number_of_hires
FROM humanresources
GROUP BY hire_year;

-- Number of Hires per Month
SELECT 
    YEAR(hiredate) AS hire_year,
    MONTH(hiredate) AS hire_month,
    COUNT(*) AS number_of_hires
FROM humanresources
GROUP BY hire_year, hire_month
ORDER BY hire_year, hire_month;

-- Hiring Trends by Department
-- Number of Hires per Department per Year
SELECT 
    YEAR(hiredate) AS hire_year,
    department,
    COUNT(*) AS number_of_hires
FROM humanresources
GROUP BY hire_year, department
ORDER BY hire_year, department;

-- Hiring Trends by Job Title
-- Number of Hires per Job Title per Year
SELECT 
    YEAR(hiredate) AS hire_year,
    job_title,
    COUNT(*) AS number_of_hires
FROM humanresources
GROUP BY hire_year, job_title
ORDER BY hire_year, job_title;

-- Average Tenure before Hiring
SELECT 
    YEAR(hiredate) AS hire_year,
    AVG(DATEDIFF(CURDATE(), hiredate) / 365) AS average_tenure_years
FROM humanresources
GROUP BY hire_year;

-- Hiring Trends by Gender
-- Number of Hires by Gender per Year
SELECT 
    YEAR(hiredate) AS hire_year,
    gender,
    COUNT(*) AS number_of_hires
FROM humanresources
GROUP BY hire_year, gender
ORDER BY hire_year, gender;

-- Retention Rate of New Hires
SELECT 
    YEAR(hiredate) AS hire_year,
    COUNT(CASE WHEN termdate IS NULL OR DATEDIFF(CURDATE(), hiredate) < 365 THEN 1 END) AS retained_employees,
    COUNT(*) AS total_hired,
    (COUNT(CASE WHEN termdate IS NULL OR DATEDIFF(CURDATE(), hiredate) < 365 THEN 1 END) / COUNT(*)) * 100 AS retention_rate
FROM humanresources
GROUP BY hire_year;
