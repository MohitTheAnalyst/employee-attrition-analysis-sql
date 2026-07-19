
/*==================================================================
                                KPI's
====================================================================*/



-- Total Attrition Rate


SELECT ROUND(SUM(attrition_flag) *100 / COUNT(*), 2) AS total_attrition_rate
FROM emp_attrition;


-- Total Employees left After Attrition
  

SELECT COUNT(attrition_flag) AS total_emp_after_attrition
FROM emp_attrition
WHERE attrition_flag = 0;


-- Total Attrition


SELECT SUM(attrition_flag) AS total_attrition
FROM emp_attrition;


-- Total Employees


SELECT COUNT(*) AS total_emp
FROM emp_attrition;



/*==================================================================
                      Attrition-Contribution
====================================================================*/



-- Attrition contribution based on each department


SELECT department,
       COUNT(*) AS total_emp,
       SUM(attrition_flag) AS total_attrition,
       ROUND(SUM(attrition_flag) *100.0 / COUNT(*), 2) AS department_attrition_rate
FROM emp_attrition
GROUP BY department
ORDER BY department_attrition_rate DESC;

-- Total Attrition contribution from total attrition for each department


SELECT department,
       ROUND(SUM(attrition_flag) *100.0 / (
                           SELECT SUM(attrition_flag) FROM emp_attrition), 2) AS total_attrition_contibution
FROM emp_attrition
GROUP BY department
ORDER BY total_attrition_contibution DESC;



/*==================================================================
                      Attrition-Factors
====================================================================*/



-- Attrition By Overtime (ANLYZES OVERTIME AFFECTION ON ATTRITION)


WITH overtime_group AS 
(
  SELECT CASE 
             WHEN avg_overtime_hrs_week >= 0 AND avg_overtime_hrs_week <= 5 THEN '1-5 hrs'
             WHEN avg_overtime_hrs_week > 5 AND avg_overtime_hrs_week <= 10 THEN '5-10 hrs'
             WHEN avg_overtime_hrs_week > 10 AND avg_overtime_hrs_week <= 15 THEN '10-15 hrs'
             WHEN avg_overtime_hrs_week > 15 AND avg_overtime_hrs_week <= 20 THEN '15-20 hrs'
             ELSE 'above 20 hrs'
        END AS avg_overtime_hrs,
        attrition_flag
  FROM  emp_attrition
)
  SELECT avg_overtime_hrs,
         COUNT(*) AS total_employees,
         SUM(attrition_flag) AS total_attrition,
         ROUND(SUM(attrition_flag) * 100.0 / COUNT(*), 2) AS attrition_percentage
  FROM overtime_group
  GROUP BY avg_overtime_hrs
  ORDER BY attrition_percentage DESC ;


-- Attrition By Annual Training Hours (ANALYZES WHETHER HIGHER TRAINING HOURS AFFECTING ATTRITION)


WITH training_hrs_group AS 
(
  SELECT CASE 
             WHEN training_hours_annual >= 0 AND training_hours_annual <= 50 THEN '1-50'
             WHEN training_hours_annual > 50 AND training_hours_annual <= 100 THEN '50-100'
             ELSE 'above 100'
         END AS annual_training_hrs,
         attrition_flag
  FROM   emp_attrition
)
  SELECT annual_training_hrs,
         COUNT(*) AS total_emp,
         SUM(attrition_flag) AS total_attrition,
         ROUND(SUM(attrition_flag) *100.0 / COUNT(*),2) AS attrition_percentage
  FROM training_hrs_group
  GROUP BY annual_training_hrs
  ORDER BY attrition_percentage DESC;


-- Attrition by Performance rating (IDENTIFIES RELATION BETWEEN PERFORMANCE RATING AND ATTRITION)


WITH performance_group AS 
(
  SELECT CASE 
             WHEN performance_rating >=0 AND performance_rating <= 1 THEN 'Critical (0-1)'
             WHEN performance_rating > 1 AND performance_rating <= 2 THEN 'Not Bad (1-2)'
             WHEN performance_rating > 2 AND performance_rating <= 3 THEN 'Average (2-3)'
             WHEN performance_rating > 3 AND performance_rating <= 4 THEN 'Good (3-4)'
             ELSE 'Excellent (4-5)'
         END AS emp_performance_rating,
         attrition_flag
  FROM emp_attrition
)
  SELECT emp_performance_rating,
         COUNT(*) AS total_employees,
         SUM(attrition_flag) AS total_attrition,
         ROUND(SUM(attrition_flag) *100.0 / COUNT(*),2) AS attrition_percentage
  FROM performance_group
  GROUP BY emp_performance_rating
  ORDER BY attrition_percentage DESC;


