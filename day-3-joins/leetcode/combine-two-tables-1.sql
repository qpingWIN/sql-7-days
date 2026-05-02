-- ============================================================
-- Problem:    Combine Two Tables
-- Source:     Leetcode - https://leetcode.com/problems/combine-two-tables/description/
-- Difficulty: Easy
-- Day:        3
-- Date:       01/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| personId    | int     |
| lastName    | varchar |
| firstName   | varchar |
+-------------+---------+
personId is the primary key (column with unique values) for this table.
This table contains information about the ID of some persons and their first and last names.
 

Table: Address

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| addressId   | int     |
| personId    | int     |
| city        | varchar |
| state       | varchar |
+-------------+---------+
addressId is the primary key (column with unique values) for this table.
Each row of this table contains information about the city and state of one person with ID = PersonId.
 

Write a solution to report the first name, last name, city, and state of each person in the Person table. If the address of a personId is not present in the Address table, report null instead.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Person table:
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+
Address table:
+-----------+----------+---------------+------------+
| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |
+-----------+----------+---------------+------------+
Output: 
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+
Explanation: 
There is no address in the address table for the personId = 1 so we return null in their city and state.
addressId = 1 contains information about the address of personId = 2.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

select p.firstName, p.lastName, a.city, a.state
from person as p
left join address a on p.personId = a.personId

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
"every person, even those without an address." The word every is the trigger.
Person and Address are linked by personId. Not every person has an address.
I want to keep all rows from Person regardless of match, thus I'm going to use LEFT JOIN with Person on the left.
Direction matters: if I put Address on the left, I'd lose people with no address
No filtering needed: I want everyone, so no WHERE clause.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Trigger words signalling join type. "All / every / even if no" = LEFT JOIN. 
The left side of a LEFT JOIN is the "must-keep" side. Whichever table I want fully preserved goes there.
Unmatched rows get NULL padding in the right-side columns and that's the feature of a LEFT JOIN, not a bug.
INNER JOIN (also called a JOIN) would silently drop people without addresses. Picking the wrong join type doesn't throw an error; it just gives a wrong answer.
Aliases (p, a) keep the query readable, especially as joins multiply.
*/
