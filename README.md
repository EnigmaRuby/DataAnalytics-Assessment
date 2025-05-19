# Data Analytics Assessment

This repository contains SQL solutions for the Data Analyst assessment. Each solution addresses a real-world business scenario using SQL for data exploration, aggregation, and analysis.

Assessment Questions & Approach

Q1: High-Value Customers with Multiple Products

Objective:  
Identify customers who have both a savings and an investment plan (cross-selling opportunity).

Tables Used: 
- `users_customuser`  
- `savings_savingsaccount`  
- `plans_plan`

Approach:  
- Joined `savings_savingsaccount` with `plans_plan` using `plan_id`.
- Identified savings plans (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`).
- Grouped by `owner_id` and filtered for customers who have at least one of each type.
- Aggregated total deposits using `confirmed_amount` and converted kobo to naira.
- Sorted results by total deposits.


Q2: Transaction Frequency Analysis

Objective: 
Segment customers based on the frequency of their savings transactions.

Tables Used:  
- `users_customuser`  
- `savings_savingsaccount`

Approach:  
- Counted transactions per customer from `savings_savingsaccount`.
- Computed account tenure (in months) using `date_joined`.
- Derived average monthly transactions = total transactions / tenure.
- Used `CASE` to assign each customer to frequency categories:
  - High Frequency (≥10/month)
  - Medium Frequency (3–9/month)
  - Low Frequency (≤2/month)
- Aggregated customer count and average per category.



Q3: Account Inactivity Alert

Objective:  
Find active plans (savings or investment) with no inflow transactions in the last 365 days.

Tables Used  
- `plans_plan`  
- `savings_savingsaccount`

Approach:  
- Retrieved the last transaction date from `savings_savingsaccount` per plan.
- Computed the number of days since the last inflow.
- Filtered for plans with inactivity over 365 days.
- Used `CASE` to classify each plan as "Savings" or "Investment".
- Returned relevant plan details and inactivity duration.



Q4: Customer Lifetime Value (CLV) Estimation

Objective:  
Estimate CLV using account tenure and transaction behavior.

Tables Used: 
- `users_customuser`  
- `savings_savingsaccount`

Approach:  
- Calculated tenure in months using `date_joined`.
- Counted total inflow transactions per customer.
- Computed average profit per transaction (0.1% of `confirmed_amount`).
- Applied the CLV formula:  
  `CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction`
- Sorted customers by estimated CLV in descending order.
- Used `COALESCE` and fallback logic to handle null or missing name fields.



Challenges Encountered

- Missing `signup_date` column: 
  The user table lacked a `signup_date`. I used the available `date_joined` as a substitute for calculating tenure.

- Null or blank names:  
  Some records had empty or null `name` fields. I handled this using:
  ```sql
  COALESCE(NULLIF(TRIM(u.name), ''), CONCAT(TRIM(u.first_name), ' ', TRIM(u.last_name)))

- Initial 0-row output in some queries:
  Some queries initially returned no results due to over-filtering or incorrect joins. I tested join logic incrementally and adjusted conditions to match available data.

- Monetary amounts in kobo:
  All amounts were in kobo. I consistently divided by 100.0 to display values in naira.

- Limited timestamp granularity:
  Some transaction records lacked detailed timestamps, so I relied on available created or last_charge_date fields to infer activity timelines.



Author
Abisola Adeyeye
Data Analyst Candidate
GitHub: https://github.com/EnigmaRuby
LinkedIn: http://linkedin.com/in/abisola-adeyeye-488126145


