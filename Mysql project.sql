CREATE DATABASE Capstone;
use Capstone;

-- Objective qs 2.Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. (SQL)

SELECT customerid, surname, estimatedsalary
FROM customerinfo
WHERE EXTRACT(QUARTER FROM BankDOJ) = 4
ORDER BY estimatedsalary DESC
LIMIT 5;

-- Objective qs 3. Calculate the average number of products used by customers who have a credit card. (SQL)

select AVG(NumOfProducts) as AverageProducts 
from bank_churn
where HasCrCard = 1;

-- xObjective qs 5. Compare the average credit score of customers who have exited and those who remain. (SQL)

SELECT Exited, AVG(CreditScore) AS AvgCreditScore
FROM bank_churn
GROUP BY Exited;

-- Objective qs 6. Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)

WITH gender_avg_salary AS (
    SELECT
        ci.genderID,
        ROUND(AVG(ci.estimatedsalary),2) AS avg_salary
    FROM
        customerinfo ci
    GROUP BY
        ci.genderID
),
gender_active_accounts AS (
    SELECT
        ci.genderID,
        COUNT(bc.Isactivemember) AS active_accounts
    FROM
        customerinfo ci
        JOIN bank_churn bc ON ci.customerid = bc.customerid
    WHERE
        bc.Isactivemember = 1
    GROUP BY
        ci.genderID
)
SELECT
    gs.genderID,
    gs.avg_salary,
    gaa.active_accounts
FROM
    gender_avg_salary gs
    INNER JOIN gender_active_accounts gaa ON gs.genderID = gaa.genderID;

--    Objective qs 7. Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)

WITH credit_score_segments AS (
    SELECT
        CASE
            WHEN CreditScore <= 600 THEN 'Low'
            WHEN CreditScore <= 700 THEN 'Medium'
            ELSE 'High'
        END AS credit_score_segment,
        Exited
    FROM
        bank_churn
),
segment_exit_rates AS (
    SELECT
        credit_score_segment,
        AVG(Exited) AS exit_rate
    FROM
        credit_score_segments
    GROUP BY
        credit_score_segment
)
SELECT
    *
FROM
    segment_exit_rates
WHERE
    exit_rate = (SELECT MAX(exit_rate) FROM segment_exit_rates);
    
    --    Objective qs 8. Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)
 
    WITH active_customers AS (
    SELECT
        ci.GeographyID,
        COUNT(bc.Isactivemember) AS active_customers_count
    FROM
        customerinfo ci
        INNER JOIN bank_churn bc ON ci.customerid = bc.Customerid
    WHERE
        bc.Isactivemember = 1
        AND bc.Tenure > 5
    GROUP BY
        ci.GeographyID
)
SELECT
    GeographyID,
    active_customers_count
FROM
    active_customers
WHERE
    active_customers_count = (SELECT MAX(active_customers_count) FROM active_customers);
    
    --    Objective qs  11.	Examine the trend of customer joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.

    SELECT
    EXTRACT(YEAR FROM BankDOJ) AS join_year,
    EXTRACT(MONTH FROM BankDOJ) AS join_month,
    COUNT(*) AS join_count
FROM
    customerinfo
GROUP BY
    EXTRACT(YEAR FROM BankDOJ),
    EXTRACT(MONTH FROM BankDOJ)
ORDER BY
    join_year, join_month;
    
    --     Objective qs 15. Using SQL, write a query to find out the gender wise average income of male and female in each geography id. Also rank the gender according to the average value. (SQL)

WITH gender_avg_income AS (
    SELECT
        GeographyID,
        genderID,
        ROUND(AVG(estimatedsalary),2) AS avg_income,
        RANK() OVER (PARTITION BY GeographyID ORDER BY AVG(estimatedsalary) DESC) AS gender_rank
    FROM
        customerinfo
    GROUP BY
        GeographyID,
        genderID
)
SELECT
    GeographyID,
    genderID,
    avg_income,
    gender_rank
FROM
    gender_avg_income;
    
    --     Objective qs 16. Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).

WITH exited_customers AS (
    SELECT
        ci.customerid,
        ci.age,
        bc.Tenure
    FROM
        customerinfo ci
        INNER JOIN bank_churn bc ON ci.customerid = bc.customerid
    WHERE
        bc.Exited = 1
),
age_brackets AS (
    SELECT
        customerid,
        age,
        CASE
            WHEN age BETWEEN 18 AND 30 THEN '18-30'
            WHEN age BETWEEN 31 AND 50 THEN '31-50'
            ELSE '50+'
        END AS age_bracket
    FROM
        customerinfo
)
SELECT
    age_bracket,
    AVG(Tenure) AS avg_tenure
FROM
    exited_customers ec
    JOIN age_brackets ab ON ec.customerid = ab.customerid
GROUP BY
    age_bracket;
    
--    22. As we can see that the “CustomerInfo” table has the CustomerID and Surname, now if we have to join it with a table where the primary key is also a combination of CustomerID and Surname, come up with a column where the format is “CustomerID_Surname”.

    select concat(ci.customerID, '_', ci.surname) as CustomerID_Surname
    from customerinfo ci
    join bank_churn bc ON ci.CustomerID = bc.customerID;
    
--     23. Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.

    SELECT
    bc.*,
    (SELECT ec.ExitCategory FROM exitCustomer ec WHERE ec.ExitID = bc.Exited) AS ExitCategory
FROM
    Bank_Churn bc;

    
    --    Objective qs  25. Write the query to get the customer ids, their last name and whether they are active or not for the customers whose surname  ends with “on”.

    SELECT
    ci.customerid,
    ci.surname,
    bc.Isactivemember AS active
FROM
    customerinfo ci
    INNER JOIN bank_churn bc ON ci.customerid = bc.customerid
WHERE
    ci.surname LIKE '%on';
    
    -- SUBJECTIVE QUESTIONS
    
    /*  9.	Utilize SQL queries to segment customers based on demographics and account details.*/
    
-- Segment customers based on age groups:
SELECT
    CASE
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '51+'
    END AS age_group, COUNT(*) AS num_customers
FROM customerinfo
GROUP BY age_group;
    
--     Segment customers based on gender and geography:
SELECT GenderID, GeographyID, COUNT(*) AS num_customers
FROM customerinfo
GROUP BY GenderID, GeographyID
ORDER BY GeographyID;

-- Segment customers based on account details:
SELECT Exited, HasCrCard, IsActiveMember, COUNT(*) AS num_customers
FROM bank_churn
GROUP BY Exited, HasCrCard, IsActiveMember;

-- Segment customers based on gender, geography, and churn status:
SELECT GenderID, GeographyID, Exited, COUNT(*) AS num_customers
FROM customerinfo ci
JOIN bank_churn bc ON ci.CustomerID = bc.CustomerID
GROUP BY GenderID, GeographyID, Exited;

-- Segment customers based on age groups and tenure:
SELECT
    CASE
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '51+'
    END AS age_group,
    CASE
        WHEN tenure = 3 THEN '3'
        WHEN tenure = 4 THEN '4'
        WHEN tenure = 5 THEN '5'
        WHEN tenure = 6 THEN '6'
        ELSE '7+'
    END AS tenure_group, COUNT(*) AS num_customers
FROM customerinfo ci
JOIN bank_churn bc ON ci.CustomerID = bc.CustomerID
GROUP BY age_group, tenure_group;

-- 14.	In the “Bank_Churn” table how can you modify the name of “HasCrCard” column to “Has_creditcard”?
ALTER TABLE Bank_Churn
RENAME COLUMN HasCrCard TO Has_creditcard;

    
    







