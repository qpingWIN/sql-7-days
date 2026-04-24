# SQL in 7 Days

A 7-day sprint to get interview-ready on SQL for data science roles.
Each problem is solved with full reasoning — not just the query, but the thought process, edge cases considered, and what I learned.

## Progress

| Day | Topic | Problems | Status |
| --- | --- | --- | --- |
| 1 | SELECT, filtering, sorting | 8 / 8 | ✅ Complete |
| 2 | Aggregations, GROUP BY, HAVING | 0 / 10 | ⬜ Not started |
| 3 | JOINs | 0 / 11 | ⬜ Not started |
| 4 | Subqueries, CTEs, set operations | 0 / 11 | ⬜ Not started |
| 5 | Window functions | 0 / 14 | ⬜ Not started |
| 6 | Dates, strings, CASE, NULL handling | 0 / 9 | ⬜ Not started |
| 7 | DB design, indexes, transactions, optimization | 0 / 5 | ⬜ Not started |

## Structure

Each day has its own folder containing:

- `leetcode/` — LeetCode solutions
- `datalemur/` — DataLemur solutions
- `notes/` — daily write-up: concepts studied, key insights, gotchas, theory Q&A

## Key concepts so far

**Three-valued logic** — SQL has TRUE, FALSE, and UNKNOWN. Any comparison with NULL returns UNKNOWN, and WHERE only keeps TRUE rows. This means `WHERE col != 2` silently drops rows where col is NULL. Always ask: can this column be NULL?

**NULL-safe negative filter** — `WHERE col != value OR col IS NULL`. The pattern that fixes the NULL trap on negative conditions.

**NOT IN danger** — if the subquery contains any NULL, NOT IN returns zero rows for the entire query. Always add `WHERE col IS NOT NULL` to subqueries used with NOT IN.

**Logical execution order** — FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT. Explains why SELECT aliases work in ORDER BY but not in WHERE.

## Credit

Roadmap structure based on Veeraj Kantilal Gadda's 7-day SQL sprint post.
