-- ============================================================
-- Problem:    User's Third Transaction
-- Source:     DataLemur - https://datalemur.com/questions/sql-third-transaction
-- Difficulty: Medium
-- Day:        5
-- Date:       18/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
This is the same question as problem #11 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

transactions Table:
Column Name	Type
user_id	integer
spend	decimal
transaction_date	timestamp
transactions Example Input:
user_id	spend	transaction_date
111	100.50	01/08/2022 12:00:00
111	55.00	01/10/2022 12:00:00
121	36.00	01/18/2022 12:00:00
145	24.99	01/26/2022 12:00:00
111	89.60	02/05/2022 12:00:00
Example Output:
user_id	spend	transaction_date
111	89.60	02/05/2022 12:00:00
The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH user_ranked AS(SELECT user_id, spend, transaction_date,
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) as urank
            FROM transactions
)
SELECT user_id, spend, transaction_date
FROM user_ranked
WHERE urank=3


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Need to rank transactions per user chronologically, then filter to rank 3.

PARTITION BY user_id, restart numbering per user
ORDER BY transaction_date -chronological order (earliest = rank 1)
ROW_NUMBER() guarantees unique sequential ranks (no ties, unlike RANK/DENSE_RANK)
CTE wraps the ranking so I can filter on urank in the outer query (can't use window functions in WHERE directly)
Filter urank = 3, keeps only the third transaction per user
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Why CTE is needed: window functions are evaluated after WHERE, so I can't write WHERE ROW_NUMBER() OVER (...) = 3 directly. CTE (or subquery) defers the filter to a later stage.
Tie-breaking gotcha: if two transactions share the same transaction_date for one user, ROW_NUMBER picks one non-deterministically. Add a tiebreaker (e.g. ORDER BY transaction_date, transaction_id) for reproducibility
*/
