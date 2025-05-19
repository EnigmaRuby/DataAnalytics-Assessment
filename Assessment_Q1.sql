-- Query to find high-value customers with both funded savings and investment plans
-- Returns owner_id, name, count of savings plans, count of investment plans, and total deposits in naira
-- Only includes customers who have at least one funded savings plan AND one funded investment plan

SELECT  
    u.id AS owner_id,
    u.name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    ROUND(COALESCE(d.total_deposits, 0) / 100.0, 2) AS total_deposits  -- Convert from kobo to naira
FROM users_customuser u

-- Count funded savings plans per user
LEFT JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1 AND amount > 0
    GROUP BY owner_id
) s ON u.id = s.owner_id

-- Count funded investment plans per user
LEFT JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1 AND amount > 0
    GROUP BY owner_id
) i ON u.id = i.owner_id

-- Sum total deposits per user
LEFT JOIN (
    SELECT 
        owner_id,
        SUM(amount) AS total_deposits
    FROM plans_plan
    WHERE amount > 0
    GROUP BY owner_id
) d ON u.id = d.owner_id

-- Filter only users with both savings and investment plans
WHERE COALESCE(s.savings_count, 0) > 0
  AND COALESCE(i.investment_count, 0) > 0

ORDER BY total_deposits DESC
LIMIT 1000;
