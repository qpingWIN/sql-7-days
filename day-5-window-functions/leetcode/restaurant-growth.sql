-- ============================================================
-- Problem:    Restaurant Growth
-- Source:     LeetCode - https://leetcode.com/problems/restaurant-growth/description/
-- Difficulty: Medium
-- Day:        5
-- Date:       08/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
In SQL,(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.

Return the result table ordered by visited_on in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+
Explanation: 
1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH daily AS (
    SELECT visited_on, SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
),
rolling AS (
    SELECT 
        visited_on,
        SUM(daily_amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
        ROUND(AVG(daily_amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount
    FROM daily
)
SELECT visited_on, amount, average_amount
FROM rolling
WHERE visited_on >= (SELECT MIN(visited_on) + INTERVAL 6 DAY FROM Customer);

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Need a 7-day rolling sum and average of amount per day. Two complications: multiple rows per day (one per customer visit), and the output should only show rows where a full 7-day window exists.
Two-stage problem — aggregate by day first, then roll over days:
    Stage 1 (daily): SUM(amount) GROUP BY visited_on — one row per day
    Stage 2 (rolling): apply the 7-day window over the daily totals
PARTITION BY visited_on was the wrong instinct as that resets the window per date group, so each date only sees its own rows. 
Rolling windows need to span across dates, so ORDER BY visited_on with a frame clause is correct. PARTITION BY is for independent calculations per group; rolling windows intentionally bleed across groups.
Frame clause: ROWS BETWEEN 6 PRECEDING AND CURRENT ROW — current row plus 6 rows behind it = 7 days. Final filter: rows before day 7 have incomplete windows. WHERE visited_on >= MIN(visited_on) + INTERVAL 6 DAY drops them and 
the cutoff is the earliest date that has a full 7 days behind it.
PostgreSQL vs MySQL syntax difference: INTERVAL '6 days' (PostgreSQL) vs INTERVAL 6 DAY (MySQL).
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
ROWS BETWEEN N PRECEDING AND CURRENT ROW defines a sliding frame of N+1 rows. Goes inside OVER(...) 
PARTITION BY resets the window per group; ORDER BY slides across groups. For rolling calculations that span multiple dates, drop PARTITION BY and just ORDER BY the date. PARTITION BY is for independent per-group calculations like ranking per department.
Two-stage rolling pattern: aggregate to one row per time unit first (GROUP BY), then apply the window function over those aggregated rows. Applying a rolling window directly to raw transaction rows would produce wrong results.
Incomplete window filtering: early rows don't have enough history for a full window. Filter with WHERE date >= MIN(date) + INTERVAL 'N-1 days' to keep only rows with complete windows.
PostgreSQL vs MySQL interval syntax: INTERVAL '6 days' vs INTERVAL 6 DAY. Chained CTEs: rolling references daily directly. Later CTEs can always reference earlier ones in the same WITH block.
*/
