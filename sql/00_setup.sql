-- Project 4: Telco Customer Churn Analysis
-- Phase 0: Environment Setup
-- Tool: MySQL Workbench

-- Step 1: Create schema
CREATE SCHEMA telco_churn;

-- Step 2: Set default schema
USE telco_churn;

-- Step 3: Fix TotalCharges blank values
UPDATE telco_churn.customers
SET TotalCharges = NULL
WHERE TotalCharges = ' ';

-- Step 4: Convert TotalCharges to DECIMAL
ALTER TABLE telco_churn.customers
MODIFY COLUMN TotalCharges DECIMAL(10,2);

-- Step 5: Verify NULL count (should return 11)
SELECT COUNT(*) 
FROM telco_churn.customers 
WHERE TotalCharges IS NULL;
