# Phase 3 — KPI Design & Framework

**Tool:** Microsoft Excel (Mac)
**Sheet:** `KPI_Framework`
**KPIs Defined:** 10
**Pillars:** Customer · Revenue · Risk
**Status:** Complete ✅

---

## Objective

Define the 10 core KPIs across three analytical pillars, build the KPI framework as the analytical backbone of the project, and establish a single source of truth that feeds all downstream analysis and dashboard outputs.

---

## KPI Framework

### Customer Pillar

| # | KPI | Value | Source | Status |
|---|---|---|---|---|
| 1 | Overall Churn Rate | 26.54% | SQL — 01a_exploration.sql | 🟡 Moderate Risk |
| 2 | Month-to-Month Churn Rate | 42.71% | tbl_ChurnByContract | 🔴 High Risk |
| 3 | Early Tenure Churn Rate (0–12 months) | 47.44% | tbl_ChurnByTenureBand | 🔴 High Risk |
| 4 | Avg Tenure — Churned Customers | 18.0 months | tbl_AvgTenureByChurn | 🟡 Moderate Risk |

---

### Revenue Pillar

| # | KPI | Value | Source | Status |
|---|---|---|---|---|
| 5 | Monthly Revenue at Risk (£) | 139,130.85 | tbl_RevenueAtRisk | 🔴 High Risk |
| 6 | Revenue at Risk (%) | 30.50% | tbl_RevenueAtRisk | 🔴 High Risk |
| 7 | Avg Monthly Charge — Churned Customers (£) | 74.44 | tbl_AvgChargesByChurn | 🟡 Moderate Risk |

---

### Risk Pillar

| # | KPI | Value | Source | Status |
|---|---|---|---|---|
| 8 | Month-to-Month Revenue Concentration (%) | 56.41% | tbl_ConcentrationRisk | 🔴 High Risk |
| 9 | Fiber Optic Revenue Concentration (%) | 62.11% | tbl_InternetServiceConcentration | 🔴 High Risk |
| 10 | High-Risk Customer Count | 814 | tbl_HighRiskCustomers | 🔴 High Risk |

---

## Status Legend

| Symbol | Meaning | Threshold |
|---|---|---|
| 🔴 | High Risk | Churn ≥ 40% / Revenue at risk > 25% / Concentration > 50% / High-risk count > 500 |
| 🟡 | Moderate Risk | Churn 20–39% / Signals worth monitoring but not immediate crisis |
| 🟢 | Stable | Churn < 20% / Metrics within acceptable range |

> Status flags are displayed as symbols in the sheet. Full threshold logic is documented here for audit purposes.

---

## KPI_Framework Sheet Structure

### Layout

| Row | Content |
|---|---|
| Row 1 | Project title — merged A1:E1 |
| Row 2 | Framework subtitle — merged A2:E2 |
| Row 3 | Blank spacer |
| Row 4 | Column headers — Pillar, KPI, Value, Source, Status |
| Rows 5–8 | Customer KPIs |
| Rows 9–11 | Revenue KPIs |
| Rows 12–14 | Risk KPIs |
| Row 15 | Blank spacer |
| Row 16 | Legend — 🔴 High Risk · 🟡 Moderate Risk · 🟢 Stable |

---

### Formatting Applied

| Element | Format |
|---|---|
| Title row (Row 1) | Dark Navy `#1F3864` background, White `#FFFFFF` text, Bold, merged A1:E1, left-aligned |
| Subtitle row (Row 2) | Light Navy `#DAE3F3` background, Dark Grey `#262626` text, merged A2:E2, left-aligned |
| Column headers (Row 4) | Dark Navy `#1F3864` background, White `#FFFFFF` text, Bold |
| Customer rows (5–8) | Light Navy `#DAE3F3` background, Dark Grey `#262626` text |
| Revenue rows (9–11) | Gold `#C9A84C` background, Dark Grey `#262626` text |
| Risk rows (12–14) | Red `#C00000` background, White `#FFFFFF` text |
| Status column (E) | White background, emoji symbol, centre-aligned |
| Legend row (16) | White background, Bold `Legend:` label in column A |

---

### Value Formatting

| KPI Type | Format |
|---|---|
| Percentages | Number, 2 decimal places |
| Monetary values | Number, 2 decimal places, comma separator |
| Counts | Number, 0 decimal places |
| Tenure | Number, 1 decimal place |

---

## Naming Reference

| Element | Name |
|---|---|
| Sheet | `internet_service_concentration` |
| CSV file | `internet_service_concentration.csv` |
| Table | `tbl_InternetServiceConcentration` |

> Sheet and CSV use shortened form. Table name uses full form for clarity in formulas and documentation.

---

## KPI Calculation Integrity

- All KPI values are **directly sourced from SQL outputs**
- Excel performs **no re-aggregation or recalculation of core metrics**
- This ensures:
  - Consistency across analysis layers
  - No duplication of logic
  - Clear audit trail from SQL → Excel → Dashboard

---

## KPI Selection Rationale

| KPI | Why It Matters |
|---|---|
| Overall Churn Rate | Baseline performance indicator |
| Month-to-Month Churn Rate | Primary churn driver identified in Phase 1B |
| Early Tenure Churn Rate | Identifies highest-risk lifecycle stage |
| Avg Tenure — Churned | Measures how early customers are leaving |
| Monthly Revenue at Risk | Direct financial impact of churn |
| Revenue at Risk (%) | Scale of business exposure to churn |
| Avg Monthly Charge — Churned | Proves higher-value customers are leaving |
| M2M Revenue Concentration | Majority of revenue on most fragile contract |
| Fiber Revenue Concentration | Highest revenue segment also highest churn |
| High-Risk Customer Count | Actionable — enables targeted retention intervention |

---

## Design Decision — No PivotTables

PivotTables were intentionally not used.

All aggregations were performed in SQL during Phase 1. Rebuilding them in Excel would duplicate logic without adding analytical value.

**Workflow principle:**
- SQL → computation layer
- Excel → presentation and insight layer

---

## Validation Summary

| Check | Result |
|---|---|
| 10 KPIs defined across 3 pillars | ✅ |
| All values tied to SQL outputs | ✅ |
| No duplicated calculations | ✅ |
| Status flags applied to all KPIs | ✅ |
| Legend added to sheet | ✅ |
| Formatting consistent with color palette | ✅ |
| Table name corrected throughout | ✅ |
| Sheet structured correctly | ✅ |
| Ready for downstream use | ✅ |

---

## Outcome

The KPI framework establishes a **single, traceable, and analysis-ready metric layer** that feeds:

- Phase 4 — Churn Analysis
- Phase 5 — Revenue Stability
- Phase 6 — Risk Analysis
- Phase 7 — Dashboard

---

**Status:** Phase 3 complete — KPI framework established as the central analytical layer of the project.
*Project 4: Telco Customer Churn Analysis — Framework: Customer · Revenue · Risk*
