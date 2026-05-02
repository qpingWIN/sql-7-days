-- ============================================================
-- Problem:    Product Sales Analysis 1
-- Source:     LeetCode - https://leetcode.com/problems/product-sales-analysis-i/description/
-- Difficulty: Easy 
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
able: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key (combination of columns with unique values) of this table.
product_id is a foreign key (reference column) to Product table.
Each row of this table shows a sale on the product product_id in a certain year.
Note that the price is per unit.
 

Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key (column with unique values) of this table.
Each row of this table indicates the product name of each product.
 

Write a solution to report the product_name, year, and price for each sale_id in the Sales table.

Return the resulting table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
Output: 
+--------------+-------+-------+
| product_name | year  | price |
+--------------+-------+-------+
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |
+--------------+-------+-------+
Explanation: 
From sale_id = 1, we can conclude that Nokia was sold for 5000 in the year 2008.
From sale_id = 2, we can conclude that Nokia was sold for 5000 in the year 2009.
From sale_id = 7, we can conclude that Apple was sold for 9000 in the year 2011.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT p.product_name, s.year, s.price
FROM Sales s
JOIN Product p ON s.product_id = p.product_id;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Recognized the lookup pattern. The Sales table has product_id (a foreign key) but no human-readable product name. The name lives in Product. Need to join the two so each sale row gets its product's name attached.
Identified the join key. Sales.product_id is the foreign key; Product.product_id is the primary key it references. Standard FK→PK join.
Picked INNER JOIN. Every sale should have a corresponding product (referential integrity). A sale with no product would mean broken data and INNER JOIN drops such cases naturally.
Selected the requested columns. product_name from Product, year and price from Sales, pulled across the join from both tables in a single SELECT.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Lookup joins are the workhorse of analytics. Fact table (events: sales, orders, clicks, visits) + dimension table (entities: products, customers, users) is the foundation of nearly every BI report.
INNER JOIN signals intent: "I expect every fact row to have a matching dimension row" When referential integrity holds, INNER and LEFT return identical results thus the choice is about what you mean, not what you get.
Redundant AS is noise. s.year AS year does nothing, the output column is year either way. I'll use AS only when changing the name (e.g., c.name AS customer_name).
Defaulting to LEFT JOIN everywhere out of caution. It's not "safer", it's noisier, hides intent, and can mask data-integrity bugs by silently allowing orphaned facts through with NULL labels. I'll pick the join type that matches what I actually mean.
*/
