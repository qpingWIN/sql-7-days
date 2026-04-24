-- ============================================================
-- Problem:    Article Views I
-- Source:     LeetCode — https://leetcode.com/problems/article-views-i/description/
-- Difficulty: Easy
-- Day:        1
-- Date:       24/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table:Views
There is no primary key (column with unique values) for this table, the table may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write a solution to find all the authors that viewed at least one of their own articles.

Return the result table sorted by id in ascending order.
Example 1:

Input: 
Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+
Output: 
+------+
| id   |
+------+
| 4    |
| 7    |
+------+
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
The condition "at least one of their own articles" means we're looking for rows where the author and the viewer are the same person, so author_id = viewer_id as a row-level filter.
The problem says no duplicates, which means an author who viewed their own articles multiple times should only appear once. That's DISTINCT on author_id.
Sorting ascending is just ORDER BY with no modifier, ascending is the default, so DESC isn't needed.
The output column should be named id, not author_id. So alias it with AS id.

The interesting thing about that alias is that you can actually use it in the ORDER BY clause as writing ORDER BY id instead of ORDER BY author_id. That works because ORDER BY runs after SELECT in SQL's logical execution order, so by the time the sort happens the alias already exists.

*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
SQL clauses execute in this order, not the order they're written:
  1. FROM / JOIN       — which tables
  2. WHERE             — filter rows (no aliases yet!)
  3. GROUP BY          — form groups
  4. HAVING            — filter groups
  5. SELECT            — pick columns, apply aliases, compute expressions
  6. DISTINCT          — dedupe
  7. ORDER BY          — sort (aliases available here)
  8. LIMIT / OFFSET    — cap results

  This explains why you can't use a SELECT alias in WHERE but can use it in ORDER BY

  DISTINCT applies to the entire row being returned, not to individual columns.
  `SELECT DISTINCT author_id, view_date` gives unique (author_id, view_date) pairs,
  not "distinct author_ids with some view_date."
*/
