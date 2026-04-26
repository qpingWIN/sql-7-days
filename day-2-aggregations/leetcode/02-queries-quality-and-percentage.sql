-- ============================================================
-- Problem:    Queries Quality and Percentage
-- Source:     LeetCode - https://leetcode.com/problems/queries-quality-and-percentage/description/
-- Difficulty: Easy
-- Day:        2
-- Date:       26/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Queries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
This table may have duplicate rows.
This table contains information collected from some queries on a database.
The position column has a value from 1 to 500.
The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.
 

We define query quality as:

The average of the ratio between query rating and its position.

We also define poor query percentage as:

The percentage of all queries with rating less than 3.

Write a solution to find each query_name, the quality and poor_query_percentage.

Both quality and poor_query_percentage should be rounded to 2 decimal places.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Queries table:
+------------+-------------------+----------+--------+
| query_name | result            | position | rating |
+------------+-------------------+----------+--------+
| Dog        | Golden Retriever  | 1        | 5      |
| Dog        | German Shepherd   | 2        | 5      |
| Dog        | Mule              | 200      | 1      |
| Cat        | Shirazi           | 5        | 2      |
| Cat        | Siamese           | 3        | 3      |
| Cat        | Sphynx            | 7        | 4      |
+------------+-------------------+----------+--------+
Output: 
+------------+---------+-----------------------+
| query_name | quality | poor_query_percentage |
+------------+---------+-----------------------+
| Dog        | 2.50    | 33.33                 |
| Cat        | 0.66    | 33.33                 |
+------------+---------+-----------------------+
Explanation: 
Dog queries quality is ((5 / 1) + (5 / 2) + (1 / 200)) / 3 = 2.50
Dog queries poor_ query_percentage is (1 / 3) * 100 = 33.33

Cat queries quality equals ((2 / 5) + (3 / 3) + (4 / 7)) / 3 = 0.66
Cat queries poor_ query_percentage is (1 / 3) * 100 = 33.33
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT query_name,
    ROUND(AVG(rating / position), 2) AS quality,
    ROUND(SUM(rating < 3) / COUNT(*) * 100, 2) AS poor_query_percentage
FROM Queries
GROUP BY query_name;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
What does one row in my output represent?
One query name — so GROUP BY query_name.

What am I calculating per group?
Two metrics:

1. Quality defined as average of (rating / position) per query.
   Calculate the ratio per row first, then average across the group:
   AVG(rating / position).

2. Poor query percentage is percentage of rows where rating < 3.
   Need to count how many rows satisfy the condition, divide by
   total rows, multiply by 100.
   SUM(rating < 3) counts the poor rows — in MySQL, a boolean
   expression evaluates to 1 (true) or 0 (false), so summing it
   counts how many rows satisfy the condition.
   Divide by COUNT(*) for total rows, multiply by 100 for percentage.

No HAVING needed — problem asks for all query names, no group filter.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
AVG of an expression. MySQL calculates the expression per row first,
then averages the results across the group:
  AVG(rating / position) computes rating/position for each row,
  then takes the average of those values.

Conditional counting, two equivalent approaches:
  SUM(condition) - MySQL only, concise
  SUM(CASE WHEN condition THEN 1 ELSE 0 END) - ANSI standard, portable

In MySQL, boolean expressions evaluate to 1 (true) or 0 (false).
SUM(rating < 3) exploits this to count rows where rating < 3.
*/
