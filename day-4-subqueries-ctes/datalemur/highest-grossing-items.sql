-- ============================================================
-- Problem:    Highest Grossing Items
-- Source:     DataLemur - https://datalemur.com/questions/sql-highest-grossing
-- Difficulty: Medium
-- Day:        4
-- Date:       04/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
This is the same question as problem #12 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given a table containing data on Amazon customers and their spending on products in different category, write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.

product_spend Table:
Column Name	Type
category	string
product	string
user_id	integer
spend	decimal
transaction_date	timestamp
product_spend Example Input:
category	product	user_id	spend	transaction_date
appliance	refrigerator	165	246.00	12/26/2021 12:00:00
appliance	refrigerator	123	299.99	03/02/2022 12:00:00
appliance	washing machine	123	219.80	03/02/2022 12:00:00
electronics	vacuum	178	152.00	04/05/2022 12:00:00
electronics	wireless headset	156	249.90	07/08/2022 12:00:00
electronics	vacuum	145	189.00	07/15/2022 12:00:00
Example Output:
category	product	total_spend
appliance	refrigerator	299.99
appliance	washing machine	219.80
electronics	vacuum	341.00
electronics	wireless headset	249.90
Explanation:
Within the "appliance" category, the top two highest-grossing products are "refrigerator" and "washing machine."

In the "electronics" category, the top two highest-grossing products are "vacuum" and "wireless headset."
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT category, product, total_spend
FROM (
    SELECT 
        category, 
        product, 
        SUM(spend) AS total_spend,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS rnk
    FROM product_spend
    WHERE EXTRACT (YEAR FROM transaction_date) = 2022
    GROUP BY category, product
) AS ranked
WHERE rnk <= 2
ORDER BY category, rnk

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
"Top N per group" pattern - window functions, since plain LIMIT is global, not per group
Each row in product_spend is a transaction, not a product total - GROUP BY (category, product) with SUM(spend) first, then rank
DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) ranks per-product totals within each category
First attempt used ORDER BY spend inside the window, fails because raw spend is gone after GROUP BY; must use SUM(spend)
Window functions can't go in WHERE therefore wrap as subquery, filter on the rank outside
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Window functions don't collapse rows like GROUP BY does — they compute per-row values across a window of related rows. That's what makes "top N per group" possible.
func() OVER (PARTITION BY ... ORDER BY ...): PARTITION BY = per-group split, ORDER BY = ranking within each partition.
Three ranking functions for ties: ROW_NUMBER (unique, arbitrary tie-break), RANK (ties share, skip after), DENSE_RANK (ties share, no skip).
Window functions run after GROUP BY, so they can reference aggregates like SUM(...) inside OVER (...).
Window functions can't appear in WHERE — wrap in a subquery and filter on the result outside.
*/