-- Attrition by role level (ANALYZES WHICH ROLE HAS MORE ATTRITION)


SELECT role_level,
       COUNT(*) AS total_emp,
       SUM(attrition_flag) AS total_attrition,
       ROUND(SUM(attrition_flag) * 100.0 / COUNT(*),2) AS attrition_percentage
FROM emp_attrition
GROUP BY role_level
ORDER BY attrition_percentage DESC;


-- Attrition by salary band (ANALYZES WHICH SALARY BAND GROUP AFFECTS ATTRITION)


SELECT salary_band,
       COUNT(*) AS total_emp,
       SUM(attrition_flag) AS total_attrition,
       ROUND(SUM(attrition_flag) * 100.0 / COUNT(*),2) AS attrition_percentage
FROM emp_attrition
GROUP BY salary_band
ORDER BY attrition_percentage DESC;



/*==================================================================
                     Multi-Attrition-Factors
====================================================================*/



-- Tenure and role_level Attrition (ANALYZES WHICH ROLE IS HIGHLY AFFECTED BY ATTRITION OVER A SPECIFIC PERIOD OF TIME)

WITH tenure_group AS 
(
  SELECT CASE 
             WHEN tenure_years >= 0 AND tenure_years <=5 THEN '1-5 years'
             WHEN tenure_years > 5 AND tenure_years <=10 THEN '5-10 years'
             WHEN tenure_years > 10 AND tenure_years <=15 THEN '10-15 years'
             WHEN tenure_years > 15 AND tenure_years <20 THEN '15-20 years'
             WHEN tenure_years > 20 AND tenure_years <=25 THEN '20-25 years'
             ELSE 'above 25 years'
         END AS emp_tenure,
               attrition_flag,
               role_level
  FROM   emp_attrition
)
  SELECT emp_tenure,
         role_level,
         COUNT(*) AS total_emp,
         SUM(attrition_flag) AS total_attrition,
         ROUND(SUM(attrition_flag) *100.0 / COUNT(*),2) AS attrition_percentage
  FROM tenure_group
  GROUP BY emp_tenure, role_level
  ORDER BY role_level, attrition_percentage DESC ;


-- Tenure and job satisfaction score (ANALYZES WHETHER JOB SATISFACTION SCORE AFFECTING ATTRITION OVER A PERIOD OF TIME)


WITH tenure_group AS 
(
  SELECT CASE 
             WHEN tenure_years >= 0 AND tenure_years <=5 THEN '1-5 years'
             WHEN tenure_years > 5 AND tenure_years <=10 THEN '5-10 years'
             WHEN tenure_years > 10 AND tenure_years <=15 THEN '10-15 years'
             WHEN tenure_years > 15 AND tenure_years <20 THEN '15-20 years'
             WHEN tenure_years > 20 AND tenure_years <=25 THEN '20-25 years'
             ELSE 'above 25 years'
         END AS emp_tenure,
                job_satisfaction_score,
                attrition_flag
   FROM emp_attrition
)
  SELECT emp_tenure,
         ROUND(AVG(job_satisfaction_score),2) AS avg_job_satisfaction_score,
         COUNT(*) AS total_emp,
         SUM(attrition_flag) AS total_attrition,
         ROUND(SUM(attrition_flag) *100.0 /COUNT(*), 2) AS attrition_percentage
FROM tenure_group
GROUP BY emp_tenure
ORDER BY attrition_percentage DESC ;


-- Tenure and promotion (ANALYZES WHETHER LATE PROMOTIONS CAUSING ATTRITION OVER YEARS)

