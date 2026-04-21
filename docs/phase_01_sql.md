# Phase 1 — SQL Extraction & Analysis

**Tool:** MySQL Workbench  
**Schema:** telco_churn  
**Table:** customers  
**Total Queries Written:** 22  
**SQL Files Created:** 6  
**CSVs Exported:** 17  

---

## Objective

Use the full strength of SQL to answer every business question directly in the database across three analytical pillars — Customer, Revenue and Risk. Excel receives clean, analysis-ready summary tables only. The SQL files are a standalone deliverable in this project.

---

## SQL Concepts Used

| Concept | Where Applied |
|---|---|
| `CASE WHEN` | Churn flag conversion, tenure bands, revenue tiers, risk flags |
| `GROUP BY` + aggregations | Churn rate, revenue totals by segment |
| `CTE (WITH clause)` | Revenue tiers, multi-dimension breakdown, ranked churn, cohort LAG analysis |
| `WINDOW FUNCTIONS` | Revenue share %, cumulative revenue, churn rank, percentile rank, cohort comparison |
| `RANK()` | Contract types ranked by churn rate |
| `ROW_NUMBER()` | Top 20 highest value churned customers |
| `SUM() OVER()` | Cumulative revenue by tenure, revenue share of total |
| `PERCENT_RANK()` | Customer percentile by monthly charge |
| `LAG()` | Churn rate change between tenure cohorts |
| `STDDEV()` | Monthly charge standard deviation by churn status |

---

## Phase 1A — Exploration

**File:** `01a_exploration.sql`  
**Purpose:** Validate data quality and establish baseline metrics before analysis.

### Results

**Query 1 — Overall size and churn rate:**

| Metric | Value |
|---|---|
| Total customers | 7,043 |
| Churned customers | 1,869 |
| Retained customers | 5,174 |
| Overall churn rate | 26.54% |

**Query 2 — Duplicate check:**
- Result: 0 rows returned — no duplicate CustomerIDs ✅

**Query 3 — NULL audit:**

| Column | NULL count |
|---|---|
| CustomerID | 0 |
| tenure | 0 |
| MonthlyCharges | 0 |
| TotalCharges | 11 (fixed in Phase 0) |
| Churn | 0 |
| Contract | 0 |

**Data quality verdict:** Clean dataset. Only known nulls are the 11 TotalCharges rows already handled in Phase 0. All key analytical columns are complete.

---

## Phase 1B — Customer Pillar

**File:** `01b_customer.sql`  
**Purpose:** Identify which customer segments are churning and at what rate.

### Results

**Query 1 — Churn rate by contract type:**

| Contract | Total Customers | Churned | Churn Rate |
|---|---|---|---|
| Month-to-month | 3,875 | 1,655 | 42.71% |
| One year | 1,473 | 166 | 11.27% |
| Two year | 1,695 | 48 | 2.83% |

**Query 2 — Churn rate by tenure band:**

| Tenure Band | Total Customers | Churned | Churn Rate |
|---|---|---|---|
| 0-12 months | 2,186 | 1,037 | 47.44% |
| 13-36 months | 1,856 | 474 | 25.54% |
| 37+ months | 3,001 | 358 | 11.93% |

**Query 3 — Churn rate by internet service:**

| Internet Service | Total Customers | Churned | Churn Rate |
|---|---|---|---|
| Fiber optic | 3,096 | 1,297 | 41.89% |
| DSL | 2,421 | 459 | 18.96% |
| No internet | 1,526 | 113 | 7.40% |

**Query 4 — Average tenure: churned vs retained:**

| Churn | Avg Tenure | Min | Max |
|---|---|---|---|
| No | 37.6 months | 0 | 72 |
| Yes | 18.0 months | 1 | 72 |

**Query 5 — Churn rate by payment method:**

| Payment Method | Total Customers | Churned | Churn Rate |
|---|---|---|---|
| Electronic check | 2,365 | 1,071 | 45.29% |
| Mailed check | 1,612 | 308 | 19.11% |
| Bank transfer (automatic) | 1,544 | 258 | 16.71% |
| Credit card (automatic) | 1,522 | 232 | 15.24% |

**Query 6 — RANK() by churn rate:**

| Contract | Churn Rate | Rank |
|---|---|---|
| Month-to-month | 42.71% | 1 |
| One year | 11.27% | 2 |
| Two year | 2.83% | 3 |

### Key Customer Pillar Findings
- Month-to-month customers churn at **42.71%** — 15x higher than two-year customers
- Nearly **1 in 2 new customers** (47.44%) leave within their first 12 months
- Fiber optic churn at **41.89%** signals a service quality or pricing issue
- Electronic check customers churn at **45.29%** — the highest of any payment method
- Churned customers leave after an average of **18 months** vs 37.6 months for retained

---

## Phase 1C — Revenue Pillar

**File:** `01c_revenue.sql`  
**Purpose:** Quantify revenue at risk and identify where revenue is concentrated.

### Results

**Query 1 — Monthly charges: churned vs retained:**

