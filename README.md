# End-to-End E-Commerce Data Warehouse & Analytics Pipeline (MySQL)
## Overview

This repository contains an end-to-end analytical data pipeline built on MySQL for an e-commerce dataset.
The project demonstrates how raw transactional data is ingested, validated, standardized, and transformed into a clean analytical layer that supports business reporting, operational monitoring, and executive-level KPIs.

The pipeline is designed using an industry-style layered approach:

Raw layer → Clean / Silver layer → Analytics & Reporting layer

The main focus of this project is:
- data quality validation,
- transformation and standardization,
- reconciliation between system totals and calculated revenue,
- and analytical readiness for downstream BI and dashboards.

All transformations and analyses are implemented directly in SQL to simulate a production-oriented data warehouse environment.

---

## Architecture Overview

```sql

CSV File
   │
   ▼
e_commerce_raw        (Raw ingestion layer)
   │
   ▼
e_commerce_clean      (Clean / analytical base table)
   │
   ├─ v_daily_revenue
   ├─ v_kpi_summary
   ▼
Ad-hoc analytical queries & reporting

```

The architecture separates raw ingestion from analytical processing to:
- preserve the original data state,
- enable data validation and reconciliation,
- and reduce the risk of propagating corrupted or inconsistent data into reports.

---

## Data Source
The pipeline ingests data from a flat CSV file:

```sql

E-Commerce / Data / E-Commerce.csv

```

The file is loaded using MySQL LOAD DATA INFILE, simulating a batch ingestion process from an external operational system.

---

## Raw Layer – Data Ingestion
Table: portofolio.e_commerce_raw

The raw table stores the data exactly as delivered by the source system.

It contains:
- customer attributes,
- order attributes,
- product category information,
- payment and device metadata,
- engagement metrics,
- delivery and satisfaction metrics.
No transformation, standardization, or filtering is applied at this stage.

The goal of this layer is:
- to retain the original values,
- and to serve as a reference point for validation and reconciliation.

---

## Ingestion Mechanism

The CSV file is ingested using:
- comma-separated fields,
- quoted values,
- and header row skipping.

This simulates a typical batch ingestion scenario from file-based data exchange.

---

## Initial Data Profiling

Immediately after ingestion, several profiling checks are performed on the raw table.

### Row and Order Cardinality
The pipeline checks:
- total number of rows,
- total number of distinct Order_ID.

This step validates the granularity of the dataset and helps detect:
- duplicated orders,
- unexpected row inflation,
- or potential multi-line order structures.

---

## Numerical Range Validation

Minimum and maximum values are computed for:
- age,
- quantity,
- unit price,
- customer rating.

This provides early detection of:
- out-of-range values,
- corrupted numeric fields,
- and potential data entry errors.

---

## Financial Consistency Check in Raw Data

A reconciliation check is executed between:

```sql

Total_Amount
and
(Unit_Price × Quantity – Discount_Amount)

```

The number of mismatched rows is recorded.

This step is critical to detect inconsistencies between:
- system-reported totals, and
- mathematically derived net order value.

This validation is performed before any transformation to ensure that data quality issues are not introduced by the transformation layer.

---

## Clean Layer – Standardization & Transformation

Table: portofolio.e_commerce_clean
The clean table is the analytical base table for all downstream reporting.

It enforces:
- stronger typing,
- normalized categorical values,
- basic integrity constraints,
- and a derived business metric.

This table represents the curated analytical dataset.

---

## Primary Key Strategy

The table uses:

```sql

Order_ID

```

as the primary key.
This design assumes that one row represents one complete order record.
This assumption is explicitly validated earlier using the raw data profiling step (count(*) vs count(distinct order_id)).

---

## Data Standardization Rules

During insertion into the clean table, the following rules are applied:

Age
Only values between 0 and 100 are accepted.
Invalid values are converted to NULL.

Gender, Payment Method, Device Type
All values are:
- trimmed,
- converted to lowercase,
- and standardized to reduce categorical fragmentation.

Returning Customer Flag
The string field is converted into a boolean representation:

```sql

True = 1
Else = 0

```

Customer Rating

Only ratings between 1 and 5 are accepted.
Invalid values are converted to NULL.

---

## Derived Metric – Order Value

A new metric is created:

```sql

Order_Value = Unit_Price × Quantity – Discount_Amount

```

