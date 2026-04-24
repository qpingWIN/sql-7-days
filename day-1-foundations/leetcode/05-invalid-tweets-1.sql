-- ============================================================
-- Problem:    Invalid Tweets 
-- Source:     LeetCode — https://leetcode.com/problems/invalid-tweets/description/
-- Difficulty: Easy
-- Day:        1
-- Date:       24/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
Table: Tweets

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
tweet_id is the primary key (column with unique values) for this table.
content consists of alphanumeric characters, '!', or ' ' and no other special characters.
This table contains all the tweets in a social media app.
 

Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Tweets table:
+----------+-----------------------------------+
| tweet_id | content                           |
+----------+-----------------------------------+
| 1        | Let us Code                       |
| 2        | More than fifteen chars are here! |
+----------+-----------------------------------+
Output: 
+----------+
| tweet_id |
+----------+
| 2        |
+----------+
Explanation: 
Tweet 1 has length = 11. It is a valid tweet.
Tweet 2 has length = 33. It is an invalid tweet.
*/

-- ============================================================
-- MY SOLUTION

SELECT tweet_id FROM Tweets
WHERE char_length(content) > 15;

-- ============================================================


-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
   No NULL concern — content is a VARCHAR column and likely NOT NULL, but
   CHAR_LENGTH(NULL) returns NULL, which would be filtered out by WHERE
   anyway. Safe either way.

   Using CHAR_LENGTH rather than LENGTH because the problem involves character count, not byte count. For ASCII-only content they'd return the same result, but CHAR_LENGTH is semantically correct and safe for Unicode.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
String length functions vary by database. DIALECT TABLE:

| Database       | Byte length      | Character length       |
| -------------- | ---------------- | ---------------------- |
| MySQL          | LENGTH(s)        | CHAR_LENGTH(s)         |
| PostgreSQL     | OCTET_LENGTH(s)  | LENGTH(s) or CHAR_LENGTH(s) |
| SQL Server     | DATALENGTH(s)    | LEN(s) (trims trailing spaces!) |
| Oracle         | LENGTHB(s)       | LENGTH(s)              |
| SQLite         | -                | LENGTH(s)              |

Unicode byte count != character count. in MySQL, LENGTH('café') returns 5 (bytes, because é is 2 bytes
in UTF-8), while CHAR_LENGTH('café') returns 4 (characters)

MySQL is case-insensitive for table names, Postgres is not.
*/
