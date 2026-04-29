-- ============================================================
-- Problem:    FInd Followers Count
-- Source:     LeetCode - https://leetcode.com/problems/find-followers-count/description/
-- Difficulty: Easy
-- Day:        2
-- Date:       26/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Followers

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the primary key (combination of columns with unique values) for this table.
This table contains the IDs of a user and a follower in a social media app where the follower follows the user.
 

Write a solution that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Followers table:
+---------+-------------+
| user_id | follower_id |
+---------+-------------+
| 0       | 1           |
| 1       | 0           |
| 2       | 0           |
| 2       | 1           |
+---------+-------------+
Output: 
+---------+----------------+
| user_id | followers_count|
+---------+----------------+
| 0       | 1              |
| 1       | 1              |
| 2       | 2              |
+---------+----------------+
Explanation: 
The followers of 0 are {1}
The followers of 1 are {0}
The followers of 2 are {0,1}
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

select user_id, count(*) as followers_count 
from Followers
group by user_id
order by user_id;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
What does one row in my output represent?
One user so GROUP BY user_id.

What am I calculating per group?
How many followers each user has, COUNT(*) counts one row per
follower since each row in the Followers table represents one
follower relationship.

No HAVING needed because the problem asks for all users, no group-level
filter applied.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Read the output spec before finalising. If it specifies ordering,
add ORDER BY.
*/
