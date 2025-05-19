-- Calculate transaction frequency categories for customers
WITH customer_monthly_transactions AS (
    -- Count transactions per customer per month
    SELECT
        owner_id,
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount
    GROUP BY owner_id, year, month
),

customer_avg_transactions AS (
    -- Calculate average transactions per month for each customer
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month
    FROM customer_monthly_transactions
    GROUP BY owner_id
)

SELECT
    -- Categorize customers based on their average monthly transactions
    CASE
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,

    -- Count of customers in each frequency category
    COUNT(*) AS customer_count,

    -- Average transactions per month within each category, rounded to 2 decimals
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month

FROM customer_avg_transactions
GROUP BY frequency_category
ORDER BY
    -- Order results in logical frequency order
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
