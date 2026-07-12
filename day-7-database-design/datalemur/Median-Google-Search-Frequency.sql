-- ============================================================
-- Problem:    Median Google Search Frequency
-- Source:     DataLemur - https://datalemur.com/questions/median-search-freq
-- Difficulty: Hard
-- Day:        7
-- Date:       12/07/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point.

search_frequency Table:
Column Name	Type
searches	integer
num_users	integer
search_frequency Example Input:
searches	num_users
1	2
2	2
3	3
4	1
Example Output:
median
2.5
By expanding the search_frequency table, we get [1, 1, 2, 2, 3, 3, 3, 4] which has a median of 2.5 searches per user.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================
WITH ordered_searches AS (SELECT searches, num_users,
  SUM(num_users) OVER (ORDER BY searches) as cum_sum,
  SUM(num_users) OVER () as total_users
FROM search_frequency
),
median_pos AS (
  SELECT *, 
  IF(total_users%2=1, (total_users+1)/2, total_users/2)  AS pos1,
  IF(total_users%2=1, (total_users+1)/2, total_users/2 + 1) AS pos2
  FROM ordered_searches
)

SELECT
  ROUND(AVG(searches), 1) AS median
FROM median_pos
WHERE
  (cum_sum >= pos1 AND cum_sum - num_users < pos1)
  OR
  (cum_sum >= pos2 AND cum_sum - num_users < pos2);


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*

Each bucket, sorted by `searches`, owns a position range in the
imaginary expanded array: [cum_sum - num_users + 1, cum_sum],
where cum_sum = SUM(num_users) OVER (ORDER BY searches).

Bucket contains position p iff: cum_sum >= p AND cum_sum - num_users < p.

Median positions (n = total users:
  pos1 = (n+1)/2, pos2 = (n+2)/2
  odd n: same position twice; even n: the two middle positions.

Filter to bucket(s) covering pos1 or pos2, take AVG(searches).
One or two rows survive; AVG handles all cases.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
-
*/
