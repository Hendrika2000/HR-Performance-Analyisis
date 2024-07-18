# HR-Performance-Analyisis

## Table of Contents

- [Project Overview](Project-overview)
- [Data Sources](#data-sources)
- [Recommendations](Recommendations)

### Project Overview

This data analysis data project aims to explore historical HR data to identify key factors influencing employee retention and productivity, develop actionable insights to enhance employee satisfaction and optimize recruitment strategies, and create visualizations to effectively communicate findings and support data-driven HR decision-making.


![Screenshot (155)](https://github.com/user-attachments/assets/86556aea-d1ea-476f-b553-5667c85df8e4)

### Data Sources

Sales Data: The primary dataset used for this analysis is the "HumanResources.csv" file, containing information about each sale made by the company.

### Tools

Mysql
Tableau

### Exploratory Data Analysis

KPIs that are most relevant to achieve your HR analysis goals:
Some common KPIs include:
1. Employee Retention Rate: Percentage of employees who remain employed over a certain period.
2. Turnover Rate: Percentage of employees who leave the company within a specific period.
3. Employee Satisfaction: Survey or review results to assess employee satisfaction with their job and work environment.
   

### Data Analysis

Include some interesting code/features worked with
Total active and terminated employees
```sql
SELECT
	COUNT(Hiredate) TotalHired,
	SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',1,0)) TotalActive_Employee,
	COUNT(Hiredate) - SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',1,0)) TotalTerminated
FROM humanresources;
```
Total Terminated by Performance Rating
```sql
SELECT
Performance_Rating,
	SUM(IF(Termdate IS NULL OR TRIM(termdate) = '',0,1))
FROM humanresources
GROUP BY Performance_Rating;
```
Total Employee for each education level
```sql
SELECT
	Education_level,
	performance_rating,
	COUNT(employee_ID) OVER(PARTITION BY Education_Level) TotalEmployeeByEducation_Level
FROM humanresources
ORDER BY TotalEmployeeByEducation_Level DESC;
```
The employees that have salary higher than the average sales across all orders
```sql
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
```
Ranking salaries for each education level
```sql
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
```
### Findings
1. Performance ratings increase according to educational level, with PhD holders having the most excellent ratings, while high school graduates have more ratings indicating a need for improvement
2. Performance rating does not affect the number of terminated employees
3. The Operations Department has the highest total of hires, accounting for 27% of all hires, and 289 employees terminated, which comprises 3% of all terminations.
4. The most common employees are Bachelor's degree holders aged 35-44. It has also been found that age and education level positively impact salary amounts


### Recommendation
Based on the findings, here are some recommendations for HR performance:

1. Enhancing Performance Based on Education: Recommend special development programs to enhance employee performance based on their educational background. For instance, advanced training programs or mentoring approaches for employees with high school education.
2. Focus on Employee Retention: Despite performance ratings not directly affecting the number of terminated employees, suggest improving employee retention programs focusing on other factors like job satisfaction, career development, and work-life balance.
3. Optimizing Recruitment and Retention in the Operations Department: Propose more effective recruitment strategies and retention programs in the Operations Department, considering its high hiring rate and number of terminated employees. This includes reviewing current recruitment processes and possibly strengthening employee development programs in the department.
4. Succession Planning and Career Development: Focus on career development and succession planning for employees with the most common profile of Bachelor's degree holders aged 35-44. This could include leadership development programs, advanced technical training, or clear career paths.
5. Age and Education-Based Compensation: Recommend reviewing compensation policies to ensure that salaries and incentives fairly reflect factors such as employees' age and education level. This can help improve employee satisfaction and retention.
