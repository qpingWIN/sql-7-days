-- ============================================================
-- Problem:    Monthly Transactions I
-- Source:     LeetCode - https://leetcode.com/problems/monthly-transactions-i/description/
-- Difficulty: Medium
-- Day:        4
-- Date:       04/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
 

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
The goal is one row per (month, country) combination, with four aggregate columns: total count, approved count, total amount, approved amount.
The "double loop over months and countries" instinct from my Python thinking translates directly to GROUP BY two columns as the engine handles the iteration.
Month extraction needed a function. DATE_FORMAT(trans_date, '%Y-%m') gives '2018-12' style strings. MONTH() alone strips the year, which fails when transactions span multiple years.

A WHERE filter on state = 'approved' would also remove declined rows from the unconditional count, breaking trans_count. 
Filter has to apply only to specific aggregates, not the whole query.
Solution is conditional aggregation: SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END). For each row in the bucket, the CASE contributes 1 for approved rows and 0 for declined ones. 
SUM totals those contributions. Net effect is counting only approved rows while keeping the declined rows in the bucket for COUNT(*) and SUM(amount).

*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
GROUP BY is how SQL expresses "loop over unique combinations of these columns and compute aggregates per combination". 
The procedural double-loop intuition maps cleanly — group by the two dimensions, and every aggregate in SELECT runs per bucket automatically.
Conditional aggregation is the pattern for computing multiple filtered aggregates side by side.
SUM(CASE WHEN condition THEN value ELSE 0 END) lets you aggregate just the matching subset of rows within a bucket,
while the non-matching rows still sit in the bucket contributing to other unconditional aggregates. CASE always closes with END.
A subquery in the SELECT list returns a scalar — one value per outer row. It can't return multiple columns. If you need multiple aggregates on the same buckets, 
they belong as separate items in the outer SELECT, not bundled into one subquery.
Aggregates in SELECT require GROUP BY. If the SELECT mixes plain columns with aggregates, every plain column needs to appear in GROUP BY. 
MySQL doesn't always let you reference SELECT-list aliases in GROUP BY or WHERE.
DATE_FORMAT with '%Y-%m' is the idiomatic way to bucket by year-month in MySQL. PostgreSQL would use TO_CHAR(trans_date, 'YYYY-MM') instead.
Subqueries earn their keep when you genuinely need a per-row computation that depends on outer context, not when you can express the same logic with grouping and conditional aggregation.
*/
