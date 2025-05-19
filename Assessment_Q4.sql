SELECT
    u.id AS customer_id,

    -- Use name if available, otherwise use first_name + last_name
    COALESCE(NULLIF(TRIM(u.name), ''), CONCAT(TRIM(u.first_name), ' ', TRIM(u.last_name))) AS name,

    -- Calculate tenure in months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

    -- Count of total transactions per customer (assuming each savings account record is a transaction)
    COUNT(s.id) AS total_transactions,

    -- Total transaction value in naira
    SUM(s.confirmed_amount) / 100.0 AS total_transaction_value,

    -- Estimated CLV
    CASE
        WHEN COUNT(s.id) = 0 OR TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) = 0 THEN 0
        ELSE
            ((COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12) *
            (0.001 * (SUM(s.confirmed_amount) / 100.0) / COUNT(s.id))
    END AS estimated_clv

FROM
    users_customuser u
LEFT JOIN
    savings_savingsaccount s ON s.owner_id = u.id

GROUP BY
    u.id, u.name, u.first_name, u.last_name, u.date_joined

ORDER BY
    estimated_clv DESC

LIMIT 1000;


