-- ============================================================
-- Problem:    Consecutive Numbers
-- Source:     LeetCode - https://leetcode.com/problems/consecutive-numbers/
-- Difficulty: Medium
-- Day:        5
-- Date:       08/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH numbered AS (
    SELECT num,
           LAG(num) OVER (ORDER BY id) AS prev,
           LEAD(num) OVER (ORDER BY id) AS next
    FROM Logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM numbered
WHERE num=prev AND num=next

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
The output is the distinct numbers themselves, not a count. LAG and LEAD are the natural fit as for each row, look at the previous and next row's number. 
If all three match, that row is part of a consecutive run of 3+. First attempt had several issues:

Window function aliases referenced in the same SELECT level but it doesn't exist yet at that stage
Fix: compute LAG and LEAD in a CTE, filter in the outer query where the aliases are in scope.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
LAG(col) OVER (ORDER BY id) looks at the previous row's value. LEAD(col) OVER (ORDER BY id) looks at the next row's value. Both need a column argument and a proper window definition — OVER (table_name) is not valid syntax.
== is not SQL. Single = for equality always.
Window function aliases aren't accessible in the same SELECT level — same execution order issue as aggregates. CTE computes them first, outer query references them after.
DISTINCT matters for consecutive problems. The same number can appear consecutively in multiple separate runs and without DISTINCT, it shows up in output multiple times.
LAG/LEAD default to NULL at boundaries. The first row has no previous row, so prev is NULL. num = NULL is UNKNOWN, not TRUE — so boundary rows are automatically excluded from the WHERE filter without any extra handling needed.
*/
