-- ============================================================
-- Problem:    Patient Support Analysis (Part 1)
-- Source:     DataLemur - https://datalemur.com/questions/frequent-callers
-- Difficulty: Easy
-- Day:        6
-- Date:       23/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, medical records, emergency assistance, or member portal services.

Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the case_id column.

If you like this question, try out Patient Support Analysis (Part 2)!

callers Table:
Column Name	Type
policy_holder_id	integer
case_id	varchar
call_category	varchar
call_date	timestamp
call_duration_secs	integer
callers Example Input:
policy_holder_id	case_id	call_category	call_date	call_duration_secs
1	f1d012f9-9d02-4966-a968-bf6c5bc9a9fe	emergency assistance	2023-04-13T19:16:53Z	144
1	41ce8fb6-1ddd-4f50-ac31-07bfcce6aaab	authorisation	2023-05-25T09:09:30Z	815
2	9b1af84b-eedb-4c21-9730-6f099cc2cc5e	claims assistance	2023-01-26T01:21:27Z	992
2	8471a3d4-6fc7-4bb2-9fc7-4583e3638a9e	emergency assistance	2023-03-09T10:58:54Z	128
2	38208fae-bad0-49bf-99aa-7842ba2e37bc	benefits	2023-06-05T07:35:43Z	619
Example Output:
policy_holder_count
1
Explanation:
The only caller who made three, or more calls is policy holder ID 2.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH interested_users AS(SELECT policy_holder_id 
                         FROM callers
                         GROUP BY policy_holder_id
                         HAVING COUNT(*)>=3
)
SELECT COUNT(policy_holder_id) as policy_holder_count
FROM interested_users

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Goal: count policy holders who called support 3 or more times.
Two-step shape: (1) find which policy_holder_ids qualify, (2) count them.
Step 1: group by policy_holder_id, filter with HAVING COUNT(*) >= 3. The filter is a group-level condition, so HAVING, not WHERE.
Step 2: wrap in a CTE and COUNT(...) over the resulting rows as each row is one qualifying holder, so COUNT(policy_holder_id) gives the final answer.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Two aggregation passes need a wrapper (CTE or subquery). First pass collapses rows per entity and second pass counts/sums over those collapsed rows.
Same shape as LC 619 (Biggest Single Number)
COUNT(*) vs COUNT(col) inside HAVING: identical when col is non-nullable. COUNT(*) is the default reflex, should reach for COUNT(col) only when NULL-skipping behaviour actually matters.
*/
