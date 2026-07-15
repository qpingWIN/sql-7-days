-- ============================================================
-- Problem:    Server Utilization Time
-- Source:     DataLemur - https://datalemur.com/questions/total-utilization-time
-- Difficulty: Hard
-- Day:        7
-- Date:       14/07/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
[paste schema and problem text]
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH tmp AS (
    SELECT server_id, status_time AS start_time, session_status,
           LEAD(status_time) OVER (PARTITION BY server_id ORDER BY status_time) AS stop_time
    FROM server_utilization 
)
SELECT ROUND(SUM(TIMESTAMPDIFF(SECOND, start_time, stop_time)) / 86400) AS total_uptime_days
FROM tmp
WHERE session_status = 'start'

--OR THIS--

WITH tbl AS (SELECT server_id, status_time, session_status,
RANK() OVER (PARTITION BY server_id ORDER BY status_time) AS rnk
FROM server_utilization),
tbl2 AS (
SELECT t1.server_id, t1.status_time AS start_time, t2.status_time AS stop_time,
TIMESTAMPDIFF(second, t1.status_time, t2.status_time) AS sess_run
FROM tbl t1
JOIN tbl t2 ON t1.server_id = t2.server_id AND t1.rnk = t2.rnk - 1
WHERE t1.session_status = 'start')
SELECT FLOOR(SUM(sess_run)/86400) AS total_uptime_days
FROM tbl2

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Rows are single events (start/stop), therefore uptime needs pairs -> convert events to intervals.
LEAD(status_time) OVER (PARTITION BY server_id ORDER BY status_time) pulls the next event onto the current row. Since events alternate, each 'start' row now holds its full interval.
CTE needed because window functions can't go in WHERE. Filter to 'start' rows only as stop rows carry junk LEAD values.
SUM(TIMESTAMPDIFF(SECOND, …)) / 86400, then ROUND.

*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
-
*/
