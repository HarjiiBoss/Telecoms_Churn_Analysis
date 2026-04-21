-- Project 4: Telco Customer Churn Analysis
-- Phase 1D: Risk Pillar
-- Purpose: Quantify structural concentration risk across contracts and services

USE telco_churn;

-- Query 1: Contract type concentration using SUM() OVER()
SELECT
    Contract,
    COUNT(*) AS customers,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) AS customer_share_pct,
    ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue,
    ROUND(SUM(MonthlyCharges) / SUM(SUM(MonthlyCharges)) OVER () * 100, 2) AS revenue_share_pct
FROM customers
GROUP BY Contract;

-- Query 2: Internet service concentration
SELECT
    InternetService,
    COUNT(*) AS customers,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) AS customer_share_pct,
    ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue,
    ROUND(SUM(MonthlyCharges) / SUM(SUM(MonthlyCharges)) OVER () * 100, 2) AS revenue_share_pct,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY InternetService
ORDER BY revenue_share_pct DESC;

-- Query 3: High risk customer profile (top 20 by monthly charge)
SELECT
    CustomerID,
    Contract,
    tenure,
    InternetService,
    MonthlyCharges,
    PaymentMethod,
    Churn,
    CASE
        WHEN Contract = 'Month-to-month'
        AND MonthlyCharges > 70
        AND tenure < 12
        THEN 'High risk'
        ELSE 'Standard'
    END AS risk_flag
FROM customers
ORDER BY MonthlyCharges DESC
LIMIT 20;

-- Query 4: High risk customer count and churn rate
SELECT
    CASE
        WHEN Contract = 'Month-to-month'
        AND MonthlyCharges > 70
        AND tenure < 12
        THEN 'High risk'
        ELSE 'Standard'
    END AS risk_flag,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS already_churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY risk_flag;

-- Query 5: PERCENT_RANK() of customers by monthly charge
SELECT
    CustomerID,
    Contract,
    Churn,
    MonthlyCharges,
    ROUND(PERCENT_RANK() OVER (ORDER BY MonthlyCharges) * 100, 1) AS charge_percentile
FROM customers
ORDER BY MonthlyCharges DESC
LIMIT 20;
