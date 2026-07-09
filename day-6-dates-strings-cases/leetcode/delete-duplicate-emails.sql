-- ============================================================
-- Problem:    Delete Duplicate Emails
-- Source:     LeetCode - https://leetcode.com/problems/delete-duplicate-emails/
-- Difficulty: Easy
-- Day:        6
-- Date:       20/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.
 

Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.

For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.

For Pandas users, please note that you are supposed to modify Person in place.

After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table. The final order of the Person table does not matter.

The result format is in the following example.

 

Example 1:

Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Output: 
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT MIN(id) AS id, email
FROM Person
GROUP BY email;

--USING DELETE--

DELETE p1
FROM Person p1
JOIN Person p2 ON p1.email = p2.email AND p1.id > p2.id;

--OR THIS (for selecting the non-duplicated emails)--

SELECT *
FROM Person p1
WHERE NOT EXISTS (
    SELECT 1
    FROM Person p2
    WHERE p2.email = p1.email AND p2.id < p1.id
)

--OR THIS(for selecting the non-duplicated emails)--

SELECT p1.*
FROM Person p1
LEFT JOIN Person p2
    ON p1.email = p2.email
   AND p2.id < p1.id
WHERE p2.id IS NULL;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*

Self-join Person p1 JOIN Person p2 ON p1.email = p2.email AND p1.id > p2.id pairs each duplicate with every smaller-id sibling.
DELETE p1 removes any row that ever appears as p1, meaning any row that has a same-email row with a smaller id below it.
Min-id rows never appear as p1 (nothing smaller exists), so they survive.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
DISTINCT is row-wise, not column-wise. DISTINCT dedupes the (a, b) tuple. If one column is already unique, nothing happens
Aliases like p1 and p2 are independent iterators over the same table. Conditions filter pairings, not single rows. p1.id > p2.id doesn't mean "p1 is smallest", it means "there exists something smaller than p1." 
Rows with nothing smaller never get paired, so they survive the delete.
*/
