-- ============================================================
-- Problem:    Rising Temperature
-- Source:     LeetCode - https://leetcode.com/problems/rising-temperature/description/
-- Difficulty: Easy
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================
SELECT wa.id as id
from Weather wb
Join Weather wa on DATEDIFF(wa.recordDate,wb.recordDate)=1
WHERE wa.temperature > wb.temperature

--OR THIS--

SELECT wa.id AS id
FROM Weather wb
JOIN Weather wa ON wa.recordDate = DATE_ADD(wb.recordDate, INTERVAL 1 DAY)
WHERE wa.temperature > wb.temperature;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Recognized the self-join. Need to compare each day's temperature to the previous day's. Both values live in the same table thus I join the table to itself with two aliases representing two roles ("today" and "yesterday").
Defined the relationship in the ON clause. Used DATEDIFF(today, yesterday) = 1 to glue each pair of consecutive days into one row. Note: the math inside ON is what assigns the roles, DATEDIFF(a, b) = 1 means a is 1 day after b.
Filtered with WHERE for the temperature comparison. Once today and yesterday are on the same row, the temperature comparison is a normal column-vs-column check: today.temperature > yesterday.temperature.
Selected today's id. The problem asks for the day with the rising temperature and that's "today," not "yesterday."
INNER JOIN over LEFT JOIN. Days with no preceding day in the data (the very first day, or days after a gap) can't satisfy "rose compared to yesterday" thus INNER JOIN drops them automatically.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Self-join is the answer to "compare a row to a related row in the same table." Hierarchies, consecutive dates, paired records are all the same shape.
The ON clause assigns the roles, not the FROM order. DATEDIFF(a, b) = 1 makes a the later date. Flipping the arguments flips the roles. The order tables appear in FROM is decorative for INNER JOIN.
Role-named aliases prevent confusion. The WHERE clause writes itself when aliases describe their role.
Plain-English-first technique: before writing the WHERE, say what you want in English ("today's temperature higher than yesterday's"), then translate word-by-word. Skips the mental translation that causes alias swaps.
DATEDIFF(a, b) returns a - b in days. Sign matters because it is easy to flip and end up with falling temperatures instead of rising.
DATEDIFF is not optimal for big datasets. Wrapping a column in a function blocks index usage. For real-world performance, prefer wa.recordDate = DATE_ADD(wb.recordDate, INTERVAL 1 DAY).
*/
