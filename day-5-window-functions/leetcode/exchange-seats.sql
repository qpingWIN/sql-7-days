-- ============================================================
-- Problem:    Exchange Seats
-- Source:     Leetcode - https://leetcode.com/problems/exchange-seats/description/
-- Difficulty: Medium
-- Day:        5
-- Date:       08/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Seat

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key (unique value) column for this table.
Each row of this table indicates the name and the ID of a student.
The ID sequence always starts from 1 and increments continuously.
 

Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Seat table:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+
Output: 
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+
Explanation: 
Note that if the number of students is odd, there is no need to change the last one's seat.
 

*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH swapped AS (
    SELECT 
        id,
        student,
        LEAD(student) OVER (ORDER BY id) AS next,
        LAG(student) OVER (ORDER BY id) AS prev
    FROM Seat
)
SELECT id,
       CASE 
            WHEN (id%2=0) THEN prev
            WHEN (id%2=1) THEN COALESCE(next,student)
       END AS student
    
FROM swapped
ORDER BY id;

--OR THIS--
WITH combined AS (
    SELECT id,
           student,
           LAG(student) OVER (ORDER BY id) as prev,
           LEAD(student) OVER (ORDER BY id) as next,
           MAX(id) OVER () as max_id
    FROM Seat
)

SELECT id, CASE WHEN id % 2 = 1 AND id != max_id THEN next
                WHEN id % 2 = 0 THEN prev
                WHEN id % 2 =1 AND id = max_id THEN student
            END as student
FROM combined
ORDER BY id;
-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Need to swap adjacent pairs: odd-id rows take the next row's student, even-id rows take the previous row's student.
Edge case: if total students is odd, the last student has an odd id but no next row thus stays in place.
LAG and LEAD in a CTE to attach the previous and next student to each row, then CASE on id % 2 in the outer query to pick the right value per row.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
LAG/LEAD let you access adjacent row values without a self-join. Clean alternative to joining a table to itself on id = id - 1.
id % 2 is the standard odd/even split in SQL. 0 = even, 1 = odd.
COALESCE(val, fallback) returns the first non-null argument. Used here to handle the last-row edge case — if next is NULL (no next row exists), fall back to the current student, keeping them in place.
LAG/LEAD return NULL at boundaries automatically, no extra handling needed for the even case since the first row (id=1) will never be even, and the last row's prev always exists for even ids.
CTE + CASE is a clean pattern for "pick different columns per row based on a condition" and then compute all candidate values in the CTE, select among them with CASE outside.
*/
