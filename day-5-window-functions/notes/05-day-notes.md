# Day 5 - Window Functions

**Date:** 20 May 2026
**Hours spent:** 20
**Problems solved:** 14

## What I studied

- `OVER()` clause — turns any aggregate into a window function; computes across a row set without collapsing rows
- `PARTITION BY` — splits rows into independent groups for the window function (like `GROUP BY` but rows are preserved)
- `ORDER BY` inside `OVER()` — defines row sequence within each partition; required for ranking, LAG/LEAD, and running totals
- Ranking functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE(n)`
- Offset functions: `LAG(col, n)`, `LEAD(col, n)` — access previous/next row values
- Positional functions: `FIRST_VALUE()`, `LAST_VALUE()` (the latter has a frame trap — see Gotchas)
- Aggregates as windows: `SUM() / AVG() / COUNT() OVER (...)` for running totals and moving averages
- Frame clauses: `ROWS BETWEEN n PRECEDING AND CURRENT ROW(AND n FOLLOWING)` vs `RANGE BETWEEN ...` — physical row count vs logical value range

## Key insights

- Window functions run AFTER `WHERE` and `GROUP BY` but BEFORE `ORDER BY` / `LIMIT` — so you can't filter on a window result in the same `WHERE`. Wrap in a subquery / CTE and filter outside.
- Default frame when `ORDER BY` is present is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` — this bites you with `LAST_VALUE` (returns current row, not partition end). Fix: explicit `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.
- "Top-N per group" is the canonical window pattern: `DENSE_RANK() OVER (PARTITION BY group ORDER BY metric DESC)` then filter `rnk <= N` in outer query.
- Consecutive-rows problems collapse to LAG/LEAD comparisons — turn "3 in a row" into "row equals LAG(1) equals LAG(2)".
- Date-difference tricks: `date - ROW_NUMBER() OVER (ORDER BY date)` creates a constant for consecutive dates → groupable as "islands."
- Rolling average over N days: `AVG(x) OVER (ORDER BY date ROWS BETWEEN N-1 PRECEDING AND CURRENT ROW)`.

## Gotchas I hit

- Used `RANK()` for "top 3 salaries" and missed people on ties → switched to `DENSE_RANK()` (problem wants distinct salary values, not row positions).
- Tried `WHERE rnk = 1` directly with the window function in the same query — failed. Had to push it into a subquery.
- `LAST_VALUE()` returned the current row instead of the partition's last row because I forgot the frame clause.
- Exchange Seats: tried to swap with self-join, much cleaner with `CASE` + `LEAD`/`LAG` keyed on odd/even id and the boundary case when total count is odd.
- Human Traffic of Stadium: tried LAG/LEAD chains for "3 consecutive high-traffic days" — got tangled. Cleaner solution: `id - ROW_NUMBER()` to find islands, then filter groups of size ≥ 3.
- `COUNT(DISTINCT x) OVER (...)` isn't supported in MySQL — had to work around with subqueries.
- Forgot `PARTITION BY` once and got a global ranking instead of per-group → debugged for 10 minutes.

## Theory Q&A

**Q:** Window functions vs aggregate functions — what's the difference?

A: Aggregates collapse rows into one per group; window functions compute across a row set but preserve every row. `SELECT dept, AVG(salary) FROM emp GROUP BY dept` returns one row per dept. `SELECT name, dept, AVG(salary) OVER (PARTITION BY dept) FROM emp` returns every employee alongside their dept average.

**Q:** Difference between `ROW_NUMBER`, `RANK`, `DENSE_RANK`?

A: For scores 100, 100, 90 — `ROW_NUMBER` gives 1,2,3 (always unique, ties broken arbitrarily). `RANK` gives 1,1,3 (gap after tie). `DENSE_RANK` gives 1,1,2 (no gap). Use `ROW_NUMBER` when you need exactly one row per group, `DENSE_RANK` for "top N distinct values."

**Q:** What does `PARTITION BY` do?

A: Splits rows into independent groups; the window function resets at each partition boundary. Acts like `GROUP BY` but doesn't collapse rows. `RANK() OVER (PARTITION BY department ORDER BY salary DESC)` ranks each department's employees independently.

**Q:** What are `LAG` and `LEAD` for?

A: `LAG(col, n)` returns the value n rows before the current row; `LEAD(col, n)` returns n rows after. Used for neighbor comparisons — month-over-month change, gaps between events, detecting consecutive runs. `LAG(revenue, 1) OVER (ORDER BY month)` puts last month's revenue on the current row.

**Q:** How do you compute a running total?

A: `SUM(amount) OVER (ORDER BY date)` — the `ORDER BY` defines accumulation order, and the default frame (`UNBOUNDED PRECEDING` to `CURRENT ROW`) gives the cumulative sum. Add `PARTITION BY user_id` for per-user running totals.

## Problems

| # | Problem | Source | Status | Key technique |
| --- | --- | --- | --- | --- |
| 178 | Rank Scores | LeetCode | ✅ | `DENSE_RANK() OVER (ORDER BY score DESC)` |
| 185 | Department Top Three Salaries | LeetCode | ✅ | `DENSE_RANK() PARTITION BY dept` + filter `<= 3` |
| 180 | Consecutive Numbers | LeetCode | ✅ | `LAG(num,1)` and `LAG(num,2)` equality check |
| 626 | Exchange Seats | LeetCode | ✅ | `CASE` on `id % 2` + `LEAD`/`LAG`; handle odd last row |
| 1321 | Restaurant Growth | LeetCode | ✅ | 7-day moving avg via `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` |
| 601 | Human Traffic of Stadium | LeetCode | ✅ | `id - ROW_NUMBER()` islands trick, filter groups ≥ 3 |
| 1341 | Movie Rating | LeetCode | ✅ | Two `UNION ALL` subqueries, each with `ORDER BY ... LIMIT 1` |
| 602 | Friend Requests II | LeetCode | ✅ | `UNION ALL` both sides, `COUNT` + `DENSE_RANK` |
| – | User's Third Transaction | DataLemur | ✅ | `ROW_NUMBER() PARTITION BY user ORDER BY date`, filter `= 3` |
| – | Tweets' Rolling Averages | DataLemur | ✅ | 3-day `AVG` with `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` |
| – | Histogram of Users and Purchases | DataLemur | ✅ | `RANK() PARTITION BY user_id ORDER BY date DESC` |
| – | Odd and Even Measurements | DataLemur | ✅ | `ROW_NUMBER() PARTITION BY DATE(time) ORDER BY time`, split by parity |
| – | Card Launch Success | DataLemur | ✅ | `ROW_NUMBER() PARTITION BY card_name ORDER BY date`, filter first month |
| – | Active User Retention | DataLemur | ✅ | Self-join on month offset + `COUNT DISTINCT` |