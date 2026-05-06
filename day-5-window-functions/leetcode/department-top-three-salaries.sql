-- ============================================================
-- Problem:    Department Top Three Salaries
-- Source:     LeetCode - https://leetcode.com/problems/department-top-three-salaries/
-- Difficulty: Hard
-- Day:        5
-- Date:       06/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
[paste schema and problem text]
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH ranked AS (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rnk
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM ranked
WHERE rnk <= 3;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Same family as Department Highest Salary from Day 4, but instead of filtering to rank = 1, filter to rank <= 3.
Easy Window FUnction application: PARTITION BY departmentId to reset ranking for each department, ORDER BY salary DESC to rank highest salaries first.
DENSE_RANK() is the right ranking function as if two people tie at rank 2, both appear, and rank 3 still exists. RANK() would skip rank 3 after a tie at 2, potentially dropping valid employees. ROW_NUMBER() would arbitrarily break ties, also wrong.
First attempt had several structural issues:

Window function wrapped in a SELECT-list subquery - invalid, returns a column not a scalar
WHERE top_rank <= 3 on the window function alias — WHERE runs before window functions are computed

Fix: compute the rank inside a CTE, filter on it in the outer query.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
CTE is the standard wrapper for window function filtering. Compute the window function inside the CTE, filter on the result in the outer query. 
WHERE can't reference window functions directly as they don't exist yet at that stage.
DENSE_RANK vs RANK matters for "top N" problems with ties. RANK skips ranks after ties (1,2,2,4), potentially excluding valid rows. 
DENSE_RANK never skips (1,2,2,3), so all employees within the top N ranks always appear.
PARTITION BY scopes the ranking per group. Without it, ranking would be global across all departments and rank 1 would be the single highest-paid employee in the company, not per department.


*/
