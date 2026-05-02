-- ============================================================
-- Problem:    Laptop vs Mobile Viewership
-- Source:     DataLemur - https://datalemur.com/questions/laptop-mobile-viewership
-- Difficulty: Easy
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
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
--OLD SOLUTION--
SELECT
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
    SUM(CASE WHEN device_type = 'tablet' or device_type = 'phone' THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

--JOIN SOLUTION--
SELECT laptop.cnt AS laptop_views, mobile.cnt AS mobile_views
FROM (SELECT COUNT(*) AS cnt FROM viewership WHERE device_type = 'laptop') AS laptop
CROSS JOIN (SELECT COUNT(*) AS cnt FROM viewership WHERE device_type IN ('phone','tablet')) AS mobile;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
The expected output is one row, two columns: not a tall GROUP BY device_type shape. That rules out grouping.
Need two separate filtered counts of the same table thus conditional aggregation. SUM(CASE WHEN ... THEN 1 ELSE 0 END) counts rows matching a condition.
Both counts in one SELECT thus single table scan, single row of output.

OR:
Each subquery returns 1 row. CROSS JOIN glues them into one row with both columns. Works, but two table scans and more nesting.

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
CROSS JOIN 
What it does: pairs every row of table A with every row of table B. No ON clause because there's no matching condition. 
Size: if A has m rows and B has n rows, the result has m × n rows. (The mathematical "Cartesian product.")
When to use:
    Generating combinations - every size × color, every date × product, every user × feature flag.
    Gluing scalars into one row - CROSS JOIN of two single-row subqueries (e.g., two COUNT(*) results) gives you one row with both values side by side.

Trap: the old comma syntax (FROM a, b) without a WHERE linking them is an accidental CROSS JOIN which is an easy way to explode row counts. The explicit JOIN ... ON syntax prevents this.
*/
