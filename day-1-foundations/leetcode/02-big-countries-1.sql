-- ============================================================
-- Problem:    Big Countries
-- Source:     LeetCode — https://leetcode.com/problems/big-countries/
-- Difficulty: Easy
-- Day:        1
-- Date:       24/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------

name is the primary key (column with unique values) for this table.
Each row of this table gives information about the name of a country, the continent to which it belongs, its area, the population, and its GDP value.

A country is big if:

it has an area of at least three million (i.e., 3000000 km2), or
it has a population of at least twenty-five million (i.e., 25000000).
Write a solution to find the name, population, and area of the big countries.

Return the result table in any order.

*/

-- ============================================================
-- MY SOLUTION


SELECT name, population, area from World
WHERE area >=3000000 
    OR population >= 25000000;
-- ============================================================



-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
 Using OR because either condition being true is sufficient to classify a country as big.

NULL concern: area and population are INT without NOT NULL constraints,
so NULLs are theoretically possible. NULL >= 3000000 is UNKNOWN, thus row dropped.
In production I'd verify the columns are NOT NULL. Test data is clean here.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
 SQL has three truth values: TRUE, FALSE, and UNKNOWN (NULL). Any comparison with NULL results in UNKNOWN. WHERE only keeps rows where condition is TRUE, so rows with NULL in area or population are excluded from results.
 PostgreSQL requires uppercase: IF NOT EXISTS. MySQL is case-insensitive for keywords, PostgreSQL is not
 CHAR is fixed-length and faster for uniform width values; VARCHAR is variable-length and more space efficient for anything that varies.
*/
