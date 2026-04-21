-- Project 4: Telco Customer Churn Analysis
-- Phase 1C: Revenue Pillar
-- Purpose: Quantify revenue at risk and identify where revenue is concentrated

USE telco_churn;

-- Query 1: Average monthly charges - churned vs retained
SELECT
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(MIN(MonthlyCharges), 2) AS min_charge,
    ROUND(MAX(MonthlyCharges), 2) AS max_charge,
    ROUND(STDDEV(MonthlyCharges), 2) AS std_dev_charges
FROM customers
GROUP BY Churn;

-- Query 2: Revenue at risk
SELECT
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS monthly_revenue_lost,
    ROUND(SUM(CASE WHEN Churn = 'No'  THEN MonthlyCharges ELSE 0 END), 2) AS monthly_revenue_retained,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_charges,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) / SUM(MonthlyCharges) * 100, 2) AS revenue_at_risk_pct
FROM customers;

-- Query 3: Revenue by contract type
SELECT
    Contract,
    COUNT(*) AS customers,
    ROUND(SUM(TotalCharges), 2) AS total_revenue,
    ROUND(AVG(TotalCharges), 2) AS avg_revenue_per_customer,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customers
WHERE TotalCharges IS NOT NULL
GROUP BY Contract
ORDER BY total_revenue DESC;

-- Query 4: Revenue tiers using CTE
WITH revenue_tiers AS (
    SELECT
        CustomerID,
        Churn,
        MonthlyCharges,
        CASE
            WHEN MonthlyCharges < 35 THEN 'Low value'
            WHEN MonthlyCharges < 70 THEN 'Mid value'
            ELSE 'High value'
        END AS revenue_tier
    FROM customers
)
SELECT
    revenue_tier,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM revenue_tiers
GROUP BY revenue_tier
ORDER BY avg_monthly_charge DESC;

-- Query 5: Cumulative revenue by tenure using SUM() OVER()
SELECT
    tenure,
    COUNT(*) AS customers,
    ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue,
    ROUND(SUM(SUM(MonthlyCharges)) OVER (ORDER BY tenure), 2) AS cumulative_revenue
FROM customers
GROUP BY tenure
ORDER BY tenure;
