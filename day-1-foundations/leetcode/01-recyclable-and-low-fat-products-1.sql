-- ============================================================
-- Problem:    Recyclable and Low Fat Products
-- Source:     LeetCode — https://leetcode.com/problems/recyclable-and-low-fat-products/description/
-- Difficulty: Easy
-- Day:        1
-- Date:       24/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Products

| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| low_fats    | enum    |
| recyclable  | enum    |
+-------------+---------+
product_id is the primary key (column with unique values) for this table.
low_fats is an ENUM (category) of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.
recyclable is an ENUM (category) of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.
 

Write a solution to find the ids of products that are both low fat and recyclable.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Products table:
+-------------+----------+------------+
| product_id  | low_fats | recyclable |
+-------------+----------+------------+
| 0           | Y        | N          |
| 1           | Y        | Y          |
| 2           | N        | Y          |
| 3           | Y        | Y          |
| 4           | N        | N          |
+-------------+----------+------------+
Output: 
+-------------+
| product_id  |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: Only products 1 and 3 are both low fat and recyclable.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT product_id FROM products
WHERE low_fats = 'Y' 
    AND recyclable = 'Y';

-- ====================================================================================================================
 -- THOUGHT PROCESS
/*
Both conditions must be true simultaneously, thus AND, not OR.

NULL concern: ENUM columns disallow NULL by default in MySQL,
so no NULL handling needed here. Worth checking on every filter query.

*/


-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
ENUM makes sure that the only valid values for the column input are 'Y' and 'N', anything else is rejected by the database
[prevents invalid data]

TRUNCATE TABLE Products: deletes all rows from the table(resets the table), while keepin the table structure intact(shapes preserved) 
DELETE FROM Products: deletes row by row, WHERE can be imposed, fully logged
*/



