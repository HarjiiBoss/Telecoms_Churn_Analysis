-- Project 4: Telco Customer Churn Analysis
-- Phase 1E: Advanced Multi-Dimension Queries
-- Purpose: Combine all three pillars into sophisticated multi-factor analysis
-- SQL concepts: CTEs, window functions, ROW_NUMBER(), LAG(), RANK()

USE telco_churn;

-- Query 1: Multi-dimension churn breakdown - contract x tenure band x revenue tier
WITH segmented AS (
    SELECT
        CustomerID,
        Churn,
        Contract,
        CASE
            WHEN tenure BETWEEN 0 AND 12  THEN '0-12 months'
            WHEN tenure BETWEEN 13 AND 36 THEN '13-36 months'
            ELSE '37+ months'
        END AS tenure_band,
        CASE
            WHEN MonthlyCharges < 35 THEN 'Low value'
            WHEN MonthlyCharges < 70 THEN 'Mid value'
            ELSE 'High value'
        END AS revenue_tier
    FROM customers
)
SELECT
    Contract,
    tenure_band,
    revenue_tier,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM segmented
GROUP BY Contract, tenure_band, revenue_tier
ORDER BY churn_rate_pct DESC
LIMIT 10;

-- Query 2: Estimated customer lifetime value by contract type
SELECT
    Contract,
    Churn,
    ROUND(AVG(tenure), 1) AS avg_tenure,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly,
    ROUND(AVG(tenure) * AVG(MonthlyCharges), 2) AS estimated_ltv
FROM customers
GROUP BY Contract, Churn
ORDER BY estimated_ltv DESC;

-- Query 3: ROW_NUMBER() - top 20 highest value churned customers
WITH ranked_churned AS (
    SELECT
        CustomerID,
        Contract,
        tenure,
        MonthlyCharges,
        TotalCharges,
        ROW_NUMBER() OVER (ORDER BY TotalCharges DESC) AS value_rank
    FROM customers
    WHERE Churn = 'Yes'
    AND TotalCharges IS NOT NULL
)
SELECT * FROM ranked_churned
WHERE value_rank <= 20;

-- Query 4: LAG() - churn rate change between tenure cohorts
WITH cohort_churn AS (
    SELECT
        CASE
            WHEN tenure BETWEEN 0 AND 12  THEN '1. 0-12 months'
            WHEN tenure BETWEEN 13 AND 24 THEN '2. 13-24 months'
            WHEN tenure BETWEEN 25 AND 36 THEN '3. 25-36 months'
            WHEN tenure BETWEEN 37 AND 48 THEN '4. 37-48 months'
            ELSE '5. 49+ months'
        END AS tenure_cohort,
        ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
    FROM customers
    GROUP BY tenure_cohort
)
SELECT
    tenure_cohort,
    churn_rate_pct,
    LAG(churn_rate_pct) OVER (ORDER BY tenure_cohort) AS prev_cohort_churn_rate,
    ROUND(churn_rate_pct - LAG(churn_rate_pct) OVER (ORDER BY tenure_cohort), 2) AS churn_rate_change
FROM cohort_churn;

-- Query 5: Perfect storm - all four high-churn signals combined
SELECT
    Contract,
    InternetService,
    PaymentMethod,
    CASE
        WHEN tenure BETWEEN 0 AND 12  THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 36 THEN '13-36 months'
        ELSE '37+ months'
    END AS tenure_band,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
WHERE Contract = 'Month-to-month'
AND InternetService = 'Fiber optic'
AND PaymentMethod = 'Electronic check'
GROUP BY Contract, InternetService, PaymentMethod, tenure_band
ORDER BY churn_rate_pct DESC;
