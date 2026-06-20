-- ============================================================
-- Problem:    Game Play Analysis IV
-- Source:     LeetCode - https://leetcode.com/problems/game-play-analysis-iv/description/
-- Difficulty: Medium
-- Day:        4
-- Date:       04/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to determine the number of players who logged in on the day immediately following their initial login, and divide it by the number of total players.

The result format is in the following example.

 

Example 1:

Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT ROUND(1.00*SUM(CASE WHEN a.event_date=DATE_ADD(firsts.first_log_in, INTERVAL 1 DAY) THEN 1 ELSE 0 END)/COUNT(DISTINCT a.player_id),2) as fraction
FROM Activity a
JOIN(
    SELECT player_id, MIN(event_date) as first_log_in
    FROM Activity
    GROUP BY player_id
) AS firsts
ON a.player_id = firsts.player_id

-- OR THIS --
SELECT ROUND(
    SUM(CASE 
        WHEN EXISTS (
            SELECT 1 FROM Activity a2
            WHERE a2.player_id = firsts.player_id
              AND a2.event_date = DATE_ADD(firsts.first_log_in, INTERVAL 1 DAY)
        ) THEN 1 ELSE 0 END
    ) / COUNT(*),
    2
) AS fraction
FROM (
    SELECT player_id, MIN(event_date) AS first_log_in
    FROM Activity
    GROUP BY player_id
) AS firsts;

--OR THIS--
WITH first_login AS (
    SELECT player_id, MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
),
joined AS (
    SELECT
        f.player_id,
        MAX(CASE WHEN a.player_id IS NOT NULL THEN 1 ELSE 0 END) AS did_return --robust for possible duplicates per player
    FROM first_login f
    LEFT JOIN Activity a
      ON f.player_id = a.player_id
     AND a.event_date = DATE_ADD(f.first_date, INTERVAL 1 DAY)
    GROUP BY f.player_id
)
SELECT
    ROUND(AVG(did_return), 2) AS fraction
FROM joined;
-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Same family as Immediate Food Delivery II: "find the first event per group, then check a condition tied to that first event"
Stage 1: get each player's first login date via MIN(event_date) GROUP BY player_id
Stage 2: for each player, check whether they also logged in exactly one day after their first

First instinct was JOIN-based: join Activity back to the per-player-MIN derived table, keeping all of each player's rows

JOIN condition a.player_id = firsts.player_id keeps every row, not just the first-day row
Each row now carries both event_date and first_log_in side by side, ready for comparison

The condition becomes a.event_date = first_log_in + 1 day

Two ways to express this in MySQL:

DATEDIFF(a.event_date, firsts.first_log_in) = 1 — diff in days, check equals 1
a.event_date = DATE_ADD(firsts.first_log_in, INTERVAL 1 DAY) — add a day and compare directly

Picked the second; both are idiomatic

Numerator: conditional aggregation — SUM(CASE WHEN <condition> THEN 1 ELSE 0 END)
Denominator: total distinct players — COUNT(DISTINCT a.player_id)
ROUND to 2 decimal places per the spec

Side note on EXISTS: an alternative shape uses EXISTS to check "does any row in Activity match (player_id, first_login + 1)?" — that's the natural use of EXISTS.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
EXISTS takes a subquery and returns true if any rows come back, ignoring their values. The convention is SELECT 1 FROM ... inside, the 1 is a placeholder meaning "I don't care what you return, just whether you return anything." 
SELECT *, SELECT NULL, SELECT 42 all behave identically, but SELECT 1 is the universally-understood idiom.
EXISTS vs JOIN are alternative shapes for the same question. EXISTS asks "does a matching row exist?" without pulling its values. JOIN brings the matching rows into scope and lets you operate on their columns directly. 
Pick EXISTS when you only need yes/no; pick JOIN when you actually need the joined columns.
MySQL's / operator returns decimals, unlike many languages where integer-divided-by-integer truncates. 1 / 3 gives 0.3333 in MySQL. The truncation issue applies to the DIV operator instead. Still safer to multiply by 1.00 for portability across dialects.
DATEDIFF(a, b) returns days between dates (a minus b). DATE_ADD(date, INTERVAL n DAY) adds days. Either works for "the day after" comparisons; DATE_ADD reads more naturally as "first_login + 1 day".
The "first event per group + condition on related event" pattern is recurring. Stage 1 always does MIN/MAX GROUP BY. Stage 2 either joins back to the original table to compare more columns, or uses EXISTS to check existence of a related row.
Joining doesn't filter rows away unless the join condition restricts them. With ON a.player_id = firsts.player_id and no date filter, every Activity row survives — each tagged with the player's first_log_in. The filtering happens later via CASE or WHERE.
*/
