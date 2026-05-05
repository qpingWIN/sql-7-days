# SQL in 7 Days

A 7-day sprint to get interview-ready on SQL for data science roles.
Each problem is solved with full reasoning — not just the query, but the thought process, edge cases considered, and what I learned.

## Progress

| Day | Topic | Problems | Status |
| --- | --- | --- | --- |
| 1 | SELECT, filtering, sorting | 8 / 8 | ✅ Complete |
| 2 | Aggregations, GROUP BY, HAVING | 10 / 10 | ✅ Complete |
| 3 | JOINs | 11 / 11 | ✅ Complete |
| 4 | Subqueries, CTEs, set operations | 11 / 11 | ✅ Complete |
| 5 | Window functions | 0 / 14 | ⬜ Not started |
| 6 | Dates, strings, CASE, NULL handling | 0 / 9 | ⬜ Not started |
| 7 | DB design, indexes, transactions, optimization | 0 / 5 | ⬜ Not started |

## Structure

Each day has its own folder containing:

* `leetcode/` — LeetCode solutions
* `datalemur/` — DataLemur solutions
* `notes/` — daily write-up: concepts studied, key insights, gotchas, theory Q&A

## Key concepts so far

**Three-valued logic** — SQL has TRUE, FALSE, and UNKNOWN. Any comparison with NULL returns UNKNOWN, and WHERE only keeps TRUE rows. This means `WHERE col != 2` silently drops rows where col is NULL. Always ask: can this column be NULL?

**NULL-safe negative filter** — `WHERE col != value OR col IS NULL`. The pattern that fixes the NULL trap on negative conditions.

**NOT IN danger** — if the subquery contains any NULL, NOT IN returns zero rows for the entire query. Always add `WHERE col IS NOT NULL` to subqueries used with NOT IN.

**Logical execution order** — FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT. Explains why SELECT aliases work in ORDER BY but not in WHERE.

**Joins as Venn diagrams** — every join type just specifies which unmatched rows to keep. INNER keeps only the overlap; LEFT keeps the left side's unmatched rows (NULL-padded on the right); FULL OUTER keeps both. Default to INNER; reach for LEFT only with a specific reason.

**Anti-join pattern** — "find rows in A with no match in B." Three idioms: `LEFT JOIN ... WHERE right.col IS NULL`, `NOT EXISTS (correlated subquery)`, and `NOT IN` (avoid — silently breaks on NULLs). Trigger words: *never, without, missing*.

**Self-join** — joining a table to itself with two aliases to compare rows within the same table. Use for hierarchies (employee/manager), sequential comparisons (today vs. yesterday), or when one fact row needs the same dimension twice (caller/receiver country lookups).

**Conditional aggregation** — `SUM(CASE WHEN cond THEN 1 ELSE 0 END)` counts rows matching a condition. Multiple in one SELECT pivots filtered counts into a single wide row, single pass over the table. The right tool when you need multiple counts of the same table with different filters — joins are over-engineering for this shape.

**WHERE vs HAVING** — WHERE filters individual rows *before* grouping; HAVING filters groups *after* grouping. WHERE works on column values, HAVING works on aggregates. Both can coexist in one query.

**Sargability** — wrapping a column in a function inside ON/WHERE prevents the database from using an index on that column. Prefer `date_col = DATE_ADD(other, INTERVAL 1 DAY)` (column naked on one side) over `DATEDIFF(date_col, other) = 1` (column wrapped in function).

**Float math for percentages** — multiply by `100.0` not `100` to force float arithmetic and avoid integer-division truncation. Pair with INNER JOIN to keep the denominator honest (LEFT JOIN can dilute percentages with unclassifiable rows).

**Correlated subqueries** — the outer query iterates one row at a time. `e.departmentId` inside an inner query means "the value for the row currently being examined", not the column in the abstract. Cover the outer query: if the inner query can't run alone, it's correlated.

**GROUP BY buckets, not collapses** — GROUP BY organizes rows into buckets but doesn't delete them. Aggregates run inside each bucket first, then output collapses to one row per group. Every SELECT column must be in GROUP BY or wrapped in an aggregate.

**Zero rows ≠ NULL** — a scalar subquery returning no rows evaluates to NULL automatically. Use this to handle missing-answer edge cases.

**CTEs are a readability upgrade** — `WITH name AS (SELECT ...)` lifts subqueries out of nesting and gives them names. Same execution as derived tables, but linear and readable. Chain multiple CTEs with commas.

**Top-N-per-group template** — `DENSE_RANK() OVER (PARTITION BY group ORDER BY metric DESC)` ranks within partitions without collapsing rows.
Wrap in a subquery, filter `WHERE rnk <= N` outside.

**Integer division truncates** — `1 / 3` = `0` in MySQL. Multiply by `1.00` or `100.0` to force floating point on percentage calculations.

**Conditional aggregation** — `SUM(CASE WHEN condition THEN value ELSE 0 END)` computes filtered aggregates within a GROUP BY bucket without affecting other aggregates on the same rows.

## Credit

Roadmap structure based on Veeraj Kantilal Gadda's 7-day SQL sprint post.