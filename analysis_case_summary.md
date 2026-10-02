# Bank Segmentation Analysis — Case Summary

## Business Context

This project simulates a retail banking dataset and uses PostgreSQL to analyze customer value, transaction behavior, account engagement, and regional performance.

The dataset is fully synthetic and contains no real customer or personal information.

## Objectives

- Identify high-value customers using transaction volumes.
- Measure account and transaction activity.
- Track monthly and yearly transaction trends.
- Detect potentially dormant customers.
- Identify customers with limited product usage.
- Compare customer engagement across cities.
- Understand the most frequently used transaction services.

## Analytical Approach

The analysis combines relational modeling with SQL-based analytics.

Key techniques include:

- Multi-table `JOIN` operations
- `GROUP BY` and aggregate functions
- Conditional aggregation using `FILTER`
- Common Table Expressions (CTEs)
- Date-based grouping and filtering
- Window functions such as `ROW_NUMBER()`
- Primary and foreign key relationships
- Indexing for commonly queried columns

## Business Insights Supported

### Customer Value
Debit and credit volume queries help identify customers with significant financial activity and potential value for relationship-management strategies.

### Customer Engagement
Transaction recency can be used to separate active customers from customers who may require reactivation.

### Product Penetration
Customers with only one account can be considered for targeted cross-selling based on their observed activity.

### Regional Performance
City-level metrics provide a simple view of customer concentration, transaction volume, and engagement rates.

### Service Usage
Transaction descriptions reveal which banking services and channels are most frequently used.

## Recommendations

1. **Prioritize high-value customers** with retention and relationship-management strategies.
2. **Reactivate dormant customers** through targeted communication and relevant offers.
3. **Explore cross-selling opportunities** among single-account customers.
4. **Monitor regional performance** to identify strong and underperforming markets.
5. **Track transaction-service demand** to support operational and digital-banking decisions.

## Conclusion

The project demonstrates how PostgreSQL can turn structured banking data into practical customer and operational insights. It covers the complete workflow from database design and synthetic data generation to analytical SQL and business interpretation.
