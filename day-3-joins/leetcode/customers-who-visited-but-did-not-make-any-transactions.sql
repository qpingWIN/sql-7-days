-- ============================================================
-- Problem:    Customers Who Visited But Did Not Make Any Transactions
-- Source:     LeetCode - https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/
-- Difficulty: Easy
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Visits

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
visit_id is the column with unique values for this table.
This table contains information about the customers who visited the mall.
 

Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
transaction_id is column with unique values for this table.
This table contains information about the transactions made during the visit_id.
 

Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

Return the result table sorted in any order.

The result format is in the following example.

 

Example 1:

Input: 
Visits
+----------+-------------+
| visit_id | customer_id |
+----------+-------------+
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |
+----------+-------------+
Transactions
+----------------+----------+--------+
| transaction_id | visit_id | amount |
+----------------+----------+--------+
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |
+----------------+----------+--------+
Output: 
+-------------+----------------+
| customer_id | count_no_trans |
+-------------+----------------+
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
+-------------+----------------+
Explanation: 
Customer with id = 23 visited the mall once and made one transaction during the visit with id = 12.
Customer with id = 9 visited the mall once and made one transaction during the visit with id = 13.
Customer with id = 30 visited the mall once and did not make any transactions.
Customer with id = 54 visited the mall three times. During 2 visits they did not make any transactions, and during one visit they made 3 transactions.
Customer with id = 96 visited the mall once and did not make any transactions.
As we can see, users with IDs 30 and 96 visited the mall one time without making any transactions. Also, user 54 visited the mall twice and did not make any transactions.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT v.customer_id AS customer_id, COUNT(*) AS count_no_trans
FROM visits v
LEFT JOIN transactions t ON v.visit_id = t.visit_id
WHERE t.visit_id IS NULL
GROUP BY v.customer_id;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Recognized the anti-join shape. "Visited but did not make transactions" = visits with no matching row in transactions. Same pattern as Problem 3, but per-customer counts instead of just listing names.
Picked LEFT JOIN + IS NULL. Preserves all visits, pads unmatched ones with NULL on the transactions side.
Filtered with WHERE t.visit_id IS NULL to keep only unmatched (= no-transaction) visits. Tested the foreign key column on the right side.
Grouped by customer to count per customer. Each customer becomes one output row; COUNT(*) counts the no-transaction visits within their bucket.
Used COUNT(*) not COUNT(t.column). After the IS NULL filter, every t. column is NULL so COUNT(t.column) would return 0 because COUNT of a column ignores NULLs. COUNT(*) counts rows directly.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
GROUP BY collapses rows into buckets. Each unique value in the grouped column becomes one output row; aggregates run within each bucket.
The cardinal rule: every column in SELECT must be either grouped or aggregated. Mixing a raw column with an aggregate without GROUP BY throws an error.
COUNT(*) vs COUNT(column):

COUNT(*) counts rows, NULL-blind.
COUNT(column) counts only non-NULL values in that column.
COUNT(DISTINCT column) counts unique non-NULL values.


After a LEFT JOIN, the right-side columns are the ones that get NULL-padded. Left-side columns (especially the primary key) remain intact. I have to trace which side is which before applying NULL logic.
Always group by columns from the preserved (left) side of an anti-join, never from the right side because those are NULL after filtering.


*/