WITH tenure_group AS 
(
  SELECT CASE 
             WHEN tenure_years >= 0 AND tenure_years <=5 THEN '1-5 years'
             WHEN tenure_years > 5 AND tenure_years <=10 THEN '5-10 years'
             WHEN tenure_years > 10 AND tenure_years <=15 THEN '10-15 years'
             WHEN tenure_years > 15 AND tenure_years <20 THEN '15-20 years'
             WHEN tenure_years > 20 AND tenure_years <=25 THEN '20-25 years'
             ELSE 'above 25 years'
         END AS emp_tenure,
                last_promotion_years_ago,
                attrition_flag
  FROM emp_attrition
)
  SELECT emp_tenure,
         ROUND(AVG(last_promotion_years_ago),2)AS avg_yrs_since_last_promotion,
         COUNT(*) AS total_emp,
         SUM(attrition_flag) AS total_attrition,
         ROUND(SUM(attrition_flag) *100.0 /COUNT(*), 2) AS attrition_percentage
  FROM tenure_group
  GROUP BY emp_tenure
  ORDER BY attrition_percentage DESC;


-- Tenure and work life balance score (ANALYZES WHETHER LOWER WORKLIFE BALANCE INDICATING HIGHER ATTRITION AFTER A SPECIFIC PERIOD)


SELECT CASE 
           WHEN tenure_years >= 0 AND tenure_years <=5 THEN '1-5 years'
           WHEN tenure_years > 5 AND tenure_years <=10 THEN '5-10 years'
           WHEN tenure_years > 10 AND tenure_years <=15 THEN '10-15 years'
           WHEN tenure_years > 15 AND tenure_years <20 THEN '15-20 years'
           WHEN tenure_years > 20 AND tenure_years <=25 THEN '20-25 years'
           ELSE 'above 25 years'
       END AS emp_tenure,
       ROUND(AVG(work_life_balance_score),2)AS avg_work_life_balance_score,
         COUNT(*) AS total_emp,
         SUM(attrition_flag) AS total_attrition,
       ROUND(SUM(attrition_flag) *100.0 /COUNT(*), 2) AS attrition_percentage
FROM emp_attrition
GROUP BY emp_tenure
ORDER BY attrition_percentage DESC;




/*==================================================================
                      Employee-Risk-Profile
====================================================================*/



WITH tenure_group AS 
(
  SELECT CASE 
             WHEN tenure_years >= 0 AND tenure_years <=5 THEN '1-5 years'
             WHEN tenure_years > 5 AND tenure_years <=10 THEN '5-10 years'
             WHEN tenure_years > 10 AND tenure_years <=15 THEN '10-15 years'
             WHEN tenure_years > 15 AND tenure_years <20 THEN '15-20 years'
             WHEN tenure_years > 20 AND tenure_years <=25 THEN '20-25 years'
             ELSE 'above 25 years'
         END AS emp_tenure, *
  FROM emp_attrition
),
overtime_comparison AS 
(
  SELECT CASE 
             WHEN avg_overtime_hrs_week >= 0 AND avg_overtime_hrs_week <= 5 THEN '1-5 hrs'
             WHEN avg_overtime_hrs_week > 5 AND avg_overtime_hrs_week <= 10 THEN '5-10 hrs'
             WHEN avg_overtime_hrs_week > 10 AND avg_overtime_hrs_week <= 15 THEN '10-15 hrs'
             WHEN avg_overtime_hrs_week > 15 AND avg_overtime_hrs_week <= 20 THEN '15-20 hrs'
             ELSE 'above 20 hrs'
        END AS grouped_avg_overtime_hrs, *
  FROM tenure_group
)
  SELECT emp_tenure,
         department,
         role_level,
         grouped_avg_overtime_hrs,
         ROUND(AVG(last_promotion_years_ago), 2) AS avg_promotion_tenure,
         ROUND(AVG(job_satisfaction_score), 2) AS avg_job_satisfaction_score,
         ROUND(AVG(work_life_balance_score), 2) AS avg_work_life_balance_score,
         ROUND(SUM(attrition_flag) *100.0 / COUNT(*),2 ) AS attrition_percentage
  FROM overtime_comparison
  GROUP BY emp_tenure, role_level, grouped_avg_overtime_hrs
  ORDER BY grouped_avg_overtime_hrs DESC, 
           avg_promotion_tenure DESC, 
           attrition_percentage DESC,
           avg_job_satisfaction_score, 
           avg_work_life_balance_score
  LIMIT 10;

