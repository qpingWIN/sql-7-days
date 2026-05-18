-- ============================================================
-- Problem:    Card Launch Success
-- Source:     DataLemur - https://datalemur.com/questions/card-launch-success
-- Difficulty: Medium
-- Day:        5
-- Date:       18/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.

monthly_cards_issued Table:
Column Name	Type
issue_month	integer
issue_year	integer
card_name	string
issued_amount	integer
monthly_cards_issued Example Input:
issue_month	issue_year	card_name	issued_amount
1	2021	Chase Sapphire Reserve	170000
2	2021	Chase Sapphire Reserve	175000
3	2021	Chase Sapphire Reserve	180000
3	2021	Chase Freedom Flex	65000
4	2021	Chase Freedom Flex	70000
Example Output:
card_name	issued_amount
Chase Sapphire Reserve	170000
Chase Freedom Flex	65000
Explanation
Chase Sapphire Reserve card was launched on 1/2021 with an issued amount of 170,000 cards and the Chase Freedom Flex card was launched on 3/2021 with an issued amount of 65,000 cards.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH proper_date_table AS(SELECT MAKE_DATE(issue_year,issue_month,1) as proper_date,
                           card_name, issued_amount
                    FROM monthly_cards_issued
),
second_hueta AS (SELECT card_name, 
       ROW_NUMBER() OVER (PARTITION BY card_name ORDER BY proper_date) as rnk,
       issued_amount
FROM proper_date_table)
SELECT card_name, issued_amount
FROM second_hueta
WHERE rnk=1
GROUP BY card_name,issued_amount
ORDER BY issued_amount DESC


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
proper_date_table builds a real date from year + month for chronological sorting
second_hueta ranks rows per card by date, earliest = rank 1
Final SELECT keeps only rank 1 (each card's launch month) and orders by amount
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
ROW_NUMBER guarantees uniqueness within partition, every row in a partition gets a different number, even on ties (broken arbitrarily by the engine). So WHERE rnk = 1 returns exactly one row per partition. No deduplication needed downstream. Contrast with RANK/DENSE_RANK which can return multiple rows tied at rank 1.

Window-rank within group filters to rank 1 (gets which row).
Order the result globally by the metric of interest (gets display order).
These are independent operations. The window ORDER BY decides ranking and the query ORDER BY decides output.

Composite sort keys — ORDER BY year, month sorts by year first, then breaks ties by month. Works because months 1–12 are already in correct numeric order. Wouldn't work if months were strings like 'Jan', 'Feb' (alphabetical is not chronological) and that's when MAKE_DATE becomes necessary.
*/
