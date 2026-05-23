-- ============================================================
-- Problem:    Investments in 2016
-- Source:     LeetCode - https://leetcode.com/problems/investments-in-2016/description/
-- Difficulty: Medium
-- Day:        6
-- Date:       20/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Insurance

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid is the primary key (column with unique values) for this table.
Each row of this table contains information about one policy where:
pid is the policyholder's policy ID.
tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
lat is the latitude of the policy holder's city. It's guaranteed that lat is not NULL.
lon is the longitude of the policy holder's city. It's guaranteed that lon is not NULL.
 

Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:

have the same tiv_2015 value as one or more other policyholders, and
are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
Round tiv_2016 to two decimal places.

The result format is in the following example.

 

Example 1:

Input: 
Insurance table:
+-----+----------+----------+-----+-----+
| pid | tiv_2015 | tiv_2016 | lat | lon |
+-----+----------+----------+-----+-----+
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |
+-----+----------+----------+-----+-----+
Output: 
+----------+
| tiv_2016 |
+----------+
| 45.00    |
+----------+
Explanation: 
The first record in the table, like the last record, meets both of the two criteria.
The tiv_2015 value 10 is the same as the third and fourth records, and its location is unique.

The second record does not meet any of the two criteria. Its tiv_2015 is not like any other policyholders and its location is the same as the third record, which makes the third record fail, too.
So, the result is the sum of tiv_2016 of the first and last record, which is 45.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH flagged AS (
    SELECT
        tiv_2016,
        COUNT(*) OVER (PARTITION BY tiv_2015) AS tiv_2015_count,
        COUNT(*) OVER (PARTITION BY lat, lon) AS loc_count
    FROM Insurance
)
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM flagged
WHERE tiv_2015_count > 1
  AND loc_count = 1;

--OR THIS--

SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
);
---Super messy initial one----
WITH duplicate_tiv AS (
    SELECT pid,
           tiv_2015,
           tiv_2016,
           lat,
           lon,
           COUNT(*) OVER (PARTITION BY tiv_2015) as dup_count1
    FROM Insurance
),
duplicate_lat_lon AS (
    SELECT pid,
           tiv_2015,
           tiv_2016,
           lat,
           lon,
           COUNT(*) OVER (PARTITION BY lat, lon) as dup_count2
    FROM Insurance
),
full_dup_tiv AS (
    SELECT pid,
           tiv_2015,
           tiv_2016,
           lat,
           lon
    FROM duplicate_tiv
    WHERE dup_count1>1
),
full_dup_lat_lon AS (
    SELECT dll.pid,
           dll.tiv_2015,
           dll.tiv_2016,
           dll.lat,
           dll.lon
    FROM duplicate_lat_lon dll
    JOIN full_dup_tiv fdt ON dll.pid = fdt.pid
    WHERE dll.dup_count2=1
)
SELECT ROUND(1.00*SUM(full_dup_lat_lon.tiv_2016),2) as tiv_2016
FROM Insurance
JOIN full_dup_lat_lon ON full_dup_lat_lon.pid = Insurance.pid
-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*

Thought process

Two conditions to combine: tiv_2015 shared with ≥1 other policyholder, (lat, lon) shared with none.
Used COUNT(*) OVER (PARTITION BY …) to tag each row with how many times its key appears: > 1 for duplicated tiv_2015, = 1 for unique location.
Split into two CTEs (one per partition key), filtered each, then intersected via join on pid.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
COUNT(*) OVER (PARTITION BY …) is the dedup workhorse: same key idea covers both "shared" (> 1) and "unique" (= 1) just by flipping the comparator.
Multiple window functions can live in the same SELECT — no need for separate CTEs per partition key.
Joining back to the source table at the end is redundant when the CTE already carries every column needed.

*/
