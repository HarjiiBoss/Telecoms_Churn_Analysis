# Phase 0 — Environment Setup

**Tool:** MySQL Workbench (Local Instance 3306)

---

## Objective

Set up the MySQL environment, create the project schema, import the Telco Customer Churn dataset, and ensure data integrity before beginning analytical queries.

---

## Steps Completed

### 1. Connection Verified

- Confirmed local MySQL instance (3306) is active
- Verified query editor is functioning correctly

---

### 2. Schema Created

```sql
CREATE SCHEMA telco_churn;
```

- Schema `telco_churn` created successfully and available for use

---

### 3. Dataset Imported

- **Source:** Kaggle — Telco Customer Churn (IBM Sample Dataset)
- **File:** `WA_Fn-UseC_-Telco-Customer-Churn.csv`
- **Method:** Table Data Import Wizard in MySQL Workbench
- **Destination Table:** `telco_churn.customers`

**Notes:**

- `MonthlyCharges` retained as `DOUBLE` (sufficient precision for aggregation and KPI calculations)
- `TotalCharges` initially imported as `TEXT` to preserve blank values for cleaning

---

### 4. Import Validation

```sql
SELECT COUNT(*) FROM telco_churn.customers;
```

- **Result:** 7,043 rows — matches source dataset

```sql
DESCRIBE telco_churn.customers;
```

- All 21 columns imported correctly
- Data types reviewed and confirmed

---

### 5. Data Cleaning — `TotalCharges`

**Issue:** 11 rows contained blank values (`' '`) which prevented numeric conversion.

**Step 1 — Replace blanks with NULL:**

```sql
UPDATE telco_churn.customers
SET TotalCharges = NULL
WHERE TotalCharges = ' ';
```

**Step 2 — Convert to numeric type:**

```sql
ALTER TABLE telco_churn.customers
MODIFY COLUMN TotalCharges DECIMAL(10,2);
```

**Step 3 — Validate result:**

```sql
SELECT COUNT(*)
FROM telco_churn.customers
WHERE TotalCharges IS NULL;
```

- **Result:** 11 NULL values confirmed

**Why this matters:**

- Ensures accurate revenue calculations in later analysis phases
- Prevents aggregation errors caused by invalid numeric values

---

## Outcome

| Check | Result |
|---|---|
| Schema created | ✅ `telco_churn` |
| Table created | ✅ `telco_churn.customers` |
| Row count | ✅ 7,043 |
| Column count | ✅ 21 |
| Data types validated | ✅ |
| TotalCharges cleaned | ✅ 11 blanks → NULL |
| TotalCharges converted | ✅ DECIMAL(10,2) |
| Data ready for analysis | ✅ |

---

## Data Readiness Notes

- Dataset is a static snapshot (no time-series component)
- Churn is binary (Yes / No) with no recorded reason for churn
- `TotalCharges` NULL values correspond to early-tenure customers with no accumulated charges

---

## Dataset Reference

| Detail | Value |
|---|---|
| Dataset name | Telco Customer Churn |
| Publisher | BLASTCHAR (IBM Sample Data) |
| Source | https://www.kaggle.com/datasets/blastchar/telco-customer-churn |
| Rows | 7,043 |
| Columns | 21 |
| License | Data files © Original Authors |

---

**Status:** Phase 0 complete — dataset is clean, validated, and ready for SQL analysis in Phase 1.
