# saas-cohort-retention-analysis
End-to-end B2B SaaS cohort retention and MRR churn analysis using MySQL CTEs and Tableau Public
# SaaS Customer Churn & Cohort Retention Analysis

An end-to-end product analytics project modeling 12-month user retention, churn dynamics, and Monthly Recurring Revenue (MRR) decay across customer subscription tiers.

[![Tableau Public](https://img.shields.io/badge/Tableau-Live_Dashboard-E97627?logo=tableau&logoColor=white)](https://public.tableau.com/app/profile/awwal.adepoju/viz/SaasCohortRetentionChurnAnalysis/Dashboard1)
[![SQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?logo=mysql&logoColor=white)](sql/)

---

## 📌 Executive Summary
Customer acquisition without retention creates a leaky revenue engine. This project analyzes transaction-level activity from **saas_churn_data** to identify:
1. When user churn peaks in the customer lifecycle (Month 0 through Month 11).
2. The divergence in retention health across **Starter**, **Professional**, and **Enterprise** tiers.
3. Quantifiable revenue impact to guide customer success intervention.

---

## 🛠️ Tech Stack & Methodology
* **Database / Query Engine:** MySQL (Multi-level CTEs, `TIMESTAMPDIFF`, aggregate windowing)
* **Business Intelligence:** Tableau Public (Interactive Triangular Retention Matrix & Decay Trends)
* **Data Flow:**
  1. Extracted raw activity records and mapped initial signup dates to baseline cohorts (`YYYY-MM-01`).
  2. Indexed customer lifecycle tenure using `TIMESTAMPDIFF(MONTH, cohort_month, activity_month)`.
  3. Computed percentage retention and MRR exposure per cohort month and per tier.
  4. Designed an executive-level retention matrix and segmented line charts in Tableau.

---

## 📁 Repository Structure
```text
├── sql/
│   ├── 01_monthly_cohort_matrix.sql    # CTE pipeline for month-over-month cohort decay
│   └── 02_tier_retention_breakdown.sql # Retention & MRR performance grouped by pricing tier
├── data/
│   ├── saas_churn_data.csv             # Raw transactional activity dataset
│   ├── monthly_cohort_matrix.csv       # Aggregated cohort output for BI consumption
│   └── tier_cohort_retention.csv       # Tier-segmented retention export
├── assets/
│   └── dashboard_preview.png           # Executive dashboard snapshot
└── README.md
