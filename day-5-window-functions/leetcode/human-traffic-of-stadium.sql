-- ============================================================
-- Problem:    Human Traffic of Stadium
-- Source:     LeetCode - https://leetcode.com/problems/human-traffic-of-stadium/description/
-- Difficulty: Hard
-- Day:        5
-- Date:       08/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Stadium

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date is the column with unique values for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
As the id increases, the date increases as well.
 

Write a solution to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Stadium table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
Output: 
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
Explanation: 
The four rows with ids 5, 6, 7, and 8 have consecutive ids and each of them has >= 100 people attended. Note that row 8 was included even though the visit_date was not the next day after row 7.
The rows with ids 2 and 3 are not included because we need at least three consecutive ids.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH flagged AS (
    SELECT id, visit_date, people,
        LAG(people) OVER (ORDER BY id) AS prev1,
        LAG(people, 2) OVER (ORDER BY id) AS prev2,
        LEAD(people) OVER (ORDER BY id) AS next1,
        LEAD(people, 2) OVER (ORDER BY id) AS next2
    FROM Stadium
)
SELECT id, visit_date, people
FROM flagged
WHERE (prev1>=100 AND prev2>=100 AND people>=100)
      OR (prev1>=100 AND people>=100 AND next1>=100)
      OR (people>=100 AND next1>=100 AND next2>=100)
ORDER BY id;
-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Same family as Consecutive Numbers but with two differences: the condition is people >= 100 instead of value equality, and the run length is 3 or more instead of exactly 3.
Rvery row in a valid run of 3+ must be part of at least one window of exactly 3 consecutive qualifying rows. So instead of detecting full run length, just check whether the current row participates in any 3-consecutive window.
Three possible positions:
    Current row is the start thus it and the next two qualify
    Current row is the middle thus the one before, it, and the next qualify
    Current row is the end thus the two before and it qualify

LAG(people, 2) and LEAD(people, 2) extend the standard LAG/LEAD by looking 2 rows back/forward instead of 1. The second argument is the offset.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
LAG(col, n) and LEAD(col, n) look n rows back/forward. Default offset is 1 but the second argument extends the reach.
"3 or more consecutive" reduces to "part of any 3-consecutive window". You don't need to detect full run length. Every row in a longer run satisfies at least one of the three positional cases (start, middle, end). 
Three OR conditions cover all cases cleanly.
LAG/LEAD return NULL at boundaries where rows at the start/end of the table won't have prev2/next2. NULL >= 100 is UNKNOWN, not TRUE, so boundary rows are automatically excluded from the OR conditions that reference out-of-bounds offsets. No extra NULL handling needed.
This pattern generalizes: "N or more consecutive rows satisfying condition X": attach N-1 LAG and N-1 LEAD values, then OR together all N positional window cases in WHERE.
*/
