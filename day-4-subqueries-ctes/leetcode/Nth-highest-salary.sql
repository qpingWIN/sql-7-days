-- ============================================================
-- Problem:    Nth Highest Salary
-- Source:     LeetCode - https://leetcode.com/problems/nth-highest-salary/description/
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
 

Write a solution to find the nth highest distinct salary from the Employee table. If there are less than n distinct salaries, return null.

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
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| null                   |
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE M INT;
    SET M = N - 1;
    RETURN (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        LIMIT 1 OFFSET M
    );
END

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Same shape as the previous problem, single value out, NULL when no answer exists but now N is a runtime parameter. That changes the strategy choice.
LeetCode hands me a function skeleton with CREATE FUNCTION and RETURNS INT, so the query just goes inside RETURN. First attempt was straightforward:
RETURN (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET N-1
);
Two problems with this. First, MySQL's older versions (which LeetCode uses) don't accept arbitrary expressions in OFFSET and thus N-1 gets rejected. Need to precompute it into a variable using DECLARE and SET at the top of the function body, before RETURN runs.
Second, there was an instinct to wrap the inner query in another SELECT to handle the "no Nth salary exists" NULL case, like in the previous problem. But that wrapper isn't needed here as RETURN (subquery) inside a function already converts an empty result into NULL automatically. 
The function's RETURNS INT declaration handles the wrapping.
Final version:
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE M INT;
    SET M = N - 1;
    RETURN (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        LIMIT 1 OFFSET M
    );
END
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
When a problem has a parameter like N, rank-thinking beats set-thinking. MAX-style approaches require structural nesting that can't be parameterized in plain SQL. ORDER BY plus LIMIT/OFFSET scales with arithmetic, which is what I want.
MySQL is picky about LIMIT and OFFSET arguments. Older versions only accept literals or simple variables, not expressions. The workaround is to DECLARE a variable, SET it to the computed value, and use the variable in OFFSET. DECLARE has to come at the very start of the BEGIN...END block because once you've started running statements, you can't declare new variables.
The "wrap in SELECT to turn zero rows into NULL" trick from the previous problem isn't always needed. It depends on the context. Inside a function declared with RETURNS INT, the RETURN statement already handles the empty-result-to-NULL conversion. Adding another wrapper layer works but is redundant.
 The general rule: only add the wrapper when the surrounding context doesn't already guarantee a single-value result.
*/
