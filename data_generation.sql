-- Generate synthetic banking data
-- No real customer or personal data is used.

-- 1. Customers
INSERT INTO customers (customer_name, gender, dob, signup_date, city)
SELECT
    'Customer ' || LPAD(gs::text, 3, '0'),
    CASE WHEN random() < 0.5 THEN 'M' ELSE 'F' END,
    DATE '1970-01-01' + (trunc(random() * 10000)::int),
    CURRENT_DATE - (trunc(random() * 1095)::int),
    (ARRAY[
        'Lagos', 'Abuja', 'Port Harcourt', 'Enugu', 'Kano', 'Ibadan',
        'Jos', 'Abeokuta', 'Calabar', 'Owerri', 'Benin City', 'Kaduna'
    ])[floor(random() * 12 + 1)::int]
FROM generate_series(1, 200) AS gs;

-- 2. Accounts: every customer receives one account; some receive a second.
INSERT INTO accounts (customer_id, account_number, account_type, open_date, balance)
SELECT
    c.customer_id,
    LPAD(((c.customer_id * 1000000) + gs.n * 100000 + floor(random() * 100000))::bigint::text, 10, '0'),
    (ARRAY['savings', 'current', 'loan'])[floor(random() * 3 + 1)::int],
    c.signup_date + trunc(random() * 90)::int,
    round((1000 + random() * 499000)::numeric, 2)
FROM customers c
CROSS JOIN LATERAL generate_series(1, 2) AS gs(n)
WHERE gs.n = 1 OR random() < 0.75;

-- 3. Transactions: approximately 1,000 records.
INSERT INTO transactions (account_id, transaction_type, amount, transaction_date, description)
SELECT
    a.account_id,
    CASE WHEN random() < 0.5 THEN 'debit' ELSE 'credit' END,
    round((500 + random() * 249500)::numeric, 2),
    CURRENT_DATE - trunc(random() * 730)::int,
    CASE
        WHEN random() < 0.5 THEN
            (ARRAY[
                'Salary credit', 'Bank transfer', 'Loan disbursement',
                'Wallet top-up', 'Refund', 'Cash deposit',
                'Customer payment', 'Online payment'
            ])[floor(random() * 8 + 1)::int]
        ELSE
            (ARRAY[
                'POS payment', 'Airtime recharge', 'Fuel purchase',
                'Utility bill', 'Loan repayment', 'Rent payment',
                'Online purchase', 'ATM withdrawal',
                'Subscription payment', 'Insurance payment',
                'Bank transfer'
            ])[floor(random() * 11 + 1)::int]
    END
FROM accounts a
CROSS JOIN generate_series(1, 10) AS gs
ORDER BY random()
LIMIT 1000;

-- Validation checks
SELECT COUNT(*) AS customer_count FROM customers;
SELECT COUNT(*) AS account_count FROM accounts;
SELECT COUNT(*) AS transaction_count FROM transactions;

SELECT transaction_type, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_type;