This represents the net revenue per order and becomes the main financial measure used in all analytical queries.

---

## Clean Load Validation

After loading the clean table, the pipeline compares:
- total rows in raw table,
- total rows in clean table.

This ensures that no unexpected row loss or duplication occurred during transformation.

---

## Post-Load Data Quality Checks
After transformation, additional validations are executed on the clean table.

## Value Range Validation
Minimum and maximum values are checked for:
- order value,
- quantity,
- delivery time.

This confirms that transformations did not introduce abnormal values.

---

## Financial Reconciliation in Clean Layer
A second reconciliation is executed:

```sql

ABS(Total_Amount – Order_Value) > 0.01

```

The number of mismatched orders is recorded.

This step acts as a control mechanism to:
- identify financial inconsistencies,
- detect discount or pricing anomalies,
- and flag potential upstream system issues.

---

## Physical Optimization

Indexes are created to support analytical access patterns:
- customer-centric analysis,
- time-series analysis,
- product category aggregation.

Indexed columns:
- Customer_ID
- Order_Date
- Product_Category

These indexes are aligned with the grouping and filtering patterns used in the analytical queries and reporting views.

---

## Data Integrity Constraint

A check constraint is applied:

```sql

Customer_Rating must be between 1 and 5 or NULL

```

This protects the clean analytical table from future invalid inserts and ensures long-term data quality stability.

---

## Analytical Layer – Business Use Cases

All analytical queries operate exclusively on the clean table.

---

## 1. Returning Customer Spending Behaviour

### Business question
How many returning customers exist, and how much do they spend on average?

The query calculates:
- number of distinct customers,
- total revenue,
- average order value,

grouped by the returning-customer flag.
This supports customer loyalty analysis and retention strategy evaluation.

---

## 2. Platform Performance by Device Type

### Business question

Which platform generates the highest order volume and revenue?
The query aggregates:
- total number of orders,
- total revenue,
- by device type.

This supports product and marketing optimization across platforms.

---

## 3. Delivery Time vs Customer Rating

### Business question
Is there a relationship between delivery time and customer satisfaction?

The query computes average customer rating for each delivery time bucket.
This supports logistics performance monitoring and service-level improvement initiatives.

---

## 4. Daily Revenue Trend

### Business question
Which dates generate the highest total revenue?

Revenue is aggregated by order date.

---

View: v_daily_revenue

This view provides a reusable daily revenue dataset for dashboards and scheduled reports.

It acts as a reporting-ready abstraction over the clean table.

---

## 5. Customer Segmentation by Total Spending

### Business question

Who are the most valuable customers based on total spending?
Customers are grouped and segmented into tiers:
- Diamond
- Gold
- Silver
- Bronze
based on cumulative order value.

This segmentation supports loyalty programs, targeted campaigns, and CRM prioritization.

---

## 6. Revenue Ranking by City

### Business question

Which cities generate the highest revenue?
The query aggregates total revenue by city and applies a window function to produce a revenue rank.

This supports geographic performance monitoring and market expansion planning.

---

## 7. Best Selling Product Categories

### Business question

Which product categories generate the highest revenue?
The query aggregates revenue per product category to identify top-performing product groups.

This supports merchandising and inventory strategy.

---

## Executive Reporting Layer

### View: v_kpi_summary

This view provides high-level business KPIs:
- total number of orders,
- total revenue,
- average order value.

The view is designed to serve as a lightweight data source for executive dashboards and management reporting.

---

## Key Engineering Characteristics

### This project demonstrates:
- layered data architecture (raw → curated → reporting),
- explicit data profiling and validation,
- financial reconciliation between system values and derived metrics,
- standardized categorical handling,
- basic data integrity enforcement at the database level,
- physical optimization using indexes,
- and reusable reporting views.

---

## Assumptions and Scope

- Each row represents a complete order record.
- Discount_Amount is assumed to be a monetary discount applied per order.
- The dataset is processed in batch mode.
- The project focuses on analytical readiness and data quality controls rather than transactional system design.

---

## Technology Stack
- MySQL 8.x
- SQL (DDL, DML, window functions, views, constraints, indexing)

---

## Intended Usage

This repository can be used as a reference implementation for:
- analytical data warehouse preparation,
- SQL-based data quality pipelines,
- and business-driven data modeling for reporting and BI environments.

---
