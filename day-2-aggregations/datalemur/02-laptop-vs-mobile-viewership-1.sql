-- ============================================================
-- Problem:    Laptop vs Mobile Viewership
-- Source:     DataLemur - https://datalemur.com/questions/laptop-mobile-viewership
-- Difficulty: Easy
-- Day:        2
-- Date:       29/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
This is the same question as problem #3 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.

Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.

Effective 15 April 2023, the solution has been updated with a more concise and easy-to-understand approach.

viewership Table
Column Name	Type
user_id	integer
device_type	string ('laptop', 'tablet', 'phone')
view_time	timestamp
viewership Example Input
user_id	device_type	view_time
123	tablet	01/02/2022 00:00:00
125	laptop	01/07/2022 00:00:00
128	laptop	02/09/2022 00:00:00
129	phone	02/09/2022 00:00:00
145	tablet	02/24/2022 00:00:00
Example Output
laptop_views	mobile_views
2	3
Explanation
Based on the example input, there are a total of 2 laptop views and 3 mobile views.

The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
    SUM(CASE WHEN device_type = 'tablet' or device_type = 'phone' THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
What does one row in my output represent?
The entire table summarised into one row thus no GROUP BY needed.
The output has two columns, not two rows, so this is a pivot
not a group-by problem.

Initial approach was wrong which was a subquery grouping by device_type
giving three rows (one per device type), not two columns. To get
two columns from conditional data I needed to pivot: aggregate
with a condition, not group by the condition.

Pivoting pattern: CASE WHEN inside SUM counts rows that match
a condition. ELSE 0 ensures non-matching rows contribute 0
instead of NULL, keeping the sum correct.

Mobile includes both tablet and phone two values for one
condition. Used OR initially, then learned IN is cleaner for
multiple values on the same column:
  device_type = 'tablet' OR device_type = 'phone'
  device_type IN ('tablet', 'phone')

No HAVING, no ORDER BY just single row output, no groups to filter,
no ordering needed.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Pivoting rows into columns when output needs categories as
columns rather than rows, use CASE WHEN inside an aggregate:
  SUM(CASE WHEN condition THEN 1 ELSE 0 END) AS col_name
One expression per output column. No GROUP BY if the result
is a single summary row.

ELSE 0 matters, without it, non-matching rows return NULL
which propagates through SUM incorrectly in edge cases.

IN as shorthand for multiple OR conditions on the same column:
  col = 'a' OR col = 'b' OR col = 'c'
  col IN ('a', 'b', 'c')
Cleaner, more readable, same result.

PostgreSQL FILTER syntax — native alternative to CASE WHEN:
  COUNT(*) FILTER (WHERE condition) AS col_name
PostgreSQL only thus not portable. Use CASE WHEN in interviews
unless you know the database is PostgreSQL.

No GROUP BY when output is a single summary row. GROUP BY is
only needed when you want one row per group, not one row total.
*/