| Churn | Avg Monthly Charge | Min | Max | Std Dev |
|---|---|---|---|---|
| No | £61.27 | £18.25 | £118.75 | £31.09 |
| Yes | £74.44 | £18.85 | £118.35 | £24.66 |

**Query 2 — Revenue at risk:**

| Metric | Value |
|---|---|
| Monthly revenue lost (churned) | £139,130.85 |
| Monthly revenue retained | £316,985.75 |
| Total monthly charges | £456,116.60 |
| Revenue at risk % | 30.50% |
| Annualised revenue at risk | £1,669,570.20 |

**Query 3 — Revenue by contract type:**

| Contract | Customers | Total Revenue | Avg Revenue/Customer | Avg Monthly |
|---|---|---|---|---|
| Two year | 1,685 | £6,283,253.70 | £3,728.93 | £60.87 |
| Month-to-month | 3,875 | £5,305,861.50 | £1,369.25 | £66.40 |
| One year | 1,472 | £4,467,053.50 | £3,034.68 | £65.08 |

**Query 4 — Revenue tiers:**

| Tier | Total Customers | Churned | Churn Rate | Avg Monthly |
|---|---|---|---|---|
| High value (£70+) | 3,591 | 1,274 | 35.48% | £90.19 |
| Mid value (£35-£70) | 1,721 | 407 | 23.65% | £54.72 |
| Low value (<£35) | 1,731 | 188 | 10.86% | £22.00 |

**Query 5 — Cumulative revenue by tenure:**
- Tenure 72 generates £29,211.90 in a single month — highest of any cohort
- Cumulative revenue reaches £456,116.60 at tenure 72
- Long-tenure customers are the revenue backbone of the business

### Key Revenue Pillar Findings
- Churned customers paid **£13.17/month more** than retained customers on average
- **30.5% of monthly revenue** has already been lost to churn
- Annualised revenue at risk: **£1,669,570.20**
- Two-year customers generate **2.7x more revenue per customer** than month-to-month
- High-value customers (£70+/month) churn at the highest rate — **35.48%**

---

## Phase 1D — Risk Pillar

**File:** `01d_risk.sql`  
**Purpose:** Quantify structural concentration risk across contract types and service categories.

### Results

**Query 1 — Contract type concentration:**

| Contract | Customers | Customer Share | Monthly Revenue | Revenue Share |
|---|---|---|---|---|
| Month-to-month | 3,875 | 55.02% | £257,294.15 | 56.41% |
| Two year | 1,695 | 24.07% | £103,005.85 | 22.58% |
| One year | 1,473 | 20.91% | £95,816.60 | 21.01% |

**Query 2 — Internet service concentration:**

| Service | Customers | Customer Share | Monthly Revenue | Revenue Share | Churn Rate |
|---|---|---|---|---|---|
| Fiber optic | 3,096 | 43.96% | £283,284.40 | 62.11% | 41.89% |
| DSL | 2,421 | 34.37% | £140,665.35 | 30.84% | 18.96% |
| No internet | 1,526 | 21.67% | £32,166.85 | 7.05% | 7.40% |

**Query 4 — High risk customer count:**

| Risk Flag | Total Customers | Already Churned | Churn Rate |
|---|---|---|---|
| High risk | 814 | 566 | 69.53% |
| Standard | 6,229 | 1,303 | 20.92% |

### Key Risk Pillar Findings
- Month-to-month contracts hold **55.02% of customers** and **56.41% of monthly revenue** — majority of the business sits on the most fragile contract type
- Fiber optic generates **62.11% of monthly revenue** yet churns at 41.89% — highest revenue concentration in the most volatile service
- **814 high-risk customers** identified (month-to-month + £70+/month + tenure <12 months)
- High-risk customers churn at **69.53%** — 3.3x the standard rate of 20.92%

---

## Phase 1E — Advanced Multi-Dimension Queries

**File:** `01e_advanced.sql`  
**Purpose:** Combine all three pillars into sophisticated multi-factor analysis using CTEs and window functions.

### Results

**Query 1 — Multi-dimension churn (top 10 segments):**

| Contract | Tenure Band | Revenue Tier | Customers | Churned | Churn Rate |
|---|---|---|---|---|---|
| Month-to-month | 0-12 months | High value | 860 | 595 | 69.19% |
| Month-to-month | 13-36 months | High value | 753 | 350 | 46.48% |
| Month-to-month | 0-12 months | Mid value | 627 | 282 | 44.98% |
| Month-to-month | 37+ months | High value | 491 | 166 | 33.81% |
| Month-to-month | 0-12 months | Low value | 507 | 147 | 28.99% |
| One year | 0-12 months | High value | 15 | 4 | 26.67% |
| Month-to-month | 13-36 months | Mid value | 305 | 67 | 21.97% |
| Month-to-month | 37+ months | Mid value | 135 | 24 | 17.78% |
| One year | 37+ months | High value | 563 | 98 | 17.41% |
| One year | 13-36 months | High value | 140 | 24 | 17.14% |

