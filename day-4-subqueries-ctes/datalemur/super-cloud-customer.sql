-- ============================================================
-- Problem:    Super Cloud Customer
-- Source:     DataLemur -https://datalemur.com/questions/supercloud-customer
-- Difficulty: Medium
-- Day:        4
-- Date:       04/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product category listed in the products table.

Write a query that identifies the customer IDs of these Supercloud customers.

customer_contracts Table:
Column Name	Type
customer_id	integer
product_id	integer
amount	integer
customer_contracts Example Input:
customer_id	product_id	amount
1	1	1000
1	3	2000
1	5	1500
2	2	3000
2	6	2000
products Table:
Column Name	Type
product_id	integer
product_category	string
product_name	string
products Example Input:
product_id	product_category	product_name
1	Analytics	Azure Databricks
2	Analytics	Azure Stream Analytics
4	Containers	Azure Kubernetes Service
5	Containers	Azure Service Fabric
6	Compute	Virtual Machines
7	Compute	Azure Functions
Example Output:
customer_id
1
Explanation:
Customer 1 bought from Analytics, Containers, and Compute categories of Azure, and thus is a Supercloud customer. Customer 2 isn't a Supercloud customer, since they don't buy any container services from Azure.

The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT cc.customer_id
FROM customer_contracts as cc
JOIN products p ON cc.product_id = p.product_id 
GROUP BY cc.customer_id
HAVING COUNT(DISTINCT p.product_category) = (
  SELECT COUNT(DISTINCT product_category)
  FROM products
  );

--OR THIS--
WITH temp1 AS(SELECT cc.customer_id, COUNT(DISTINCT p.product_category) as cnt
FROM customer_contracts cc
LEFT JOIN products p ON cc.product_id = p.product_id
GROUP BY cc.customer_id
)
SELECT customer_id 
FROM temp1
WHERE cnt = (SELECT COUNT(DISTINCT product_category)
             FROM products)

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Strategy: count distinct categories per customer, compare to the total number of distinct categories that exist

If they match, that customer covers every category → Supercloud
If less, they're missing at least one category
group by customer_id only, count distinct categories on both sides
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
GROUP BY granularity controls bucket size, which controls what aggregates can see. Grouping by (customer_id, product_id) makes each bucket a single (customer, product) pair, so any per-bucket count maxes out at 1. 
Group by just the dimension you want to aggregate over, if you want one count per customer, group by customer only.
Always sanity-check that the left and right sides of a HAVING comparison count or measure the same thing.
The "covers all" pattern via cardinality matching. "X has all Ys" can be expressed as: count of distinct Ys associated with X equals total count of distinct Ys.
Useful pattern that generalizes far — relational division questions ("students who took every required course", "users who hit every milestone") all collapse to this shape.
Scalar subquery as a comparison target in HAVING. HAVING aggregate = (SELECT scalar) is a clean way to compare per-group counts to a global total. The scalar subquery runs once, the per-group aggregate runs per group, then the equality filter keeps matching groups.
Always use the alias once you've defined one.
*/