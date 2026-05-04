-- ============================================================
-- Problem:    Department Highest Salary
-- Source:     LeetCode - https://leetcode.com/problems/department-highest-salary/description/
-- Difficulty: Medium
-- Day:        4
-- Date:       04/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference columns) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table. It is guaranteed that department name is not NULL.
Each row of this table indicates the ID of a department and its name.
 

Write a solution to find employees who have the highest salary in each of the departments.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output: 
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
Explanation: Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT 
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d ON e.departmentId = d.id
WHERE e.salary = (
    SELECT MAX(salary)
    FROM Employee
    WHERE departmentId = e.departmentId
);

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Schema is two tables: Employee with id/name/salary/departmentId, and Department with id/name. Need one row per (department, top-earner) pair, and ties have to all show up meaning if two people tie for highest in a department, both rows appear.
First instinct was to GROUP BY departmentId and pull MAX(salary). However, GROUP BY collapses rows into one per group, which kills the ability to return tied employees.
The actual operation needed is a filter, not an aggregation: keep an employee row if their salary equals the max salary within their department. No collapsing, no GROUP BY in the outer query.
That logic translates directly to a correlated subquery in WHERE:

The inner query references e.departmentId from the outer row. For each employee being examined, the engine recomputes MAX(salary) scoped to that employee's department, then checks whether the employee's salary matches it. Ties handle themselves — each tied employee passes the filter independently.
Alternative phrasing with a derived table joined back in:

SELECT 
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d ON e.departmentId = d.id
JOIN (
    SELECT departmentId, MAX(salary) AS max_sal
    FROM Employee
    GROUP BY departmentId
) AS dept_max 
  ON e.departmentId = dept_max.departmentId 
  AND e.salary = dept_max.max_sal;

Same logic, different shape. The aggregate gets pre-computed once into dept_max, then joined back on both departmentId and salary. Only employees whose salary matches their department's max survive the second join condition.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
The deepest lesson here is the mental model for correlated subqueries. The outer query isn't running in one shot, it's iterating, picking up one row at a time. The alias e doesn't refer to "the Employee table" abstractly, it refers to whichever row is currently being examined. 
So e.departmentId inside an inner query means "the departmentId of the outer row I'm currently holding still while I evaluate this." The inner query becomes parameterized by the outer row, and re-runs with a new parameter for every iteration.
GROUP BY is the wrong tool when ties need to be preserved. GROUP BY collapses by design — one output row per group. If the question is "filter to rows that match some per-group condition", that's a WHERE clause job, possibly with a correlated subquery or a derived-table JOIN to compute the per-group condition. 
The output keeps all qualifying rows, ties included.
Pre-aggregating into a derived table is a recurring pattern. Aggregate inside the subquery, then JOIN the result back to the original table on whatever condition links them. The aggregate becomes a regular column, and the outer query can filter or join on it freely. 
Often equivalent to a correlated subquery in WHERE, but expressed as a join instead.
The duality between "correlated subquery in WHERE" and "JOIN against a derived table" is something to internalize. Both express the same idea - "compare each row to a per-group computed value" but read differently. Correlated reads as "filter where this row equals the per-group max", which mirrors how you'd describe the problem in English. 
Derived-table-JOIN reads as a more mechanical construction but is often what optimizers translate correlated subqueries into anyway. I should pick the one that reads more clearly; performance is usually similar.
*/
