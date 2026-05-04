-- ============================================================
-- Problem:    Duplicate Emails
-- Source:     LeetCode - https://leetcode.com/problems/duplicate-emails/description/
-- Difficulty: Easy
-- Day:        4
-- Date:       04/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.
 

Write a solution to report all the duplicate emails. Note that it's guaranteed that the email field is not NULL.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Person table:
+----+---------+
| id | email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
Output: 
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
Explanation: a@b.com is repeated two times.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT email as Email
from Person
GROUP BY email
HAVING COUNT(email)>1

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Need emails appearing more than once thus group by email, count per group, filter to count > 1
WHERE runs before aggregation, can't reference COUNT(*) there
HAVING is the post-aggregation filter which is exactly what's needed
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
GROUP BY doesn't immediately collapse rows — it organizes them into buckets, runs aggregates inside each bucket (which can see all rows there), then outputs one row per bucket
WHERE filters rows before grouping; HAVING filters groups after aggregating. Aggregates only exist after GROUP BY runs, so they belong in HAVING, not WHERE
The golden rule of GROUP BY now makes intuitive sense: plain columns are safe only when every row in a bucket shares the same value 
(i.e. it's the grouped column itself); otherwise the engine has multiple values to choose from with no rule
*/
