-- ============================================================
-- Problem:    Average Post Hiatus (part 1)
-- Source:     DataLemur - https://datalemur.com/questions/sql-average-post-hiatus-1
-- Difficulty: Easy
-- Day:        6
-- Date:       23/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.

p.s. If you've read the Ace the Data Science Interview and liked it, consider writing us a review?

posts Table:
Column Name	Type
user_id	integer
post_id	integer
post_content	text
post_date	timestamp
posts Example Input:
user_id	post_id	post_content	post_date
151652	599415	Need a hug	07/10/2021 12:00:00
661093	624356	Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that's gonna fly by. I miss my girlfriend	07/29/2021 13:00:00
004239	784254	Happy 4th of July!	07/04/2021 11:00:00
661093	442560	Just going to cry myself to sleep after watching Marley and Me.	07/08/2021 14:00:00
151652	111766	I'm so done with covid - need travelling ASAP!	07/12/2021 19:00:00
Example Output:
user_id	days_between
151652	2
661093	21

*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT 
    user_id, 
    DATEDIFF(MAX(DATE(post_date)), MIN(DATE(post_date))) AS days_between
FROM posts
WHERE YEAR(post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) > 1;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Filter to 2021 first with WHERE YEAR(post_date) = 2021, row-level filter so it belongs in WHERE, not HAVING.
Group by user_id, then MAX(post_date) - MIN(post_date) gives the span. Used DATEDIFF.
Wrapped each post_date in DATE(...) to strip any time component, keeps DATEDIFF measuring whole days regardless of whether post_date is DATE or DATETIME.
Singletons would produce 0 and I filtered them out with HAVING COUNT(post_id) > 1.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
DATEDIFF(later, earlier) is the MySQL idiom for "days between". Argument order matters (gives a negative if you flip it)
DATE(col) truncates a DATETIME to its date part. Cheap insurance even when the column is already DATE (avoids dealing with hours/seconds etc).
YEAR(col) is fine for filtering but kills indexes and wrapping an indexed column in a function prevents index use. For production code, post_date >= '2021-01-01' AND post_date < '2022-01-01' is the index-friendly form. 
COUNT(post_id) vs COUNT(*): equivalent here since post_id is non-nullable PK, but COUNT(col) skips NULLs whereas COUNT(*) counts rows. Worth knowing which you mean.
Pattern locked in: "per-entity time span, filtered by period, excluding singletons" → WHERE for the period + GROUP BY entity + DATEDIFF(MAX, MIN) + HAVING COUNT > 1.
