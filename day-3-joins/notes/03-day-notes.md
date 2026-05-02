# Day 3 — JOINs: Combining Tables

**Date:** 2026-05-02
**Hours spent:** 
**Problems solved:** 11

## What I studied

- Every join type as a Venn-diagram question: which unmatched rows do I keep?
- INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS joins - syntax and semantics
- Multi-condition `ON` clauses (equality + range) - non-equi-joins
- Joining the same table twice (self-join) and the same dimension twice (manager/employee, caller/receiver)
- Anti-join pattern (3 idioms: LEFT JOIN + IS NULL, NOT EXISTS, NOT IN)
- GROUP BY mechanics: bucketing rows, aggregating within buckets, multi-column grouping
- Conditional aggregation via `SUM(CASE WHEN ... THEN 1 ELSE 0 END)`
- Clause order (lexical vs. logical execution)
- WHERE vs HAVING distinction
- Fact vs. dimension tables

## Key insights

- **Trigger words → join type.** "All / every / even if no" → LEFT JOIN. "Never / without / missing" - anti-join. "Compare row to related row in same table" - SELF JOIN.
- **The `ON` clause assigns roles, not the FROM order.** For INNER JOIN, table order is decorative; for LEFT/RIGHT, load-bearing.
- **Default to INNER JOIN.** Reach for LEFT only with a specific reason (anti-join, "include all X even without Y").
- **`COUNT(*)` ≠ `COUNT(column)`.** The first counts rows; the second ignores NULLs. Different answers when NULLs are present.
- **Conditional aggregation pivots filtered counts into one row** — single pass, no joins needed for "count A vs count B in same table."
- **Lexical order ≠ execution order.** SQL evaluates `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`. That's why aliases work in SELECT, and why SELECT aliases can't be used in WHERE (WHERE runs first).
- **Role-named aliases prevent confusion.** `today`/`yesterday` is far less error-prone than `w1`/`w2`.
- **For percentages: multiply by `100.0` not `100`** to force float math. INNER JOIN keeps the denominator honest.

## Gotchas I hit

- Reflexive `LEFT JOIN` when `INNER JOIN` was cleaner.
- Wrote `WHERE` after `GROUP BY` (syntax error). Clause order is fixed.
- `COUNT(t.column)` returned 0 after `WHERE t.column IS NULL` - column counts ignore NULLs. Use `COUNT(*)`.
- Reached for `AVG(price)` instead of `SUM(price*units)/SUM(units)` for "average selling price."
- Combined two date-arithmetic syntaxes (`d + DATE_ADD(...)`) - picked alternatives, used both. Always pick one.
- `INTERVAL 1` without unit - must be `INTERVAL 1 DAY`.
- Mixed up which side of LEFT JOIN gets NULL-padded (right side, always).
- `DATEDIFF(a-b)` instead of `DATEDIFF(a, b)` - function takes two args separated by comma.
- Used `LEFT JOIN` for percentage problem - silently classifies "unknown" as "not-international" distorting the metric.

## Theory Q&A

**Q: What are the different types of SQL JOINs?**

A: Six types, each defined by which unmatched rows are kept:
- **INNER JOIN** — only rows matching in both tables (the overlap)
- **LEFT JOIN** — all rows from left, padded with NULL where right doesn't match
- **RIGHT JOIN** — mirror of LEFT (rarely used; rewrite as LEFT for readability)
- **FULL OUTER JOIN** — all rows from both, NULL-padded where unmatched (not natively supported in MySQL)
- **SELF JOIN** — any join where a table joins itself via two aliases (not a separate type, an idiom)
- **CROSS JOIN** — every row of A paired with every row of B; no `ON` clause; m × n rows (Cartesian product)

**Q: What is a SELF JOIN and when would you use it?**

A: A self join joins a table to itself using two aliases. Used for comparing rows within the same table — hierarchies (employee → manager), sequential comparisons (today vs. yesterday), pair finding, or two roles for the same dimension. Example:
```sql
SELECT e.name AS employee, m.name AS manager 
FROM employees e 
JOIN employees m ON e.manager_id = m.id;
```
The mental shift: stopped thinking of `employees` as one table and started thinking of it as two virtual copies (`e` and `m`) playing different roles.

**Q: What is a CROSS JOIN?**

