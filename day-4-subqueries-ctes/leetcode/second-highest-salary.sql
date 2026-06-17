-- ============================================================
-- Problem:    Second Highest Salary
-- Source:     LeetCode - https://leetcode.com/problems/second-highest-salary/description/
-- Difficulty: Medium
-- Day:        4
-- Date:       03/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
 

Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;

--OR THIS--
with ranked AS(SELECT DENSE_RANK() OVER (ORDER BY salary DESC) as rnk, 
salary
FROM Employee)
SELECT MAX(salary) as SecondHighestSalary
from ranked
WHERE rnk=2


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
The output is a single value: either a salary, or NULL if there's no second-highest. This shape constraint matters because it dictates how we wrap the final query.
There are two natural angles to attack this. Rank-thinking: sort all distinct salaries descending and grab position 2. Set-thinking: take the max salary, excluding the overall max.
Going with rank-thinking first therefore sort descending, deduplicate, skip one, take one:
SELECT DISTINCT salary
FROM Employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
This breaks on the edge case though. If only one salary exists, the query returns zero rows, but LeetCode wants NULL, meaning one row containing a null value. Different shapes entirely.
The fix is a scalar subquery. When a scalar subquery returns no rows, it evaluates to NULL automatically:

SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;

The set-thinking version sidesteps the edge case entirely. "Max salary that's less than the overall max":
SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

No wrapping needed. MAX() on an empty input returns NULL, and aggregates always produce exactly one row.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
LIMIT N OFFSET M takes N rows after skipping M. OFFSET is zero-indexed, so OFFSET 1 skips the first row.
Zero rows is not the same as NULL. They're different result shapes. LeetCode-style problems often demand "one row with NULL" when the answer is missing, which the bare LIMIT/OFFSET query doesn't produce on its own.
Wrapping a query in SELECT (...) converts "zero or one rows" into "always one row, possibly NULL". Useful trick for edge-case handling.
Aggregates always return one row, even on empty input. MAX() of nothing is NULL, not an error and not zero rows. That's why the MAX() approach handles the edge case for free.
Two mental models for ranking problems. Rank-thinking with ORDER BY + LIMIT/OFFSET generalizes well to Nth-highest. Set-thinking with MAX() of a filtered set is concise for 2nd-highest but gets awkward beyond that.
Subquery shape rules: in SELECT it must be scalar, in FROM it must be a table with an alias, in WHERE it can be scalar (with =, <, etc.) or a list (with IN).
Correlated vs uncorrelated test: cover the outer query with your hand. If the inner query can run alone, it's uncorrelated and runs once. If it references outer columns, it's correlated and re-runs per outer row. 
Same table on both sides doesn't mean uncorrelated, what matters is whether the inner result depends on the current outer row.
*/
