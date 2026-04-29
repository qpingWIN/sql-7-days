# Day 1 - SELECT, Filtering & Sorting

**Date:** 26/04/2026
**Hours spent:** 4-5
**Problems solved:** 8/8

## What I studied

- SELECT, FROM, WHERE, ORDER BY, LIMIT, DISTINCT
- Comparison operators: =, !=, >, <, >=, <=
- Logical operators: AND, OR, NOT, IN, BETWEEN, LIKE
- NULL handling: IS NULL, IS NOT NULL, COALESCE
- Aliasing columns with AS
- Modulo operator for odd/even filtering
- String length functions across dialects
- Three-valued logic: TRUE, FALSE, UNKNOWN

## Key insights

- NULL is not a value — it's the absence of one. Any comparison with NULL
  returns UNKNOWN, not TRUE or FALSE. WHERE only keeps TRUE rows, so NULL
  rows are silently dropped. This is called three-valued logic.

- The NULL trap: `WHERE col != 2` silently excludes rows where col IS NULL
  because `NULL != 2` is UNKNOWN. Fix: add `OR col IS NULL` explicitly, or
  use `COALESCE(col, fallback) != 2`.

- NOT IN is dangerous when the subquery might return NULLs. A single NULL
  in the list poisons the entire result — zero rows returned, no error,
  no warning. Always add WHERE col IS NOT NULL to the subquery.

- Before writing any query, ask: "what does one row in my output represent?"
  That tells you immediately whether you need GROUP BY, DISTINCT, or just
  a plain filter.

- SQL logical execution order matters:
  FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
  This is why you can't use a SELECT alias in WHERE, but you can in ORDER BY.

## Gotchas I hit

- Pasted LeetCode's raw INSERT/CREATE statements into the problem statement
  section instead of writing the problem in plain English. Fixed from
  Problem 3 onwards.

- Forgot semicolons on early problems. Not caught by LeetCode's judge but
  would fail in a real environment.

- Tried running MySQL syntax (IF NOT EXISTS) in a PostgreSQL environment —
  Postgres requires uppercase keywords. Learned to write clean Postgres
  schemas manually rather than copying LeetCode's test harness.

- Initially wrote `FROM TWEETS` instead of `FROM Tweets` — MySQL is
  case-insensitive for table names, Postgres is not. Match the case
  defined in the schema.

## Theory Q&A

**Q: What is SQL and what is it used for?**

A: SQL (Structured Query Language) is the standard language for interacting
with relational databases. It's used to create, read, update, and delete data
(CRUD), define schema, and control access. Data is stored in tables with rows
and columns. Supported across MySQL, PostgreSQL, Oracle, SQL Server and others.

**Q: What is the difference between SQL and NoSQL?**

A: SQL databases store data in structured tables with predefined schemas and
enforce relationships between tables. They guarantee ACID properties and excel
at complex queries and joins. NoSQL databases (MongoDB, Redis, Cassandra) trade
strict consistency and rich querying for flexibility and horizontal scalability
— better for unstructured data or massive write throughput. Most real systems
use both.

**Q: What is the difference between CHAR and VARCHAR?**

A: CHAR(n) is fixed-length — always stores exactly n characters, padding with
spaces if needed. VARCHAR(n) is variable-length — stores only what's there plus
a small length overhead. Use CHAR for uniform-width values like country codes
('US', 'PT'). Use VARCHAR for anything variable like names or emails.

**Q: What does NULL mean in SQL and how do you handle it?**

A: NULL means the value is unknown or absent — not zero, not an empty string.
Check for it with IS NULL or IS NOT NULL, never with = NULL (always returns
UNKNOWN). Replace NULLs with a default using COALESCE(col, fallback), which
returns the first non-NULL argument. Example: SELECT name FROM employees
WHERE manager_id IS NULL returns all top-level employees with no manager.

**Q: What is a PRIMARY KEY?**

A: A column (or combination of columns) that uniquely identifies every row.
Must be unique and NOT NULL. The database automatically indexes it, making
lookups fast. Other tables reference it via foreign keys.

**Q: What is the difference between GROUP BY and ORDER BY?**

A: ORDER BY sorts rows — same row count, different sequence. GROUP BY collapses
rows that share a value into one row so you can aggregate them with COUNT, SUM,
AVG etc. ORDER BY changes row order; GROUP BY changes row count.

**Q: What is DISTINCT?**

A: Removes duplicate rows from the result. Applies to the entire combination
of selected columns, not a single column in isolation. SELECT DISTINCT a, b
deduplicates on (a, b) pairs, not on a alone.

**Q: What is BETWEEN and how does it work?**

A: BETWEEN is shorthand for a range filter. `WHERE age BETWEEN 18 AND 65`
is equivalent to `WHERE age >= 18 AND age <= 65`. Both bounds are inclusive —
18 and 65 are included in the result. Works on numbers, dates, and strings
(strings use alphabetical ordering). The NOT BETWEEN variant excludes the
range. One gotcha: with dates, BETWEEN '2024-01-01' AND '2024-01-31' misses
anything on 2024-01-31 after midnight if the column stores timestamps — use
explicit >= and < with timestamps to be safe.

**Q: What is LIKE and how does it work?**

A: LIKE is used for pattern matching on string columns. Two wildcard
characters: % matches any sequence of characters (including none), _ matches
exactly one character.

  WHERE name LIKE 'A%'     -- starts with A
  WHERE name LIKE '%son'   -- ends with son
  WHERE name LIKE '%an%'   -- contains an anywhere
  WHERE name LIKE '_at'    -- any single char followed by at (cat, bat, hat)
  
## Problems

| # | Problem | Source | Status | Key technique |
| --- | --- | --- | --- | --- |
| 1 | Recyclable and Low Fat Products | LeetCode | ✅ | AND filter |
| 2 | Find Customer Referee | LeetCode | ✅ | NULL-aware negative filter |
| 3 | Big Countries | LeetCode | ✅ | OR filter, read carefully |
| 4 | Article Views I | LeetCode | ✅ | DISTINCT, alias, ORDER BY |
| 5 | Invalid Tweets | LeetCode | ✅ | CHAR_LENGTH, dialect awareness |
| 6 | Not Boring Movies | LeetCode | ✅ | Modulo, multi-condition AND |
| 7 | Unfinished Parts | DataLemur | ✅ | IS NULL as positive filter |
| 8 | Page With No Likes | DataLemur | ✅ | NOT IN with NULL guard |