A: Returns every combination of rows from both tables (Cartesian product). If A has 3 rows and B has 4, the result has 12 rows. No `ON` clause. Use cases: generating all possible pairings (all size × color combinations for a product catalog), gluing single-row subqueries into one wide row (e.g., two `COUNT(*)` results side by side). Trap: accidental CROSS JOIN via comma syntax (`FROM a, b` without `WHERE`) can explode row counts.

**Q: What's the difference between JOIN and UNION?**

A: JOIN combines **columns horizontally** based on a condition — the two tables can have completely different column sets. UNION combines **rows vertically** by stacking results from two queries — both queries must return the same number of columns with compatible types in the same order. `UNION` removes duplicates (slower, sorts under the hood); `UNION ALL` keeps them (faster). Default to `UNION ALL` unless dedup is needed.

**Q: WHERE vs HAVING?**

A: WHERE filters **rows before grouping**; HAVING filters **groups after grouping**. WHERE works on column values, HAVING works on aggregates. They can both be used in the same query.

**Q: What's a non-equi-join?**

A: A join with a condition that isn't pure equality i.e. uses `BETWEEN`, `<`, `>`, `<=`, `>=`. Same syntax as regular joins (`ON ... AND ...`), just different semantics. Common for date-range matching. Performance worse than equi-joins (no hash join possible).

**Q: Three anti-join idioms?**

A: 
1. `LEFT JOIN ... WHERE right.col IS NULL` — visual, NULL-safe
2. `NOT EXISTS (correlated subquery)` — NULL-safe, often fastest
3. `NOT IN (subquery)` — readable but **silently wrong if subquery contains NULLs** (returns zero rows). Avoid unless you've verified no NULLs.



## UNION reference

### Rules
1. Same column count in both queries.
2. Compatible types in matching positions (column 1 stacks on column 1, etc.).
3. Output column names come from the **first** query.
4. `ORDER BY` only at the end — applies to the combined result.
5. `UNION` deduplicates; `UNION ALL` keeps duplicates.

### Performance
- `UNION` runs an implicit dedup pass (sort/hash) → slower.
- `UNION ALL` just concatenates → faster.
- **Default to `UNION ALL`** unless dedup is genuinely needed.

### When to use
- Combining parallel sources (`employees_us` + `employees_eu`).
- Simulating `FULL OUTER JOIN` in MySQL (`LEFT JOIN ... UNION ... RIGHT JOIN ...`) — use plain `UNION` to dedup matched rows.
- Building labeled feeds from multiple tables (add a literal `'order'` / `'review'` column to mark origin).
- Unpivoting a wide table into a tall format.

### Traps
- `UNION` instead of `UNION ALL` → silent slowdown, may lose legitimate duplicates.
- Mismatched column **order** (same types, wrong meaning) → no error, garbage output.
- `ORDER BY` placed in subqueries → ignored or errors depending on dialect.
- Confusing UNION with JOIN — different shapes entirely.

## Problems

| # | Problem | Source | Status | Key technique |
| --- | --- | --- | --- | --- |
| 1 | Combine Two Tables | LC 175 | ✅ | LEFT JOIN to preserve unmatched |
| 2 | Employees Earning More Than Their Managers | LC 181 | ✅ | Self-join, two aliases for two roles |
| 3 | Customers Who Never Order | LC 183 | ✅ | Anti-join (LEFT JOIN + IS NULL); also NOT EXISTS |
| 4 | Customer Who Visited Without Transactions | LC 1581 | ✅ | Anti-join + GROUP BY + COUNT(*) |
| 5 | Rising Temperature | LC 197 | ✅ | Self-join with date offset (`DATEDIFF` or `DATE_ADD`) |
| 6 | Product Sales Analysis I | LC 1068 | ✅ | Lookup join (fact → dimension) |
| 7 | Average Selling Price | LC 1251 | ✅ | Non-equi-join (`BETWEEN`) + weighted average |
| 8 | Cities With Completed Trades | DataLemur | ✅ | Join + WHERE + GROUP BY + ORDER BY + LIMIT |
| 9 | Laptop vs Mobile Viewership | DataLemur | ✅ | Conditional aggregation (no join needed) |
| 10 | Second Day Confirmation | DataLemur | ✅ | Join + date offset filter in WHERE |
| 11 | International Call Percentage | DataLemur | ✅ | Join same dimension twice + conditional aggregation for % |