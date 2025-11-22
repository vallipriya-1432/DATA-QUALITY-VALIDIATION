# Data Quality & Validation Project (PostgreSQL)

This project focuses on building a small but realistic data quality and validation pipeline using SQL.  
I used a subset of an e-commerce orders dataset as the incoming raw source and designed a process that:

- loads raw data into a staging table,  
- applies multiple data validation rules,  
- identifies and separates rejected rows,  
- produces clean, usable data for reporting,  
- and generates data quality KPIs and exception reports.

---

## ⭐ Project Goals

- Detect issues in raw incoming data  
- Implement validation rules directly in SQL  
- Automatically separate clean and dirty records  
- Provide transparency on what failed and why  
- Create views that summarize data quality health  
- Build a repeatable and production-like workflow  

The project simulates how to prepare data before it enters business systems.

---

## 📂 Files in This Repository

| File | Purpose |
|------|---------|
| **01_schema.sql** | Creates the schema and raw staging table for incoming data |
| **02_sample_data.sql** | Inserts a mix of clean and intentionally dirty sample rows |
| **03_qualitychecks.sql** | Runs rule-based data validation checks and counts issues |
| **04_clean&reject.sql** | Creates typed staging, clean table, and rejects table |
| **05_qualityviews.sql** | Views for data quality KPIs and detailed reject reasons |


---

## 🔍 Data Quality Rules Implemented

The project checks for:

- Invalid or unparseable dates  
- Ship dates that occur before order dates  
- Missing key fields (order_id, customer_id, product_id)  
- Non-numeric or negative sales values  
- Duplicate order IDs  
- Blank or malformed fields  

These are very typical errors in real-world datasets.

---

## 🧼 Clean vs Reject Pipeline

The data flows through these layers:

1. **Raw Staging** – data arrives exactly as it is in the CSV  
2. **Typed Staging** – dates and numeric fields parsed where possible  
3. **Rejects Table** – rows that fail any validation rule  
4. **Clean Table** – reliable, ready-to-use records  

This pipeline mirrors how many organisations manage data quality.

---

## 📊 Data Quality Views

### `v_data_quality_summary`
Summarises:

- total raw rows  
- clean rows  
- rejected rows  
- acceptance rate (%)  
- count of duplicate orders  

### `v_rejects_with_flags`
Shows each rejected row with boolean flags explaining **why** it failed.

This provides transparency for analysts and data owners.

---

## ▶️ How to Run This Project

1. Open **https://dbfiddle.uk**  
2. Choose **PostgreSQL v15**  
3. Paste the contents of each `.sql` file in order:  
   - 01 → Build  
   - 02 → Run  
   - 03 → Run  
   - 04 → Run  
   - 05 → Run  
4. Query the views:  
```sql
SELECT * FROM v_data_quality_summary;
SELECT * FROM v_rejects_with_flags;
