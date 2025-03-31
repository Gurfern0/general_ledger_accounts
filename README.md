# General Ledger (G/L) Accounts - SQL Data Analysis

## Overview
This SQL query is designed for financial data analysis, specifically extracting and transforming SAP accounting data. It focuses on general ledger (G/L) accounts related to transactions with account code `24000`. The query ensures data integrity by handling duplicate records, adjusting amounts based on company code rules, and linking suppliers to their transactions.

## Key Features
- **Common Table Expressions (CTEs):**
  - `Data_t`: Extracts and transforms SAP accounting entries.
  - `ecco_2`: Retrieves the original supplier based on reference fields.
- **Window Functions:**
  - `ROW_NUMBER() OVER (PARTITION BY ...)` removes duplicate rows by keeping only the most recent entry.
- **Conditional Logic:**
  - Adjusts net amounts based on debit/credit indicators (`shkzg`).
  - Flags cleared transactions based on clearing date (`augdt`).
- **Data Joins:**
  - Combines data from SAP tables (`bseg`, `t001`, `ekko`, `lfa1`).

## How It Works
1. The `Data_t` CTE extracts financial data from `bseg`, linking relevant metadata like currency, purchasing group, and supplier details.
2. The `ecco_2` CTE identifies original suppliers for transactions based on the purchasing document (`ebeln`).
3. The final `SELECT` statement applies transformations, including:
   - Adjusting `net_amount` for specific company codes.
   - Retaining only the latest transaction per record using `ROW_NUMBER()`.
   - Filtering relevant G/L accounts (`24000`).

## Use Cases
- **Financial Reporting:** Analyzing G/L account transactions for accuracy.
- **Supplier Analysis:** Linking transactions to the correct suppliers.
- **Data Cleansing:** Removing duplicate financial entries in SAP datasets.
- **Audit & Compliance:** Ensuring transactions are properly classified and recorded.

## Technologies Used
- SQL (BigQuery or MySQL-like syntax)
- SAP Data Extraction (Tables: `bseg`, `t001`, `ekko`, `lfa1`)

## Contribution
This query can be further optimized by:
- Improving indexing for better performance.
- Expanding it to include other financial account categories.
- Enhancing supplier matching logic.
