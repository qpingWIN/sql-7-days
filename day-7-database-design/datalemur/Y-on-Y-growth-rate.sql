-- ============================================================
-- Problem:    Y-on-Y Growth Rate
-- Source:     DataLemur - https://datalemur.com/questions/yoy-growth-rate
-- Difficulty: Hard
-- Day:        7
-- Date:       11/07/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
This is the same question as problem #32 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.

The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.

user_transactions Table:
Column Name	Type
transaction_id	integer
product_id	integer
spend	decimal
transaction_date	datetime
user_transactions Example Input:
transaction_id	product_id	spend	transaction_date
1341	123424	1500.60	12/31/2019 12:00:00
1423	123424	1000.20	12/31/2020 12:00:00
1623	123424	1246.44	12/31/2021 12:00:00
1322	123424	2145.32	12/31/2022 12:00:00
Example Output:
year	product_id	curr_year_spend	prev_year_spend	yoy_rate
2019	123424	1500.60	NULL	NULL
2020	123424	1000.20	1500.60	-33.35
2021	123424	1246.44	1000.20	24.62
2022	123424	2145.32	1246.44	72.12
Explanation:
Product ID 123424 is analyzed for multiple years: 2019, 2020, 2021, and 2022.

In the year 2020, the current year's spend is 1000.20, and there is no previous year's spend recorded (indicated by an empty cell).
In the year 2021, the current year's spend is 1246.44, and the previous year's spend is 1000.20.
In the year 2022, the current year's spend is 2145.32, and the previous year's spend is 1246.44.
To calculate the year-on-year growth rate, we compare the current year's spend with the previous year's spend.For instance, the spend grew by 24.62% from 2020 to 2021, indicating a positive growth rate.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH tbl AS (
  SELECT EXTRACT(YEAR FROM transaction_date) AS year,
         product_id,
         SUM(spend) AS curr_year_spend
  FROM user_transactions
  GROUP BY 1, 2
)
SELECT t1.year, t1.product_id,
       t1.curr_year_spend AS curr_year_spend, t2.curr_year_spend as prev_year_spend,
       ROUND(100.0*((t1.curr_year_spend-t2.curr_year_spend)/t2.curr_year_spend),2)
FROM tbl t1
LEFT JOIN tbl t2 ON t1.year = t2.year+1 AND t1.product_id = t2.product_id
ORDER BY product_id, year

       


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
1. Aggregate to product-year grain. Raw table is one row per transaction,
   growth rate is defined on yearly totals, so first collapse to
   (year, product_id, total_spend).

2. Attach previous year's spend to each row. Did this via self-join:
   join the yearly table to itself on same product_id and t1.year = t2.year + 1.
   LEFT JOIN so the first year of each product survives with NULL prev spend.

3. Compute growth: 100 * (curr - prev) / prev, rounded to 2dp.
   NULL prev propagates to NULL growth automatically — correct for year 1.

Why self-join over LAG: LAG(spend) OVER (PARTITION BY product_id ORDER BY year)
grabs the previous *row*, not the previous *year*. If a product has a gap
(2019, then 2021), LAG treats 2019 as the prior year and computes a bogus
one-year rate. The join on year = year + 1 returns NULL across gaps, which is
the honest answer. Tradeoff: LAG is one pass, the self-join is an extra scan.

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
-
*/
