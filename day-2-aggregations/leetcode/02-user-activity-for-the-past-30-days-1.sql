-- ============================================================
-- Problem:    User Activity for the Past 30 Days
-- Source:     LeetCode - https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/
-- Difficulty: Easy
-- Day:        2
-- Date:       26/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Activity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
This table may have duplicate rows.
The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website. 
Note that each session belongs to exactly one user.
 

Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.

Return the result table in any order.

The result format is in the following example.

Note: Any activity from ('open_session', 'end_session', 'scroll_down', 'send_message') will be considered valid activity for a user to be considered active on a day.

 

Example 1:

Input: 
Activity table:
+---------+------------+---------------+---------------+
| user_id | session_id | activity_date | activity_type |
+---------+------------+---------------+---------------+
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |
+---------+------------+---------------+---------------+
Output: 
+------------+--------------+ 
| day        | active_users |
+------------+--------------+ 
| 2019-07-20 | 2            |
| 2019-07-21 | 2            |
+------------+--------------+ 
Explanation: Note that we do not care about days with zero active users.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date > DATE_SUB('2019-07-27', INTERVAL 30 DAY)
  AND activity_date <= '2019-07-27'
GROUP BY activity_date;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
sql-- THOUGHT PROCESS
/*
What does one row in my output represent?
One day — so GROUP BY activity_date.

What am I calculating per group?
Number of active users per day. A user can have multiple activity
rows on the same day, so COUNT(*) would overcount — need
COUNT(DISTINCT user_id) to count each user once per day regardless
of how many actions they performed.

Initial mistake: used COUNT(DISTINCT session_id) instead of
COUNT(DISTINCT user_id). session_id counts unique sessions, not
unique users: a user with 3 sessions would contribute 3 instead
of 1. 

Date filter: problem specifies activity within the past 30 days
ending on 2019-07-27. WHERE runs before GROUP BY so the date
filter correctly narrows rows before grouping happens.
DATE_SUB('2019-07-27', INTERVAL 30 DAY) gives the lower bound.
Used > (exclusive) on lower bound, <= (inclusive) on upper bound
to capture exactly 30 days ending on the reference date.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
WHERE and GROUP BY work together. WHERE filters rows first,
then GROUP BY groups whatever rows remain. Order matters:
filter early to reduce the data before grouping.

DATE_SUB(date, INTERVAL n DAY) subtracts n days from a date.
For "last 30 days ending on X":
  WHERE date_col > DATE_SUB(X, INTERVAL 30 DAY)
    AND date_col <= X

Watch which column I'm counting. COUNT(DISTINCT user_id)
and COUNT(DISTINCT session_id) look similar but answer different
questions.
*/
