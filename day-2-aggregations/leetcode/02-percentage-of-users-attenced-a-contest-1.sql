-- ============================================================
-- Problem:    Percentage of Users Attended a Contest
-- Source:     LeetCode — https://leetcode.com/problems/percentage-of-users-attended-a-contest/description/
-- Difficulty: Easy
-- Day:        2
-- Date:       26/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the primary key (column with unique values) for this table.
Each row of this table contains the name and the id of a user.
 

Table: Register

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id of a user and the contest they registered into.
 

Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+-----------+
| user_id | user_name |
+---------+-----------+
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |
+---------+-----------+
Register table:
+------------+---------+
| contest_id | user_id |
+------------+---------+
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |
+------------+---------+
Output: 
+------------+------------+
| contest_id | percentage |
+------------+------------+
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |
+------------+------------+
Explanation: 
All the users registered in contests 208, 209, and 210. The percentage is 100% and we sort them in the answer table by contest_id in ascending order.
Alice and Alex registered in contest 215 and the percentage is ((2/3) * 100) = 66.67%
Bob registered in contest 207 and the percentage is ((1/3) * 100) = 33.33%
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT contest_id,
       ROUND(COUNT(user_id) / (SELECT COUNT(*) FROM Users) * 100,2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
What does one row in my output represent?
One contest so GROUP BY contest_id.

What am I calculating per group?
The percentage of all users who registered for each contest.
Percentage = (users registered for contest / total users) * 100.

Two counts needed in the same query:
  - COUNT(user_id) per contest comes from GROUP BY on Register
  - Total user count — can't come from the same GROUP BY since
    it's a global count across all users, not per contest.

Solution: subquery in SELECT: SELECT COUNT(*) FROM Users runs
once and returns the total user count as a scalar value I can
divide by.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Scalar subquery returns exactly one row, one column (a single value).
When you need two different levels of aggregation in the same
query (per group AND global total), a scalar subquery in SELECT
is a clean solution — it runs once and returns a single value
you can use in the calculation.
Ordering: percentage DESC first, then contest_id ASC to break ties.
Multiple ORDER BY columns work left to right - primary sort first,
tiebreaker second.
*/
