-- ============================================================
-- Problem:    Page with No Likes
-- Source:     DataLemur - https://datalemur.com/questions/sql-page-with-no-likes
-- Difficulty: Easy
-- Day:        1
-- Date:       24/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

pages Table:
Column Name	Type
page_id	integer
page_name	varchar
pages Example Input:
page_id	page_name
20001	SQL Solutions
20045	Brain Exercises
20701	Tips for Data Analysts
page_likes Table:
Column Name	Type
user_id	integer
page_id	integer
liked_date	datetime
page_likes Example Input:
user_id	page_id	liked_date
111	20001	04/08/2022 00:00:00
121	20045	03/12/2022 00:00:00
156	20001	07/25/2022 00:00:00
Example Output:
page_id
20701
The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT page_id FROM pages 
WHERE page_id NOT IN (
    SELECT DISTINCT page_id FROM page_likes
    WHERE page_id IS NOT NULL
);

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
My first instinct was NOT IN with a subquery: get all page_ids that have at least one like, then exclude them from the pages table. The subquery
SELECT page_id FROM page_likes gives me the liked pages, and NOT IN filters them out of the main query.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
DISTINCT: not strictly necessary here because NOT IN doesn't care about
duplicates — (1, 1, 1) and (1) behave identically inside NOT IN.
If the subquery returns any NULL page_id, NOT IN returns ZERO rows. Always add `WHERE page_id IS NOT NULL` to the subquery.
*/
