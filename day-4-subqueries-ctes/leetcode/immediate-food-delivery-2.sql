-- ============================================================
-- Problem:    Immediate Food Delivery II
-- Source:     LeetCode - https://leetcode.com/problems/immediate-food-delivery-ii/description/
-- Difficulty: Medium
-- Day:        4
-- Date:       04/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

The result format is in the following example.

 

Example 1:

Input: 
Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+
Output: 
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
Explanation: 
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT ROUND(100.0*SUM(CASE WHEN d.order_date = d.customer_pref_delivery_date THEN 1 ELSE 0 END)/COUNT(*),2) as immediate_percentage
FROM Delivery d
JOIN (
    SELECT customer_id, MIN(order_date) as first_od
    FROM Delivery
    GROUP BY customer_id
) as first_d
ON d.order_date = first_d.first_od and d.customer_id = first_d.customer_id



-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Problem narrows scope: percentage of immediate orders only among each customer's first order, not across all orders
A customer with 5 orders contributes only one row (their first), regardless of what their other orders look like.
"First order per customer" is the real puzzle; percentage calculation is a bolt-on at the end
First instinct: GROUP BY customer_id and select order_date alongside it
This breaks the golden rule of GROUP BY, selecting raw columns from grouped queries is undefined behavior
Strict MySQL rejects it, lax mode silently picks an arbitrary row's value (worse than failing loudly)
Fix: split into two stages

Stage 1: produce one row per customer holding their first-order row
Stage 2: compute the percentage over that filtered set


Stage 1 mechanics:

MIN(order_date) GROUP BY customer_id finds the earliest date per customer
But the aggregate result loses other columns like customer_pref_delivery_date
JOIN the aggregate back to Delivery on (customer_id, first_date) to recover full rows


Stage 2 mechanics:

Conditional aggregation: SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) for the numerator
COUNT(*) for the denominator
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Golden rule of GROUP BY: every SELECT column must be in GROUP BY or wrapped in an aggregate. Anything else is undefined.
ORDER BY runs after GROUP BY, so it can't rescue a malformed GROUP BY query — the rows are already collapsed by then.
"Extremum per group + recover full row" pattern: aggregating with MIN/MAX gives you the extremum but loses other columns. JOIN the aggregate back on (group_key, extremum) to get the full row. Same shape as Department Highest Salary, different aggregate.
Two equivalent forms for "first per group": derived-table JOIN, or correlated subquery in WHERE comparing each row to per-group MIN. Pick whichever reads more clearly.
*/
