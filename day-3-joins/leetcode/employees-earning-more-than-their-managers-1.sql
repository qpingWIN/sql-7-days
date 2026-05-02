-- ============================================================
-- Problem:    Employees Earning More Than Their Managers
-- Source:     LeetCode - https://leetcode.com/problems/employees-earning-more-than-their-managers/
-- Difficulty: Easy
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
 

Write a solution to find the employees who earn more than their managers.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
Output: 
+----------+
| Employee |
+----------+
| Joe      |
+----------+
Explanation: Joe is the only employee who earns more than his manager.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON m.id = e.managerId
WHERE e.salary > m.salary;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Spotted the self-join setup. The schema has one Employee table containing both employees and managers they're stored as rows in the same table, linked by managerId pointing to
another row's id. To compare an employee's salary to their manager's salary, I need both on the same row, which means joining the table to itself with two aliases.
Picked e for the employee role and m for the manager role. The choice of letters is arbitrary, what matters is mentally locking in which alias plays which role.
Wrote the join condition: m.id = e.managerId "match the manager row whose id equals this employee's managerId." This glues each employee to their manager on a single row.
Chose INNER JOIN over LEFT JOIN. Employees with no manager are useless for this task because there's nothing to compare against. INNER JOIN drops them automatically, which is exactly what I want.
(And as I worked out earlier, LEFT JOIN would let them through, but the WHERE e.salary > m.salary would then silently filter them out anyway since salary > NULL is UNKNOWN.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Self-join mental model: when one table contains rows that relate to other rows in the same table, alias it twice and treat it as two virtual tables. One alias per "role".
NULL comparisons return UNKNOWN, not FALSE. WHERE only keeps TRUE rows, so UNKNOWN rows get filtered out, same effect as FALSE in this context, but the distinction matters in OR/NOT logic.
A WHERE filter on a right-side column silently converts a LEFT JOIN into an INNER JOIN. Worth knowing both as a trap to avoid and as a signal that I needed INNER JOIN to begin with.
*/
