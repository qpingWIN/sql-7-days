-- ============================================================
-- Problem:    Average Review Ratings
-- Source:     DataLemur - https://datalemur.com/questions/sql-avg-review-ratings
-- Difficulty: Easy
-- Day:        2
-- Date:       29/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.

P.S. If you've read the Ace the Data Science Interview, and liked it, consider writing us a review?

reviews Table:
Column Name	Type
review_id	integer
user_id	integer
submit_date	datetime
product_id	integer
stars	integer (1-5)
reviews Example Input:
review_id	user_id	submit_date	product_id	stars
6171	123	06/08/2022 00:00:00	50001	4
7802	265	06/10/2022 00:00:00	69852	4
5293	362	06/18/2022 00:00:00	50001	3
6352	192	07/26/2022 00:00:00	69852	3
4517	981	07/05/2022 00:00:00	69852	2
Example Output:
mth	product	avg_stars
6	50001	3.50
6	69852	4.00
7	69852	2.50
Explanation
Product 50001 received two ratings of 4 and 3 in the month of June (6th month), resulting in an average star rating of 3.5.

The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT EXTRACT(MONTH FROM submit_date) AS mth,
       product_id,
       ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date), product_id
ORDER BY mth, product_id;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
What does one row in my output represent?
One (month, product) combination so GROUP BY month and product_id.

What am I calculating per group?
Average star rating per product per month thus AVG(stars).

Date grouping: needed to extract just the month number for display.
EXTRACT(MONTH FROM submit_date) pulls the month as an integer (1-12).
Used the same expression in both SELECT and GROUP BY because PostgreSQL
requires the exact same expression in both, it won't infer the
relationship between different expressions on the same column.

Known limitation: EXTRACT(MONTH) loses the year — June 2021 and
June 2022 would collapse into the same group. For this dataset
it doesn't matter (data is within one year), but in production
DATE_TRUNC('month', submit_date) is safer because it preserves year
and month together as a single timestamp value (2022-06-01).

No HAVING needed as problem asks for all products, no group filter.
Ordering: mth ASC then product_id ASC matches expected output.

*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
PostgreSQL GROUP BY rule is strict:
Every column in SELECT that isn't inside an aggregate must appear
in GROUP BY using the exact same expression. Unlike MySQL, Postgres
won't infer relationships between different expressions on the
same column, EXTRACT(MONTH FROM col) and DATE_TRUNC('month', col)
are different expressions.

Date extraction in PostgreSQL:
  EXTRACT(MONTH FROM col): month number only (1-12), loses year
  EXTRACT(YEAR FROM col): year only
  DATE_TRUNC('month', col): truncates to first of month (2022-06-01)

MySQL equivalent:
  MONTH(col), YEAR(col): MySQL only, not portable

When to use each:
  EXTRACT(MONTH): display only, single-year datasets
  DATE_TRUNC: grouping across multiple years, production code

GROUP BY doesn't have to match SELECT visually, but in PostgreSQL
the expressions must be identical if not aggregated. The safest
approach: use the same expression in SELECT, GROUP BY, and ORDER BY.
*/
