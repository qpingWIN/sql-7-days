# Day 2 — Aggregations, GROUP BY & HAVING

**Date:** 29/04/2026
**Hours spent: 6
**Problems solved:** 10/10

## What I studied

- Aggregate functions: COUNT, SUM, AVG, MIN, MAX
- GROUP BY collapsing rows into groups
- HAVING filtering after aggregation
- WHERE vs HAVING distinction
- COUNT(*) vs COUNT(column) vs COUNT(DISTINCT column)
- Grouping by multiple columns
- Date functions: DATE_SUB, EXTRACT, DATE_TRUNC
- Conditional aggregation: SUM(CASE WHEN ... THEN 1 ELSE 0 END)
- Pivoting rows into columns
- Scalar subqueries for global totals
- LIMIT for top N problems
- Multiple ORDER BY columns for tiebreaking

## Key insights

- The mental shift from Day 1: stop thinking about individual rows,
  start thinking about groups. Every aggregation query starts with
  "what does one row in my output represent?"

- WHERE vs HAVING is the core Day 2 distinction. WHERE filters rows
  before grouping where aggregates don't exist yet. HAVING filters groups
  after aggregation where aggregates exist.

- Pivoting: when output needs categories as columns rather than rows,
  use SUM(CASE WHEN condition THEN 1 ELSE 0 END). One expression per
  output column. No GROUP BY when the result is a single summary row.

- PostgreSQL GROUP BY rule is strict: every non-aggregated column in
  SELECT must appear in GROUP BY using the exact same expression.
  MySQL is lenient and picks arbitrary values, which is a bug not a feature.

- Scalar subquery in SELECT runs once and returns a single value which is 
  useful for global totals alongside per-group counts without a join.

## Gotchas I hit

- Used COUNT(DISTINCT session_id) instead of COUNT(DISTINCT user_id)
  for active users as session and user are different things. 

- YEAR()/MONTH() are MySQL only and DataLemur uses PostgreSQL.
  Use EXTRACT(YEAR FROM col) / EXTRACT(MONTH FROM col) instead.

- Tried to use a subquery to get two rows then display as two columns which was
  wrong approach. Rows to columns requires pivoting with CASE WHEN,
  not grouping.

## Theory Q&A

**Q: What are aggregate functions in SQL?**

A: Functions that perform a calculation on a set of rows and return
a single value. The five main ones: COUNT (how many rows), SUM (total),
AVG (average), MIN (smallest), MAX (largest). Always used with GROUP BY
unless summarising the entire table into one row.

**Q: How does GROUP BY work?**

A: Collapses all rows that share the same valuea into one row, so
aggregate functions can be applied per group. The result has one row
per unique combination of grouped columns. Every non-aggregated column
in SELECT must appear in GROUP BY, otherwise SQL doesn't know which
value to show for the collapsed rows.

**Q: What is the difference between WHERE and HAVING?**

A: WHERE filters individual rows before GROUP BY runs, no aggregates
allowed because they don't exist yet. HAVING filters groups after
GROUP BY runs and aggregates are fully available here. Rule: if the
filter condition involves COUNT, SUM, AVG, MIN, or MAX, it goes in
HAVING. Everything else goes in WHERE.

**Q: What is the difference between COUNT(*) and COUNT(column)?**

A: COUNT(*) counts all rows including NULLs. COUNT(column) counts
only rows where that column is not NULL. Example: if a salary column
has 3 NULLs in a 10-row table, COUNT(*) returns 10 but COUNT(salary)
returns 7. Use COUNT(*) for total row counts, COUNT(column) when NULLs
should be excluded from the count.

**Q: Can you use aggregate functions in a WHERE clause?**

A: No. WHERE runs before GROUP BY, so aggregates don't exist yet at
that stage. Use HAVING instead. WHERE COUNT(*) > 5 is invalid.
HAVING COUNT(*) > 5 is correct.

## Problems

| # | Problem | Source | Status | Key technique |
| --- | --- | --- | --- | --- |
| 1 | Classes More Than 5 Students | LeetCode | ✅ | GROUP BY + HAVING |
| 2 | Find Followers Count | LeetCode | ✅ | COUNT per group |
| 3 | Number of Unique Subjects per Teacher | LeetCode | ✅ | COUNT(DISTINCT col) |
| 4 | User Activity for the Past 30 Days | LeetCode | ✅ | DATE_SUB + COUNT(DISTINCT) |
| 5 | Percentage of Users Attended a Contest | LeetCode | ✅ | Scalar subquery, percentage pattern |
| 6 | Queries Quality and Percentage | LeetCode | ✅ | AVG(expression), SUM(boolean) |
| 7 | Histogram of Tweets | DataLemur | ✅ | Two-level aggregation, subquery in FROM |
| 8 | Average Review Ratings | DataLemur | ✅ | DATE_TRUNC, multi-column GROUP BY |
| 9 | Laptop vs Mobile Viewership | DataLemur | ✅ | Pivot, CASE WHEN in SUM |
| 10 | Teams Power Users | DataLemur | ✅ | EXTRACT, ORDER BY + LIMIT |
