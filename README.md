# Bank Segmentation Analysis

A PostgreSQL SQL analytics project that uses synthetic banking data to explore customer behavior, transaction activity, account engagement, and regional performance.

## Overview

The project simulates a retail banking environment and applies SQL to answer practical business questions such as:

- Which customers generate the highest debit and credit volumes?
- Which accounts are the most active?
- How does transaction activity change over time?
- Which customers may be dormant or under-engaged?
- Which cities have the strongest customer activity?
- Which transaction services are used most frequently?
- Where are cross-selling and customer-retention opportunities?

> **Data note:** All records are synthetic and created for analysis practice. No real customer or personal data is used.

## Tech Stack

- PostgreSQL
- SQL
- CTEs
- JOINs
- Aggregations
- `FILTER`
- `CASE`
- Date/time functions
- Window functions
- Indexing

## Project Structure

| File | Purpose |
|---|---|
| `schema_setup.sql` | Creates the customer, account, and transaction tables with constraints and indexes. |
| `data_generation.sql` | Generates synthetic customers, accounts, and transactions and runs validation checks. |
| `bank_segmentation.sql` | Contains the main analytical queries. |
| `analysis_case_summary.md` | Documents the business questions, analytical approach, and recommendations. |

## Analysis Covered

1. Customer spending
2. Salary-credit trends
3. Account activity
4. Transaction volume
5. Monthly transaction trends
6. Yearly transaction trends
7. High-value customers
8. Dormant customers
9. Single-account customers
10. Transaction-service usage
11. City-level performance
12. Customer engagement by city
13. Highest spender by city

## Database Model

```text
customers
   │
   └──< accounts
           │
           └──< transactions
```

### Main entities

**Customers**
- Customer ID
- Customer name
- Gender
- Date of birth
- Signup date
- City

**Accounts**
- Account ID
- Customer ID
- Account number
- Account type
- Open date
- Balance

**Transactions**
- Transaction ID
- Account ID
- Transaction date
- Amount
- Transaction type
- Description

## How to Run

1. Create a PostgreSQL database.
2. Run `schema_setup.sql`.
3. Run `data_generation.sql`.
4. Run `bank_segmentation.sql`.
5. Review the result sets in pgAdmin or another PostgreSQL client.

## Key SQL Skills Demonstrated

- Relational data modeling
- Primary and foreign keys
- Data validation with constraints
- Index creation
- Multi-table joins
- Grouped aggregations
- Conditional aggregation with `FILTER`
- CTE-based analysis
- Window functions
- Time-based analysis
- Customer segmentation

## Business Use Cases

The analysis can support:

- Customer retention and reactivation
- High-value customer identification
- Cross-selling and product penetration
- Transaction-service optimization
- Regional performance monitoring
- Banking customer segmentation

## Project Outcome

This project demonstrates an end-to-end SQL workflow: **design the database → generate structured data → validate the dataset → analyze customer behavior → translate query results into business insights.**
