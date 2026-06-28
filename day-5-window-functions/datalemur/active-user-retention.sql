-- ============================================================
-- Problem:    Active User Retention
-- Source:     DataLemur - https://datalemur.com/questions/user-retention
-- Difficulty: Hard
-- Day:        5
-- Date:       18/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

Hint:

An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.
user_actions Table:
Column Name	Type
user_id	integer
event_id	integer
event_type	string ("sign-in, "like", "comment")
event_date	datetime
user_actionsExample Input:
user_id	event_id	event_type	event_date
445	7765	sign-in	05/31/2022 12:00:00
742	6458	sign-in	06/03/2022 12:00:00
445	3634	like	06/05/2022 12:00:00
742	1374	comment	06/05/2022 12:00:00
648	3124	like	06/18/2022 12:00:00
Example Output for June 2022:
month	monthly_active_users
6	1
Example
In June 2022, there was only one monthly active user (MAU) with the user_id 445.

Please note that the output provided is for June 2022 as the user_actions table only contains event dates for that month. You should adapt the solution accordingly for July 2022.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH active_users_june AS(SELECT DISTINCT user_id
                            FROM user_actions
                            WHERE EXTRACT(MONTH from event_date)=6
),
active_users_july AS(SELECT DISTINCT user_id, EXTRACT(MONTH from event_date) as month_h
                            FROM user_actions
                            WHERE EXTRACT(MONTH from event_date)=7
)
SELECT active_users_july.month_h, COUNT(*) as monthly_active_users
FROM active_users_june
JOIN active_users_july ON active_users_june.user_id = active_users_july.user_id
GROUP BY active_users_july.month_h

--OR THIS--
SELECT
    7 AS month,
    COUNT(DISTINCT ua1.user_id) AS monthly_active_users
FROM user_actions ua1
WHERE EXTRACT(MONTH FROM ua1.event_date) = 7
  AND EXISTS (
      SELECT 1
      FROM user_actions ua2
      WHERE ua2.user_id = ua1.user_id
        AND EXTRACT(MONTH FROM ua2.event_date) = 6
  );

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Two filtered CTEs (June users, July users), inner join on user_id, count the overlap. Intersection of two sets = inner join on the dedup'd sides.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Used CASE as a filter. It doesn't drop rows, just nullifies values. Filtering rows is WHERE's job.
Stuck IS NOT NULL in the ON clause to clean up after the CASE. Row filters belong in WHERE; ON is for how tables relate.
COUNT(*) after joining raw events would double-count. Fix: SELECT DISTINCT user_id in each CTE before the join.
*/
