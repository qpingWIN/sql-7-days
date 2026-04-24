-- ============================================================
-- Problem:    Find Customer Referee
-- Source:     LeetCode — https://leetcode.com/problems/find-customer-referee/description/
-- Difficulty: Easy
-- Day:        1
-- Date:       24/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
In SQL, id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
 

Find the names of the customer that are either:

referred by any customer with id != 2.
not referred by any customer.
Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+
Output: 
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT name from Customer
    WHERE referee_id != 2
        OR referee_id IS NULL;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
-
Whenever I write a WHERE clause with a negative condition (!=, NOT IN, NOT LIKE), I ask myself: can this column be NULL? If yes, I add OR column IS NULL explicitly to avoid the NULL trap, because NULL != 2 is UNKNOWN, not TRUE, so rows with NULL referee_id would be excluded without the OR condition, which is not what we want here.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
TRUTH TABLE worth memorising:
TRUE AND TRUE = TRUE
TRUE AND FALSE = FALSE  
TRUE AND UNKNOWN = UNKNOWN
FALSE AND UNKNOWN = FALSE
UNKNOWN AND UNKNOWN = UNKNOWN
TRUE OR UNKNOWN = TRUE
FALSE OR UNKNOWN = UNKNOWN
NOT UNKNOWN = UNKNOWN


OR IS NULL fixes the NULL trap because i'm constructing a TRUE OR UNKNOWN situation for the rows I want to keep, which resolves to TRUE.

-- The NULL-safe negative filter pattern:
WHERE col != value
   OR col IS NULL

-- Or equivalently using COALESCE:
WHERE COALESCE(col, fallback) != value
-- (replace NULL with a value you know won't match)

COALESCE(a, b, c, ...) returns the first non-NULL value from its list of arguments. I use it to replace NULLs with a safe default before a comparison, avoiding the UNKNOWN trap.


A primary key uniquely identifies every row in a table. It must be unique and non-null. The database automatically indexes it, and other tables reference it via foreign keys.
*/
