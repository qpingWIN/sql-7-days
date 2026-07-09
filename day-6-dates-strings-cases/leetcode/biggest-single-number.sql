-- ============================================================
-- Problem:    Biggest single number
-- Source:     LeetCode - https://leetcode.com/problems/biggest-single-number/description/
-- Difficulty: Easy
-- Day:        6
-- Date:       23/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: MyNumbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
This table may contain duplicates (In other words, there is no primary key for this table in SQL).
Each row of this table contains an integer.
 

A single number is a number that appeared only once in the MyNumbers table.

Find the largest single number. If there is no single number, report null.

The result format is in the following example.

 

Example 1:

Input: 
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 3   |
| 3   |
| 1   |
| 4   |
| 5   |
| 6   |
+-----+
Output: 
+-----+
| num |
+-----+
| 6   |
+-----+
Explanation: The single numbers are 1, 4, 5, and 6.
Since 6 is the largest single number, we return it.
Example 2:

Input: 
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 7   |
| 7   |
| 3   |
| 3   |
| 3   |
+-----+
Output: 
+------+
| num  |
+------+
| null |
+------+
Explanation: There are no single numbers in the input table so we return null.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT MAX(num) as num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
) t;

WITH counted AS (
    SELECT num, COUNT(*) OVER (PARTITION BY num) as cnt
    FROM MyNumbers
)
SELECT MAX(num) as num
FROM counted 
WHERE cnt =1

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
"Single number" = appears exactly once thus needs a count check, so GROUP BY num HAVING COUNT(*) = 1.
"Biggest", therefore MAX over the singletons, not within each group (needs a second aggregation pass).
Two aggregation passes in SQL = subquery (or CTE).
Empty case: MAX over zero rows returns NULL for free, no special handling needed.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
GROUP BY aggregates within groups, not across them. To get a single scalar from grouped results, wrap them in an outer query: SELECT MAX(...) FROM (... GROUP BY ...).
DISTINCT ≠ "appears once." DISTINCT keeps one copy of each value regardless of original frequency. To filter by frequency, count.
HAVING filters groups, WHERE filters rows. HAVING COUNT(*) = 1 is the canonical "singletons only" filter and only works after GROUP BY.
MAX over an empty set returns NULL: useful for "biggest if exists, else null" problems. No COALESCE or IFNULL needed.
Pattern worth memorising: "largest/smallest value satisfying some count condition" - SELECT MAX(col) FROM (SELECT col FROM t GROUP BY col HAVING COUNT(*) = N)

*/
