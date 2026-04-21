-- Project 4: Telco Customer Churn Analysis
-- Phase 1A: Exploratory Queries
-- Purpose: Understand data quality and baseline metrics before analysis

USE telco_churn;

-- Query 1: Overall size and churn rate
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS retained_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers;

-- Query 2: Duplicate check (should return empty)
SELECT CustomerID, COUNT(*) AS occurrences
FROM customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- Query 3: NULL audit across key columns
SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS null_customerID,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS null_tenure,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS null_monthlycharges,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS null_totalcharges,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS null_churn,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS null_contract
FROM customers;
