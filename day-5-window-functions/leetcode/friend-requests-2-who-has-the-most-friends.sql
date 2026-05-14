-- ============================================================
-- Problem:    Friend Requests II: Who Has the Most Friends
-- Source:     LeetCode - https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/
-- Difficulty: Medium
-- Day:        5
-- Date:       14/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: RequestAccepted

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
 

Write a solution to find the people who have the most friends and the most friends number.

The test cases are generated so that only one person has the most friends.

The result format is in the following example.

 

Example 1:

Input: 
RequestAccepted table:
+--------------+-------------+-------------+
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
+--------------+-------------+-------------+
Output: 
+----+-----+
| id | num |
+----+-----+
| 3  | 3   |
+----+-----+
Explanation: 
The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT t.id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) t
GROUP BY t.id
ORDER BY num DESC
LIMIT 1;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Each row in the table represents one friendship between two users. An accepted request adds +1 to both parties' friend counts. So a user's total friend count = (times they appear as requester) + (times they appear as accepter).
Reframe the problem: instead of treating each row as two "halves," stack the two columns vertically. Now every friendship contributes exactly two rows, one per participant. Count occurrences of each user ID is a friend count.
This collapses the problem to the canonical SQL shape: "count occurrences of each value in a column." One scan, one group-by, done.
UNION ALL not UNION: the rows represent friendship participations (events to be counted), not identities. Deduping destroys the count.
ORDER BY num DESC LIMIT 1 to pick the winner. Problem guarantees no ties so no tiebreaker needed.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
UNION vs UNION ALL depends on what rows mean in your query. If rows = events to count then UNION ALL (preserve every occurrence). If rows = identities to enumerate then UNION is fine. Default to UNION ALL as it's cheaper (no sort/dedup pass) and only "wrong" if you genuinely need set-theoretic dedup.
What UNION dedupes on. It treats each row as a tuple of values; two rows are duplicates if every column matches. For single-column unions, that means matching scalar values.
Vertical-stacking pattern for counting "participation in either of two roles." Whenever a row has two columns representing two participants in the same relationship (sender/receiver, buyer/seller, requester/accepter), stacking via UNION ALL + GROUP BY + COUNT(*) is the canonical trick.
Alternative architectures and why this one wins. Correlated subqueries (COUNT(*) WHERE requester_id = u.id plus COUNT(*) WHERE accepter_id = u.id) also work but re-scan the table per user, its quadratic-flavored. Pre-aggregating each column then unioning the counts is equivalent but uglier. The UNION-ALL-then-group approach is one hash-aggregate over a stacked source — what query planners optimize best.
Tie-handling pattern for the follow-up. Replace LIMIT 1 with a CTE + WHERE num = (SELECT MAX(num) FROM cte), or use RANK() OVER (ORDER BY num DESC) and filter WHERE rnk = 1. The first is simpler; the second generalizes to top-N-with-ties.
WHERE vs HAVING on aggregated results. Once a CTE has already aggregated, its rows are atomic - filtering them uses WHERE, not HAVING. HAVING is for filtering groups during the aggregation step, not after.
Schema guarantees is not the same as data guarantees. PK (requester_id, accepter_id) forbids same-pair-same-direction duplicates but allows reversed-direction duplicates like (1,2) and (2,1). If both existed, this query would double-count that friendship. Defense: canonicalize each pair with LEAST/GREATEST before stacking. Worth flagging in interviews even if test data doesn't exercise it.
Distinguish three layers of guarantees: what the schema enforces (PKs, FKs, NOT NULL), what the problem statement asserts (often informal, may not be enforced), what you assume about real-world semantics (often wrong)
*/
