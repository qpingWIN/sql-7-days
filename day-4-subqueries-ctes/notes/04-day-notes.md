# Day 4 — Subqueries, CTEs & Set Operations

**Date:** 05/05/2025
**Hours spent:10**
**Problems solved:** 11

## What I studied

- Subqueries in SELECT, FROM, WHERE — shapes and rules for each position
- Correlated vs uncorrelated subqueries
- EXISTS and SELECT 1 idiom
- CTEs — syntax, chaining, when to use over subqueries
- Recursive CTEs — anchor + recursive member pattern
- Set operations — UNION, UNION ALL, INTERSECT, EXCEPT
- Window functions intro — DENSE_RANK, PARTITION BY, top-N-per-group pattern

## Key insights

- The outer query iterates one row at a time — `e.departmentId` inside a subquery means "the departmentId of the row currently being examined", not "the column in the abstract". That's what makes correlation work
- GROUP BY organizes rows into buckets but doesn't delete them — aggregates run inside the bucket first, then output collapses to one row per group
- Zero rows ≠ NULL. A scalar subquery returning no rows evaluates to NULL automatically — use this to handle edge cases
- CTEs don't add new capability — they're a readability upgrade. Same execution as derived tables, but named and linear
- Window functions run after GROUP BY, so they can reference aggregates like SUM(...) inside OVER(...)
- UNION ALL is the default choice — UNION does extra deduplication work you usually don't need

## Gotchas I hit

- `LIMIT 1 OFFSET N-1`: MySQL rejects expressions in OFFSET; must DECLARE a variable and SET it first
- Integer division silently truncates in MySQL — multiply by `1.00` or `100.0` to force floating point
- `ORDER BY spend` inside a window function after GROUP BY — raw column no longer in scope, must use `SUM(spend)`
- Re-joining a table in the outer query that the CTE already joined — redundant and can cause row multiplication

## Theory Q&A

**Q: What is a subquery and what types exist?**

A subquery is a SELECT nested inside another query. Three positions: SELECT (must return scalar), FROM (returns a table, must have alias), WHERE (scalar with =/<, or list with IN). Two execution types: uncorrelated (runs once, no outer reference) and correlated (re-runs per outer row, references outer columns).

**Q: What is a CTE and how does it differ from a subquery?**

Same execution, different syntax. CTEs are defined before the main query with WITH, given a name, and referenced like a table. Subqueries are inline and nested. CTEs win on readability for multi-step logic and can be chained — later CTEs can reference earlier ones.

**Q: When would you use EXISTS vs IN?**

EXISTS takes a subquery and returns true if any rows come back — it stops at the first match and ignores the actual values returned (hence `SELECT 1` convention). IN evaluates every value in the list. Use EXISTS for large subquery results; IN for small static lists. EXISTS also handles NULLs more safely than NOT IN.

**Q: What is the difference between UNION and UNION ALL?**

UNION deduplicates the combined result — slower. UNION ALL keeps all rows including duplicates — faster. Default to UNION ALL unless deduplication is a hard requirement.

**Q: What are INTERSECT and EXCEPT?**

Set operations. INTERSECT returns only rows appearing in both queries. EXCEPT returns rows from the first query not in the second. Not fully supported in older MySQL versions — simulate with NOT EXISTS or LEFT JOIN ... WHERE IS NULL.

**Q: What is a recursive CTE?**

A CTE that references itself. Two parts: an anchor (runs once, starting rows) and a recursive member (references the CTE, runs until it produces zero rows). Used for hierarchical data such as org charts, parent-child relationships, graph traversal.

## Problems

| # | Problem | Source | Status | Key technique |
|---|---|---|---|---|
| 1 | Second Highest Salary | LC #176 | ✅ | LIMIT/OFFSET + scalar subquery null handling |
| 2 | Nth Highest Salary | LC #177 | ✅ | DECLARE/SET for OFFSET expression, function wrapper |
| 3 | Department Highest Salary | LC #184 | ✅ | Correlated subquery in WHERE, derived table JOIN |
| 4 | Monthly Transactions I | LC #1193 | ✅ | Conditional aggregation, DATE_FORMAT |
| 5 | Immediate Food Delivery II | LC #1174 | ✅ | MIN per group + JOIN back, integer division trap |
| 6 | Game Play Analysis IV | LC #550 | ✅ | DATE_ADD INTERVAL, existence check via JOIN |
| 7 | Duplicate Emails | LC #182 | ✅ | GROUP BY + HAVING COUNT > 1 |
| 8 | Supercloud Customer | DataLemur | ✅ | Cardinality match — COUNT DISTINCT per customer vs global |
| 9 | Highest-Grossing Items | DataLemur | ✅ | DENSE_RANK OVER PARTITION BY, top-N-per-group |
| 10 | Signup Activation Rate | DataLemur | ✅ | Ratio with ROUND + 1.00 multiplier |
| 11 | Sending vs Opening Snaps | DataLemur | ✅ | CTE + conditional aggregation + percentage split |