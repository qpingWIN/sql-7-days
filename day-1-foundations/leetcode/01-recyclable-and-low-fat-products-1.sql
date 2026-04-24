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
Create table If Not Exists Products (product_id int, low_fats ENUM('Y', 'N'), recyclable ENUM('Y','N'))
Truncate table Products
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N')
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y')
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y')
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y')
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N')


Find the product_id of all products that are both low fat (low_fats = 'Y')
and recyclable (recyclable = 'Y')
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



