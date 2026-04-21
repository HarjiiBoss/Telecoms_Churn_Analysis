-- Project 4: Telco Customer Churn Analysis
-- Phase 1B: Customer Pillar
-- Purpose: Identify who is churning and which segments are most at risk

USE telco_churn;

-- Query 1: Churn rate by contract type
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- Query 2: Churn rate by tenure band
SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12  THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 36 THEN '13-36 months'
        ELSE '37+ months'
    END AS tenure_band,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY tenure_band
ORDER BY churn_rate_pct DESC;

-- Query 3: Churn rate by internet service
SELECT
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;

-- Query 4: Average tenure - churned vs retained
SELECT
    Churn,
    ROUND(AVG(tenure), 1) AS avg_tenure_months,
    ROUND(MIN(tenure), 0) AS min_tenure,
    ROUND(MAX(tenure), 0) AS max_tenure
FROM customers
GROUP BY Churn;

-- Query 5: Churn rate by payment method
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;

-- Query 6: RANK() - contract types ranked by churn rate
WITH churn_by_contract AS (
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
        ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
    FROM customers
    GROUP BY Contract
)
SELECT
    Contract,
    total_customers,
    churned,
    churn_rate_pct,
    RANK() OVER (ORDER BY churn_rate_pct DESC) AS churn_rank
FROM churn_by_contract;
