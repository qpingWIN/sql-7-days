-- ============================================================
-- Problem:    Histogram of Users and Purchases
-- Source:     DataLemur - https://datalemur.com/questions/histogram-users-purchases
-- Difficulty: Medium
-- Day:        5
-- Date:       18/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.

user_transactions Table:
Column Name	Type
product_id	integer
user_id	integer
spend	decimal
transaction_date	timestamp
user_transactions Example Input:
product_id	user_id	spend	transaction_date
3673	123	68.90	07/08/2022 12:00:00
9623	123	274.10	07/08/2022 12:00:00
1467	115	19.90	07/08/2022 12:00:00
2513	159	25.00	07/08/2022 12:00:00
1452	159	74.50	07/10/2022 12:00:00
Example Output:
transaction_date	user_id	purchase_count
07/08/2022 12:00:00	115	1
07/08/2022 12:00:000	123	2
07/10/2022 12:00:00	159	1

*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

with recent as (SELECT ROW_NUMBER() OVER (PARTITION BY user_id
                          ORDER BY transaction_date desc) as recent_p,
  user_id, count(product_id) as purchase_count, transaction_date
FROM user_transactions
group by user_id, transaction_date)
select transaction_date, user_id, purchase_count
from recent
where recent_p = 1
order by transaction_date

--OR THIS---
WITH urd AS (SELECT user_id, MAX(transaction_date) as recent_date
FROM user_transactions
GROUP BY user_id
)
SELECT urd.recent_date, urd.user_id, COUNT(*) as purchase_count
FROM user_transactions
JOIN urd ON urd.user_id = user_transactions.user_id 
                AND urd.recent_date=user_transactions.transaction_date
GROUP BY urd.user_id, urd.recent_date
ORDER BY urd.recent_date;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Goal: count purchases on each user's most recent transaction date.

CTE urd finds MAX(transaction_date) per user.
Join back to user_transactions on (user_id, date), keeps only rows from that latest date.
COUNT(*) per user returns number of purchases on that day.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Have to list every non-aggregated SELECT column in GROUP BY.

Window alternative: ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) then filter = 1. Often faster, single pass over the table worth knowing
*/
