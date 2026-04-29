-- ============================================================
-- Problem:    Histogram Tweets
-- Source:     DataLemur — https://datalemur.com/questions/sql-histogram-tweets
-- Difficulty: Easy
-- Day:        2
-- Date:       26/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
This is the same question as problem #6 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

tweets Table:
Column Name	Type
tweet_id	integer
user_id	integer
msg	string
tweet_date	timestamp
tweets Example Input:
tweet_id	user_id	msg	tweet_date
214252	111	Am considering taking Tesla private at $420. Funding secured.	12/30/2021 00:00:00
739252	111	Despite the constant negative press covfefe	01/01/2022 00:00:00
846402	111	Following @NickSinghTech on Twitter changed my life!	02/14/2022 00:00:00
241425	254	If the salary is so competitive why won’t you tell me what it is?	03/01/2022 00:00:00
231574	148	I no longer have a manager. I can't be managed	03/23/2022 00:00:00
Example Output:
tweet_bucket	users_num
1	2
2	1
Explanation:
Based on the example output, there are two users who posted only one tweet in 2022, and one user who posted two tweets in 2022. The query groups the users by the number of tweets they posted and displays the number of users in each group.

The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT tweet_count AS tweet_bucket, COUNT(user_id) AS users_num
FROM (
    SELECT user_id, count(tweet_id) AS tweet_count
    FROM tweets 
    WHERE YEAR(tweet_date) = 2022
    GROUP BY user_id
) AS tweet_counts
GROUP BY tweet_count;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
What does one row in my output represent?
One tweet count bucket, not one user. This is a histogram:
how many users sent exactly 1 tweet, exactly 2, exactly 3, etc.

This requires two levels of aggregation:
  Step 1: count tweets per user to achieve an intermediate result
  Step 2: group those counts, count how many users share each count

Step 1 is a subquery in FROM — it acts as a temporary table that
the outer query reads from. Every subquery in FROM must have an
alias (tweet_counts) otherwise SQL throws an error, it needs a
name to reference the temporary table.

Named the subquery alias tweet_counts (plural) and the column tweet_count (singular) deliberately.

Date filter: problem specifies 2022 tweets only. Without
YEAR(tweet_date) = 2022 in the inner query's WHERE clause, all
tweets are counted regardless of year - wrong counts, wrong buckets.
WHERE goes in the inner query, not the outer one, because the
filter applies to raw rows before any grouping happens.

Step 2: outer query groups by tweet_count (the bucket) and counts
how many users fall into each bucket with COUNT(user_id).
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Two-level aggregation pattern — when the output granularity is
a summary of a summary, use a subquery:
  Inner query: aggregate raw rows into per-entity counts
  Outer query: aggregate those counts into buckets

Subquery in FROM (derived table):
  FROM (SELECT ...) AS alias
  The alias is mandatory because every table in FROM needs a name.
  Use distinct names for the subquery alias and its columns to avoid ambiguity.

Histogram pattern specifically:
  Inner: COUNT per entity gives one row per entity with its count
  Outer: GROUP BY that count, COUNT entities gives bucket frequencies

Date filter placement: filter on raw data goes in the inner query's
WHERE, not the outer query. The outer query only sees the aggregated
result which reflects that the original date column no longer exists there.
YEAR(tweet_date) = 2022 extracts the year from a date column.
*/
