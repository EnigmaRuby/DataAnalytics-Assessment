SELECT
    p.id AS plan_id,                     -- Unique identifier for the plan
    p.owner_id,                         -- Owner (customer) identifier

    -- Determine plan type for easy classification:
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'   -- Flag for regular savings plans
        WHEN p.is_a_fund = 1 THEN 'Investment'         -- Flag for investment plans
        ELSE 'Other'                                   -- Any other plan types
    END AS type,

    -- Find the most recent inflow transaction date for each plan:
    MAX(s.transaction_date) AS last_transaction_date,

    -- Calculate how many days since the last inflow transaction:
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days

FROM
    plans_plan p

    -- Left join to savings_savingsaccount on plan_id, filtering only inflow transactions
    LEFT JOIN savings_savingsaccount s
        ON s.plan_id = p.id
        AND s.transaction_type_id IN (1, 2)  -- Transaction types representing inflows (e.g., deposits)

WHERE
    p.status_id = 1          -- Only active plans (status_id = 1 means active)
    AND p.is_deleted = 0     -- Exclude deleted plans

GROUP BY
    p.id, p.owner_id, type   -- Group results by plan and owner to aggregate transactions per plan

-- Filter to show only plans with no inflow transactions in the past 365 days:
HAVING
    MAX(s.transaction_date) IS NULL                   -- No transactions ever recorded for the plan
    OR DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365  -- Last inflow > 365 days ago

ORDER BY
    inactivity_days DESC   -- Sort by longest inactivity first

LIMIT 1000;              -- Limit output to 1000 records to control result size
