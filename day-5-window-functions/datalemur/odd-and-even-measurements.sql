-- ============================================================
-- Problem:    Odd and Even Measurements
-- Source:     DataLemur - https://datalemur.com/questions/odd-even-measurements
-- Difficulty: Medium
-- Day:        05
-- Date:       18/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

Definition:

Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.
Effective April 15th, 2023, the question and solution for this question have been revised.

measurements Table:
Column Name	Type
measurement_id	integer
measurement_value	decimal
measurement_time	datetime
measurements Example Input:
measurement_id	measurement_value	measurement_time
131233	1109.51	07/10/2022 09:00:00
135211	1662.74	07/10/2022 11:00:00
523542	1246.24	07/10/2022 13:15:00
143562	1124.50	07/11/2022 15:00:00
346462	1234.14	07/11/2022 16:45:00
Example Output:
measurement_day	odd_sum	even_sum
07/10/2022 00:00:00	2355.75	1662.74
07/11/2022 00:00:00	1124.50	1234.14
Explanation
Based on the results,

On 07/10/2022, the sum of the odd-numbered measurements is 2355.75, while the sum of the even-numbered measurements is 1662.74.
On 07/11/2022, there are only two measurements available. The sum of the odd-numbered measurements is 1124.50, and the sum of the even-numbered measurements is 1234.14.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH table_day AS(SELECT measurement_id, measurement_value, measurement_time,
                         CAST(measurement_time AS DATE) as measurement_day
                  FROM measurements),
     table_day_rank AS(SELECT table_day.measurement_day, table_day.measurement_id, 
                              table_day.measurement_value, 
                              ROW_NUMBER() OVER (PARTITION BY measurement_day ORDER BY measurement_time) as m_rank
                       FROM table_day)
SELECT measurement_day,
       SUM(CASE WHEN m_rank % 2 = 1 THEN measurement_value ELSE 0 END) as odd_sum,
       SUM(CASE WHEN m_rank % 2 = 0 THEN measurement_value ELSE 0 END) as even_sum
FROM table_day_rank
GROUP BY measurement_day
ORDER BY measurement_day
       

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
table_day CTE casts measurement_time to a pure date, giving each row a clean grouping key.
table_day_rank CTE adds a row number per day, ordered chronologically. Row 1, 3, 5... = odd and row 2, 4, 6... = even
Final SELECT - conditional aggregation splits odd/even ranks into two columns using SUM(CASE WHEN ...).

The first CTE could be skipped entirely by inlining the CAST.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
CAST(timestamp AS DATE) is the safe, portable way to truncate a timestamp to a calendar day. Postgres shorthand - measurement_time::date.

Window ORDER BY doesnt equal to final ORDER BY: the one inside OVER() determines rank assignment within partitions. The one at the bottom controls output row order. Both can coexist and do different jobs.
*/
