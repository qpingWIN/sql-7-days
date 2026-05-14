-- ============================================================
-- Problem:    Movie Rating
-- Source:     LeetCode - https://leetcode.com/problems/movie-rating/
-- Difficulty: Medium
-- Day:        5
-- Date:       13/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Movies

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key (column with unique values) for this table.
title is the name of the movie.
Each movie has a unique title.
Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key (column with unique values) for this table.
The column 'name' has unique values.
Table: MovieRating

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key (column with unique values) for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user's review date. 
 

Write a solution to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
The result format is in the following example.

 

Example 1:

Input: 
Movies table:
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
Users table:
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
MovieRating table:
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+
Explanation: 
Daniel and Monica have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH big AS ( SELECT mr.rating,
                     mr.created_at,
                     u.name,
                     m.title
              FROM MovieRating mr
              JOIN Users u ON mr.user_id = u.user_id
              JOIN Movies m ON mr.movie_id = m.movie_id
)

SELECT results FROM((SELECT name as results, 1 as sort_key
FROM big
GROUP BY name
ORDER BY COUNT(rating) DESC, name ASC
LIMIT 1)

UNION ALL

(SELECT title as results, 2
FROM big
WHERE YEAR(created_at)=2020 AND MONTH(created_at)=2
GROUP BY title
ORDER BY AVG(rating) DESC, title
LIMIT 1)
) t
ORDER BY sort_key;



-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Two independent sub-questions, one output, thus instinct: solve each separately, then combine. Combining two result sets vertically, therefore UNION / UNION ALL.
For each sub-question, "top-1 with tiebreak" reduces to GROUP BY + ORDER BY metric DESC, tiebreak ASC + LIMIT 1. Avoided HAVING = MAX(...) because problem demands exactly one row.
First attempt used a window function DENSE_RANK() OVER (PARTITION BY title ORDER BY AVG(rating) DESC), wrong because AVG inside a window function without GROUP BY doesn't compute per-movie averages, and partitioning by title gives single-row windows (rank always 1).
Date filter went on the WHERE clause of the movie half as filters individual rating rows before aggregation. WHERE vs HAVING: WHERE filters source rows, HAVING filters aggregated groups. Here I want only Feb ratings to contribute to the average, so WHERE.
Bug I hit: applied the Feb filter to the user half too. Re-read problem, user half is all-time, only movie half is Feb-scoped. Lesson: filters don't always apply uniformly to both halves of a compound problem.
UNION ALL doesn't guarantee row order. Added literal sort_key column (1 for user, 2 for movie), outer ORDER BY sort_key forces stacking order.
LeetCode wants single column results. Wrapped union in outer SELECT results FROM (...) t so sort_key exists for sorting but doesn't appear in output.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Window functions need a row context. AVG(rating) OVER (...) only makes sense if rows are already at the right grain or partitioned correctly. For per-group aggregates, plain GROUP BY is the right tool, don't need to reach for window functions when aggregation suffices.
ORDER BY ... LIMIT 1 beats HAVING = MAX(...) for "give me the one winner" problems. The HAVING approach returns all tied rows; the ORDER BY approach uses the tiebreaker rule to pick exactly one.
UNION column naming: output column names come from the first branch's aliases. Only alias on the first SELECT.
UNION ordering is not guaranteed by spec. If you need a specific row order across branches, smuggle in a sort key and ORDER BY it on the outer query.
Per-branch LIMIT requires parentheses around each SELECT, otherwise LIMIT attaches to the whole union and you get one row total.
Hide auxiliary columns by wrapping in a subquery. SELECT visible_col FROM (full_query_with_extra_cols) t is the standard trick for hiding sort/dedup helpers from final output.
Date predicates: sargable beats readable. created_at BETWEEN '2020-02-01' AND '2020-02-29' (or >= ... AND <) allows index use; YEAR(x)=2020 AND MONTH(x)=2 wraps the column and kills the index.
COUNT(*) vs COUNT(col): COUNT(*) counts rows, COUNT(col) skips NULLs. For "how many ratings did this user produce," COUNT(*) signals intent better.
Read the problem twice. I assumed both halves shared the date filter but they didn't. Cost me debugging cycles. Each sub-question gets its own filter audit.
*/
