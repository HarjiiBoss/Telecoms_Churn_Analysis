# Phase 0 — Environment Setup

**Tool:** MySQL Workbench (Local Instance 3306)
**Mac Note:** MySQL Workbench displayed a "Warning - not supported" tab notice — this is a known Mac compatibility notice and did not affect any operations.

---

## Objective

Set up the MySQL environment, create the project schema, import the Telco Customer Churn dataset, and validate data integrity before writing any analytical queries.

---

## Steps Completed

### 1. Connection Verified
- Opened MySQL Workbench and confirmed local instance 3306 was active
- Query editor confirmed working

### 2. Schema Created
```sql
CREATE SCHEMA telco_churn;
```
- Result: `1 row(s) affected` — schema created successfully
- Schema visible under the Schemas tab after refresh

### 3. Dataset Imported
- **Source:** Kaggle — Telco Customer Churn by BLASTCHAR (IBM Sample Dataset)
- **File:** `WA_Fn-UseC_-Telco-Customer-Churn.csv`
- **Method:** Right-click Tables → Table Data Import Wizard
- **Destination:** `telco_churn.customers` (new table created during import)
- **Column type note:** `MonthlyCharges` detected as DOUBLE — left as DOUBLE (functionally equivalent to DECIMAL for this analysis)
- `TotalCharges` intentionally set to TEXT during import to preserve blank values for cleaning post-import
- Import completed successfully in under 30 seconds

### 4. Import Verified
```sql
SELECT COUNT(*) FROM telco_churn.customers;
```
- **Result: 7,043 rows** — matches Kaggle dataset exactly ✅

```sql
DESCRIBE telco_churn.customers;
```
- All 21 columns imported correctly
- `TotalCharges` confirmed as TEXT ✅

### 5. TotalCharges Fix

**Problem:** 11 rows contained a blank space `' '` instead of NULL in the `TotalCharges` column, which prevented type conversion.

**Step 1 — Replace blanks with NULL:**
```sql
UPDATE telco_churn.customers
SET TotalCharges = NULL
WHERE TotalCharges = ' ';
```
- Result: `11 row(s) affected` ✅

**Step 2 — Convert column type to DECIMAL:**
```sql
ALTER TABLE telco_churn.customers
MODIFY COLUMN TotalCharges DECIMAL(10,2);
```
- Result: `7,043 row(s) affected` — normal behaviour on Mac MySQL when ALTER TABLE processes all rows during type conversion. Green tick confirmed, no errors ✅

**Step 3 — Confirm NULL count:**
```sql
SELECT COUNT(*) 
FROM telco_churn.customers 
WHERE TotalCharges IS NULL;
```
- **Result: 11** — confirming all blank rows correctly converted to NULL ✅

---

## Outcome

| Check | Result |
|---|---|
| Schema created | ✅ `telco_churn` |
| Table created | ✅ `telco_churn.customers` |
| Row count | ✅ 7,043 |
| Column count | ✅ 21 |
| TotalCharges blanks fixed | ✅ 11 rows → NULL |
| TotalCharges type | ✅ DECIMAL(10,2) |
| Data ready for Phase 1 | ✅ |

---

## Dataset Reference

| Detail | Value |
|---|---|
| Dataset name | Telco Customer Churn |
| Publisher | BLASTCHAR (IBM Sample Data) |
| Source | kaggle.com/datasets/blastchar/telco-customer-churn |
| Rows | 7,043 |
| Columns | 21 |
| Usability score | 8.82 / 10 |
| License | Data files © Original Authors |
