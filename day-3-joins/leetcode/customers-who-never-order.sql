-- ============================================================
-- Problem:    Customers Who Never Order
-- Source:     Leetcode - https://leetcode.com/problems/customers-who-never-order/
-- Difficulty: Easy
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Customers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID and name of a customer.
 

Table: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
customerId is a foreign key (reference columns) of the ID from the Customers table.
Each row of this table indicates the ID of an order and the ID of the customer who ordered it.
 

Write a solution to find all customers who never order anything.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Output: 
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

select c.name as Customers
from Customers c
left join orders o on c.id = o.customerId
where o.id is NULL;


-- OR THIS --
SELECT c.name AS Customers
FROM Customers c
WHERE NOT EXISTS (
  SELECT 1 FROM Orders o WHERE o.customerId = c.id
);

--OR THIS --
SELECT c.name AS Customers
FROM Customers c
WHERE id NOT IN (SELECT customerId FROM Orders);
-- This is risky because it silently breaks if the subquery returns any NULLs. id != NULL evaluates to UNKNOWN, then entire WHERE fails and query returns zero rows. NOT EXISTS and LEFT JOIN ... IS NULL are NULL-safe whereas NOT IN is not.



-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Recognized the anti-join shape. "Never order" = customers who exist in Customers but have no corresponding row in Orders.
Picked the LEFT JOIN + IS NULL idiom. LEFT JOIN preserves every customer. Unmatched customers get NULL-padded on the Orders side. Filtering WHERE o.customerId IS NULL keeps only those padded (= unmatched) rows.
Chose which column to test for NULL. Best practice is to test a column guaranteed NOT NULL in the source table which would be the primary key. That way IS NULL unambiguously means "no row matched," not "the data itself was NULL."
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Anti-join trigger words: never, without, no, missing. Reach for one of three idioms.
Three anti-join idioms ranked:

    1.LEFT JOIN ... WHERE IS NULL: visual, safe
    2.NOT EXISTS is safe, often fastest, slightly more abstract
NOT IN is readable but silently wrong with NULLs; avoid unless you've verified no NULLs in the subquery


Pick a NOT NULL column (ideally primary key) for the IS NULL check to avoid ambiguity between "join didn't match" and "real NULL in data."
EXISTS only cares about row existence, not values. SELECT 1 is the idiomatic placeholder.
NULL kills equality: x = NULL, x != NULL, NULL = NULL all return UNKNOWN. Use IS NULL / IS NOT NULL for NULL checks.
*/
