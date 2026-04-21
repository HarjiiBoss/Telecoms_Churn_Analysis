# Phase 1 — SQL Extraction & Analysis

**Tool:** MySQL Workbench  
**Schema:** telco_churn  
**Table:** customers  
**Total Queries:** 22  
**SQL Files:** 6  
**CSVs Exported:** 17  

---

## Objective

Use SQL to answer all core business questions across three pillars — Customer, Revenue, and Risk.  
All computations are performed in MySQL, with Excel receiving only clean, analysis-ready outputs.

---

## SQL Concepts Used

| Concept | Application | Specific Usage |
|---|---|---|
| CASE WHEN | Segmentation | Tenure bands, revenue tiers, risk flags, churn flag conversion |
| GROUP BY | Aggregation | Churn rates, revenue totals by segment |
| CTEs | Multi-step analysis | Revenue tiers, multi-dimension breakdown, cohort LAG analysis |
| Window Functions | Ranking and cumulative metrics | Revenue share %, cumulative revenue by tenure |
| RANK() | Contract churn ranking | Ranking contract types by churn rate descending |
| ROW_NUMBER() | Top customer identification | Top 20 highest value churned customers by TotalCharges |
| SUM() OVER() | Revenue share and cumulative revenue | Contract revenue share of total, running revenue by tenure |
| PERCENT_RANK() | Charge distribution | Customer percentile ranking by MonthlyCharges |
| LAG() | Cohort churn comparison | Churn rate change between consecutive tenure cohorts |
| STDDEV() | Charge variability | Monthly charge standard deviation by churn status |

---

## Phase 1A — Exploration

**File:** `01a_exploration.sql`  
**Purpose:** Validate dataset and establish baseline metrics

### Results

**Query 1 — Overall size and churn rate:**

| Metric | Value |
|---|---|
| Total customers | 7,043 |
| Churned customers | 1,869 |
| Retained customers | 5,174 |
| Overall churn rate | 26.54% |

**Query 2 — Duplicate check:**

| Result | Value |
|---|---|
| Duplicate CustomerIDs | 0 |

**Query 3 — NULL audit:**

| Column | NULL Count |
|---|---|
| CustomerID | 0 |
| tenure | 0 |
| MonthlyCharges | 0 |
| TotalCharges | 11 (resolved in Phase 0) |
| Churn | 0 |
| Contract | 0 |

**Verdict:** Dataset is clean and analysis-ready.

---

## Phase 1B — Customer Analysis

**File:** `01b_customer.sql`  
**Purpose:** Identify churn patterns across customer segments

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

### Key Insights

- Churn is heavily concentrated in **early-tenure customers**
- Contract structure is the strongest predictor of churn
- Payment method and service type signal behavioural risk patterns
- Churned customers leave after an average of **18 months** vs 37.6 months for retained

---

## Phase 1C — Revenue Analysis

**File:** `01c_revenue.sql`  
**Purpose:** Quantify revenue exposure and customer value

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
| Mid value (£35–£70) | 1,721 | 407 | 23.65% | £54.72 |
| Low value (<£35) | 1,731 | 188 | 10.86% | £22.00 |

**Query 5 — Cumulative revenue by tenure (selected rows):**

| Tenure | Customers | Monthly Revenue | Cumulative Revenue |
|---|---|---|---|
| 1 | — | — | — |
| 12 | — | — | — |
| 36 | — | — | — |
| 72 | 362 | £29,211.90 | £456,116.60 |

> Full 72-row output saved in `cumulative_revenue_by_tenure.csv`

### Key Insights

- Revenue loss is driven by **high-value churners**, not low-value users
- Churned customers paid **£13.17/month more** on average than retained customers
- Two-year customers generate **2.7x more revenue per customer** than month-to-month
- Retention of premium customers is critical to business stability

---

## Phase 1D — Risk Analysis

**File:** `01d_risk.sql`  
**Purpose:** Identify structural and concentration risk

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

### Key Insights

- Majority of revenue sits in the **most volatile segments**
- High-risk customers are clearly identifiable before churn occurs
- Business model shows **structural fragility** — over half of revenue on month-to-month contracts
- Fiber optic generates 62.11% of revenue yet carries the highest churn rate

