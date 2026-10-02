-- BANK SEGMENTATION ANALYSIS
-- PostgreSQL analytical queries

-- 1. Total spend by customer
SELECT
    c.customer_id,
    c.customer_name,
    SUM(t.amount) AS total_spend
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transactions t ON t.account_id = a.account_id
WHERE t.transaction_type = 'debit'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spend DESC;

-- 2. Monthly salary-credit trend
SELECT
    DATE_TRUNC('month', t.transaction_date)::date AS month,
    COUNT(*) AS salary_transactions,
    SUM(t.amount) AS salary_credit_volume
FROM transactions t
WHERE t.transaction_type = 'credit'
  AND t.description = 'Salary credit'
  AND t.transaction_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY 1
ORDER BY 1;

-- 3. Most active accounts by transaction count
SELECT
    a.account_id,
    c.customer_name,
    COUNT(*) AS transaction_count
FROM accounts a
JOIN customers c ON c.customer_id = a.customer_id
JOIN transactions t ON t.account_id = a.account_id
GROUP BY a.account_id, c.customer_name
ORDER BY transaction_count DESC
LIMIT 10;

-- 4. Most active accounts by transaction volume
SELECT
    a.account_id,
    c.customer_name,
    a.account_number,
    COUNT(*) AS transaction_count,
    SUM(t.amount) AS total_volume,
    ROUND(AVG(t.amount), 2) AS average_transaction,
    SUM(t.amount) FILTER (WHERE t.transaction_type = 'debit') AS debit_volume,
    SUM(t.amount) FILTER (WHERE t.transaction_type = 'credit') AS credit_volume
FROM accounts a
JOIN customers c ON c.customer_id = a.customer_id
JOIN transactions t ON t.account_id = a.account_id
GROUP BY a.account_id, c.customer_name, a.account_number
ORDER BY total_volume DESC
LIMIT 10;

-- 5. Monthly transaction breakdown
SELECT
    DATE_TRUNC('month', transaction_date)::date AS month,
    COUNT(*) AS total_transactions,
    COUNT(*) FILTER (WHERE transaction_type = 'debit') AS debit_count,
    COUNT(*) FILTER (WHERE transaction_type = 'credit') AS credit_count,
    SUM(amount) FILTER (WHERE transaction_type = 'debit') AS debit_volume,
    SUM(amount) FILTER (WHERE transaction_type = 'credit') AS credit_volume,
    SUM(amount) AS total_volume,
    ROUND(AVG(amount), 2) AS average_transaction
FROM transactions
GROUP BY 1
ORDER BY 1;

-- 6. Yearly transaction breakdown
SELECT
    DATE_TRUNC('year', transaction_date)::date AS year,
    COUNT(*) AS total_transactions,
    SUM(amount) FILTER (WHERE transaction_type = 'debit') AS debit_volume,
    SUM(amount) FILTER (WHERE transaction_type = 'credit') AS credit_volume,
    SUM(amount) AS total_volume
FROM transactions
GROUP BY 1
ORDER BY 1;

-- 7. Top 20 customers by credit volume
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(t.transaction_id) AS credit_transaction_count,
    SUM(t.amount) AS total_credit_volume
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transactions t ON t.account_id = a.account_id
WHERE t.transaction_type = 'credit'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_credit_volume DESC
LIMIT 20;

-- 8. Customers with no transaction activity in the last 12 months
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    MAX(t.transaction_date) AS last_transaction_date
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING MAX(t.transaction_date) IS NULL
    OR MAX(t.transaction_date) < CURRENT_DATE - INTERVAL '12 months'
ORDER BY last_transaction_date NULLS FIRST;

-- 9. Single-account customers
SELECT
    c.customer_id,
    c.customer_name,
    MIN(a.account_type) AS account_type,
    COUNT(a.account_id) AS total_accounts
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(a.account_id) = 1
ORDER BY c.customer_id;

-- 10. Most-used transaction services
SELECT
    description,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_volume,
    ROUND(AVG(amount), 2) AS average_transaction
FROM transactions
GROUP BY description
ORDER BY transaction_count DESC, total_volume DESC;

-- 11. City-level performance
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT a.account_id) AS accounts,
    COUNT(t.transaction_id) AS transactions,
    COALESCE(SUM(t.amount), 0) AS transaction_volume,
    ROUND(AVG(t.amount), 2) AS average_transaction
FROM customers c
LEFT JOIN accounts a ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY c.city
ORDER BY transaction_volume DESC;

-- 12. Customer engagement by city
WITH customer_activity AS (
    SELECT
        c.customer_id,
        c.city,
        MAX(t.transaction_date) AS last_transaction_date
    FROM customers c
    LEFT JOIN accounts a ON a.customer_id = c.customer_id
    LEFT JOIN transactions t ON t.account_id = a.account_id
    GROUP BY c.customer_id, c.city
)
SELECT
    city,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE last_transaction_date >= CURRENT_DATE - INTERVAL '12 months'
    ) AS active_customers,
    COUNT(*) FILTER (
        WHERE last_transaction_date < CURRENT_DATE - INTERVAL '12 months'
           OR last_transaction_date IS NULL
    ) AS dormant_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE last_transaction_date >= CURRENT_DATE - INTERVAL '12 months'
        ) / NULLIF(COUNT(*), 0), 2
    ) AS active_rate_pct
FROM customer_activity
GROUP BY city
ORDER BY active_rate_pct DESC;

-- 13. Highest-spending customer in each city
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        SUM(t.amount) AS total_spend
    FROM customers c
    JOIN accounts a ON a.customer_id = c.customer_id
    JOIN transactions t ON t.account_id = a.account_id
    WHERE t.transaction_type = 'debit'
    GROUP BY c.customer_id, c.customer_name, c.city
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY city
               ORDER BY total_spend DESC
           ) AS city_rank
    FROM customer_spending
)
SELECT city, customer_name, total_spend
FROM ranked
WHERE city_rank = 1
ORDER BY city;
