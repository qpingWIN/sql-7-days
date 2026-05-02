-- ============================================================
-- Problem:    Cities With Completed Trades
-- Source:     DataLemur - https://datalemur.com/questions/completed-trades
-- Difficulty: Easy
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
This is the same question as problem #2 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.

Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order. Output the city name and the corresponding number of completed trade orders.

trades Table:
Column Name	Type
order_id	integer
user_id	integer
quantity	integer
status	string ('Completed', 'Cancelled')
date	timestamp
price	decimal (5, 2)
trades Example Input:
order_id	user_id	quantity	status	date	price
100101	111	10	Cancelled	08/17/2022 12:00:00	9.80
100102	111	10	Completed	08/17/2022 12:00:00	10.00
100259	148	35	Completed	08/25/2022 12:00:00	5.10
100264	148	40	Completed	08/26/2022 12:00:00	4.80
100305	300	15	Completed	09/05/2022 12:00:00	10.00
100400	178	32	Completed	09/17/2022 12:00:00	12.00
100565	265	2	Completed	09/27/2022 12:00:00	8.70
users Table:
Column Name	Type
user_id	integer
city	string
email	string
signup_date	datetime
users Example Input:
user_id	city	email	signup_date
111	San Francisco	rrok10@gmail.com	08/03/2021 12:00:00
148	Boston	sailor9820@gmail.com	08/20/2021 12:00:00
178	San Francisco	harrypotterfan182@gmail.com	01/05/2022 12:00:00
265	Denver	shadower_@hotmail.com	02/26/2022 12:00:00
300	San Francisco	houstoncowboy1122@hotmail.com	06/30/2022 12:00:00
Example Output:
city	total_orders
San Francisco	3
Boston	2
Denver	1
In the given dataset, San Francisco has the highest number of completed trade orders with 3 orders. Boston holds the second position with 2 orders, and Denver ranks third with 1 order.

The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================
SELECT users.city, count(trades.order_id) as total_orders
FROM trades
JOIN users ON trades.user_id=users.user_id
WHERE trades.status ='Completed'
GROUP BY users.city
ORDER BY total_orders DESC
LIMIT 3;


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Need city per trade but city lives in users, not trades. Join on user_id.
Only completed trades count thus WHERE t.status = 'Completed' filters at the row level (before grouping, since status is a per-row attribute).
GROUP BY users.city to bucket trades by city; COUNT(trades.order_id) tallies each bucket.
ORDER BY total_orders DESC LIMIT 3 for the top 3.
INNER JOIN as every trade should have a user; if not, that's broken data and we don't want it in the report anyway.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Standard analytics shape: join - filter (WHERE) - group - aggregate - sort - limit.
WHERE vs HAVING: WHERE filters rows before grouping, HAVING filters groups after. Use WHERE when the filter column is per-row (like status); use HAVING when the filter is on an aggregate.
Clause order is fixed in SQL: SELECT - FROM - JOIN - WHERE - GROUP BY - HAVING - ORDER BY - LIMIT. Wrong order = syntax error. The order also reflects the logical execution stages as each clause operates on the output of the previous one.
After GROUP BY, only grouped columns and aggregates are accessible. Other columns are "gone" because they don't survive the bucketing. This is why HAVING can't reference status directly in a query grouped by city.
USING (col) is shorthand for ON a.col = b.col when the column names match. I should recognise it but will default to ON for clarity.

Trap
Putting WHERE after GROUP BY is wrong order syntactically and logically. If I find myself wanting to filter after grouping based on a per-row column, that's a sign the filter belonged in WHERE all along.
*/