---

## Phase 1E — Advanced Analysis

**File:** `01e_advanced.sql`  
**Purpose:** Multi-dimensional segmentation and deeper insight generation

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

| Rank | CustomerID | Contract | Tenure | Monthly Charges | Total Charges |
|---|---|---|---|---|---|
| 1 | 2889-FPWRM | One year | 72 | £117.80 | £8,684.80 |

> Full top 20 list saved in MySQL — not exported to CSV as individual customer rows are not needed for dashboard summaries.

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

### Key Insights

- Churn risk is **multi-factor driven**, not single-variable
- Early retention (<12 months) is the highest leverage intervention point
- Largest churn improvement occurs between months 12–24: **-18.73 percentage points**
- Long-term contracts significantly increase customer value — two-year LTV is **5.2x higher** than month-to-month

---

## Phase 1F — Exports

**SQL files saved to `/sql`:**

| File | Contents |
|---|---|
| `00_setup.sql` | Schema creation, TotalCharges fix, validation |
| `01a_exploration.sql` | Baseline metrics and data quality checks |
| `01b_customer.sql` | Customer pillar — all 6 queries |
| `01c_revenue.sql` | Revenue pillar — all 5 queries |
| `01d_risk.sql` | Risk pillar — all 5 queries |
| `01e_advanced.sql` | Advanced multi-dimension queries — all 5 queries |

**17 CSV outputs exported to `/data`:**

| # | Filename | Source Query |
|---|---|---|
| 1 | `churn_by_contract.csv` | 1B — Query 1 |
| 2 | `churn_by_tenure_band.csv` | 1B — Query 2 |
| 3 | `churn_by_internet_service.csv` | 1B — Query 3 |
| 4 | `avg_tenure_by_churn.csv` | 1B — Query 4 |
| 5 | `churn_by_payment_method.csv` | 1B — Query 5 |
| 6 | `avg_charges_by_churn.csv` | 1C — Query 1 |
| 7 | `revenue_at_risk.csv` | 1C — Query 2 |
| 8 | `revenue_by_contract.csv` | 1C — Query 3 |
| 9 | `revenue_tiers.csv` | 1C — Query 4 |
| 10 | `cumulative_revenue_by_tenure.csv` | 1C — Query 5 |
| 11 | `concentration_risk.csv` | 1D — Query 1 |
| 12 | `internet_service_concentration.csv` | 1D — Query 2 |
| 13 | `high_risk_customers.csv` | 1D — Query 4 |
| 14 | `multi_dimension_churn.csv` | 1E — Query 1 |
| 15 | `estimated_ltv.csv` | 1E — Query 2 |
| 16 | `cohort_lag_analysis.csv` | 1E — Query 4 |
| 17 | `perfect_storm_churn.csv` | 1E — Query 5 |

---

## Summary Metrics

| Category | Metric | Value |
|---|---|---|
| Customer | Churn rate | 26.54% |
| Customer | Month-to-month churn | 42.71% |
| Customer | Early tenure churn (0-12 months) | 47.44% |
| Customer | Fiber optic churn | 41.89% |
| Customer | Electronic check churn | 45.29% |
| Revenue | Monthly revenue at risk | £139,130.85 |
| Revenue | Revenue at risk % | 30.50% |
| Revenue | Annualised risk | £1,669,570.20 |
| Revenue | Churned avg monthly charge | £74.44 |
| Revenue | High value customer churn rate | 35.48% |
| Risk | M2M customer share | 55.02% |
| Risk | M2M revenue share | 56.41% |
| Risk | Fiber revenue share | 62.11% |
| Risk | High-risk customers identified | 814 |
| Risk | High-risk churn rate | 69.53% |
| Advanced | Worst segment churn rate | 69.19% |
| Advanced | Perfect storm churn rate | 71.16% |
| Advanced | Two-year vs M2M LTV multiple | 5.2x |

---

**Status:** Phase 1 complete — SQL analysis delivers structured insights across customer behaviour, revenue exposure, and structural risk.  
*Project 4: Telco Customer Churn Analysis — Framework: Customer · Revenue · Risk*
