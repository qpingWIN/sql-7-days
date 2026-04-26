-- ============================================================
-- Problem:    Class More Than 5 Students
-- Source:     LeetCode - https://leetcode.com/problems/classes-with-at-least-5-students/description/
-- Difficulty: Easy 
-- Day:        2    
-- Date:       26/04/2026
-- ============================================================

/*
PROBLEM STATEMENT

Table: Courses

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
(student, class) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the name of a student and the class in which they are enrolled.
 

Write a solution to find all the classes that have at least five students.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Courses table:
+---------+----------+
| student | class    |
+---------+----------+
| A       | Math     |
| B       | English  |
| C       | Math     |
| D       | Biology  |
| E       | Math     |
| F       | Computer |
| G       | Math     |
| H       | Math     |
| I       | Math     |
+---------+----------+
Output: 
+---------+
| class   |
+---------+
| Math    |
+---------+
Explanation: 
- Math has 6 students, so we include it.
- English has 1 student, so we do not include it.
- Biology has 1 student, so we do not include it.
- Computer has 1 student, so we do not include it.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT class FROM courses
GROUP BY class HAVING count(student) >= 5

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
One class so GROUP BY class.
At least 5 students. This is a condition on an aggregate (the count),
not on a raw column value, so it goes in HAVING not WHERE.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
COUNT(*) counts all rows including NULLs.
COUNT(column) counts only rows where that column is not NULL.
WHERE would run before grouping happens and the count doesn't exist yet
at that point. HAVING runs after grouping, where the count already exists.

GROUP BY collapses all rows that share the same value into one row,
so you can run aggregate functions on each group. The result has one
row per unique value of the grouped column.
*/
