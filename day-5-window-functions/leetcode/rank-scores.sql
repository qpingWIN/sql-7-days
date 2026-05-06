-- ============================================================
-- Problem:    Rank Scores
-- Source:     LeetCode - https://leetcode.com/problems/rank-scores/
-- Difficulty: Medium
-- Day:        5
-- Date:       06/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Scores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| score       | decimal |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains the score of a game. Score is a floating point value with two decimal places.
 

Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:

The scores should be ranked from the highest to the lowest.
If there is a tie between two scores, both should have the same ranking.
After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
Return the result table ordered by score in descending order.

The result format is in the following example.

 

Example 1:

Input: 
Scores table:
+----+-------+
| id | score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
Output: 
+-------+------+
| score | rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT score, 
       DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank'
FROM Scores

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Clean application of yesterday's DENSE_RANK() intro. No grouping, no filtering just rank all scores globally by descending order and output (score, rank) pairs.
RANK() would skip numbers after ties (1, 2, 2, 4) which is wrong for this problem. DENSE_RANK() doesn't skip (1, 2, 2, 3)- exactly what the expected output shows.
No PARTITION BY needed since there's no per-group ranking justone global ranking across all rows.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
DENSE_RANK() OVER (ORDER BY col DESC) is global ranking, no partition needed when ranking across the whole table
Three ranking functions recap: ROW_NUMBER (unique, arbitrary tie-break), RANK (ties share rank, skips next), DENSE_RANK (ties share rank, no skip). 
'rank' needs quotes in MySQL because RANK is a reserved keyword and using it as a column alias without quotes throws a syntax error
Window functions with no PARTITION BY treat the entire result set as one partition 