**Query 2 — Estimated LTV by contract and churn status:**

| Contract | Churn | Avg Tenure | Avg Monthly | Estimated LTV |
|---|---|---|---|---|
| Two year | Yes | 61.3 months | £86.78 | £5,316.90 |
| One year | Yes | 45.0 months | £85.05 | £3,824.22 |
| Two year | No | 56.6 months | £60.01 | £3,396.88 |
| One year | No | 41.7 months | £62.51 | £2,604.97 |
| Month-to-month | No | 21.0 months | £61.46 | £1,292.76 |
| Month-to-month | Yes | 14.0 months | £73.02 | £1,023.51 |

**Query 3 — Top churned customer by total charges:**
- Rank 1: Customer 2889-FPWRM — One year, 72 months, £117.80/month, £8,684.80 total charges

**Query 4 — LAG() cohort churn rate change:**

| Cohort | Churn Rate | Previous Rate | Change |
|---|---|---|---|
| 1. 0-12 months | 47.44% | NULL | NULL |
| 2. 13-24 months | 28.71% | 47.44% | -18.73 |
| 3. 25-36 months | 21.63% | 28.71% | -7.08 |
| 4. 37-48 months | 19.03% | 21.63% | -2.60 |
| 5. 49+ months | 9.51% | 19.03% | -9.52 |

**Query 5 — Perfect storm combination:**

| Tenure Band | Customers | Churned | Churn Rate |
|---|---|---|---|
| 0-12 months | 631 | 449 | 71.16% |
| 13-36 months | 429 | 240 | 55.94% |
| 37+ months | 247 | 100 | 40.49% |

*Combination: Month-to-month + Fiber optic + Electronic check*

### Key Advanced Findings
- Worst single segment: Month-to-month + 0-12 months + High value = **69.19% churn**
- Perfect storm combination: Month-to-month + Fiber optic + Electronic check + 0-12 months = **71.16% churn**
- Biggest churn improvement between cohorts: months 12→24 = **-18.73 percentage points**
- Two-year churned LTV (£5,316.90) is **5.2x higher** than month-to-month churned LTV (£1,023.51)
- Keeping a customer past 24 months reduces churn risk by more than half

---

## Phase 1F — Exports

**SQL files saved:** 6 files in `/sql` folder  
**CSVs exported:** 17 files in `/data` folder

### CSV Export List

| # | Filename | Source Query |
|---|---|---|
| 1 | `churn_by_contract.csv` | 1B — Query 1 |
| 2 | `churn_by_tenure_band.csv` | 1B — Query 2 |
| 3 | `churn_by_internet_service.csv` | 1B — Query 3 |
| 4 | `avg_tenure_by_churn.csv` | 1B — Query 4 |
| 5 | `churn_by_payment_method.csv` | 1B — Query 5 |
| 6 | `revenue_at_risk.csv` | 1C — Query 2 |
| 7 | `revenue_by_contract.csv` | 1C — Query 3 |
| 8 | `revenue_tiers.csv` | 1C — Query 4 |
| 9 | `cumulative_revenue_by_tenure.csv` | 1C — Query 5 |
| 10 | `concentration_risk.csv` | 1D — Query 1 |
| 11 | `internet_service_concentration.csv` | 1D — Query 2 |
| 12 | `high_risk_customers.csv` | 1D — Query 4 |
| 13 | `multi_dimension_churn.csv` | 1E — Query 1 |
| 14 | `estimated_ltv.csv` | 1E — Query 2 |
| 15 | `cohort_lag_analysis.csv` | 1E — Query 4 |
| 16 | `avg_charges_by_churn.csv` | 1C — Query 1 |
| 17 | `perfect_storm_churn.csv` | 1E — Query 5 |

---

## Summary

| Pillar | Key Metric | Value |
|---|---|---|
| Customer | Overall churn rate | 26.54% |
| Customer | Month-to-month churn rate | 42.71% |
| Customer | 0-12 month tenure churn rate | 47.44% |
| Customer | Fiber optic churn rate | 41.89% |
| Customer | Electronic check churn rate | 45.29% |
| Revenue | Monthly revenue at risk | £139,130.85 |
| Revenue | Revenue at risk % | 30.50% |
| Revenue | Annualised revenue at risk | £1,669,570.20 |
| Revenue | Churned customer avg monthly charge | £74.44 |
| Revenue | High value customer churn rate | 35.48% |
| Risk | Month-to-month revenue share | 56.41% |
| Risk | Fiber optic revenue share | 62.11% |
| Risk | High-risk customers identified | 814 |
| Risk | High-risk churn rate | 69.53% |
| Advanced | Worst segment churn rate | 69.19% |
| Advanced | Perfect storm churn rate | 71.16% |
| Advanced | Two-year vs M2M LTV multiple | 5.2x |

---

*Phase 1 of 10 — Project 4: Telco Customer Churn Analysis*  
*Framework: Customer · Revenue · Risk*  
*Tool: MySQL Workbench*
