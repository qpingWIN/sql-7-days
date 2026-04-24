-- ============================================================
-- Problem:    Not Boring Movies
-- Source:     LeetCode — https://leetcode.com/problems/not-boring-movies/description/
-- Difficulty: Easy
-- Day:        1
-- Date:       24/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Cinema

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| id             | int      |
| movie          | varchar  |
| description    | varchar  |
| rating         | float    |
+----------------+----------+
id is the primary key (column with unique values) for this table.
Each row contains information about the name of a movie, its genre, and its rating.
rating is a 2 decimal places float in the range [0, 10]
 

Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".

Return the result table ordered by rating in descending order.

The result format is in the following example.

 

Example 1:

Input: 
Cinema table:
+----+------------+-------------+--------+
| id | movie      | description | rating |
+----+------------+-------------+--------+
| 1  | War        | great 3D    | 8.9    |
| 2  | Science    | fiction     | 8.5    |
| 3  | irish      | boring      | 6.2    |
| 4  | Ice song   | Fantacy     | 8.6    |
| 5  | House card | Interesting | 9.1    |
+----+------------+-------------+--------+
Output: 
+----+------------+-------------+--------+
| id | movie      | description | rating |
+----+------------+-------------+--------+
| 5  | House card | Interesting | 9.1    |
| 1  | War        | great 3D    | 8.9    |
+----+------------+-------------+--------+
Explanation: 
We have three movies with odd-numbered IDs: 1, 3, and 5. The movie with ID = 3 is boring so we do not include it in the answer.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================
SELECT id, movie, description, rating 
FROM Cinema
WHERE id % 2 = 1
    AND description != 'boring'
ORDER BY rating DESC;


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
   NULL consideration: if `description` could be NULL, `description != 'boring'`
   would silently exclude those rows. The problem statement doesn't say
   description is NOT NULL, so strictly defensive code would be: AND (description != 'boring' OR description IS NULL)
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Modulo operator varies slightly:

  MySQL, Postgres, SQLite:  id % 2
  Oracle, SQL Server: MOD(id, 2) also works in many dialects
  ANSI standard: MOD(id, 2); '<>' is the standard SQL inequality operator, but most databases also support '!='.

For "odd", both `id % 2 = 1` and `MOD(id, 2) <> 0` work. The second is
safer if you ever have to deal with negative ids — in MySQL, -3 % 2 = -1,
not 1, so `id % 2 = 1` would miss negative odd numbers. 
*/
