-- ============================================================
-- Problem:    International Call Percentage
-- Source:     DataLemur - https://datalemur.com/questions/international-call-percentage
-- Difficulty: Medium
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:

The caller_id in phone_info table refers to both the caller and receiver.
phone_calls Table:
Column Name	Type
caller_id	integer
receiver_id	integer
call_time	timestamp
phone_calls Example Input:
caller_id	receiver_id	call_time
1	2	2022-07-04 10:13:49
1	5	2022-08-21 23:54:56
5	1	2022-05-13 17:24:06
5	6	2022-03-18 12:11:49
phone_info Table:
Column Name	Type
caller_id	integer
country_id	integer
network	integer
phone_number	string
phone_info Example Input:
caller_id	country_id	network	phone_number
1	US	Verizon	+1-212-897-1964
2	US	Verizon	+1-703-346-9529
3	US	Verizon	+1-650-828-4774
4	US	Verizon	+1-415-224-6663
5	IN	Vodafone	+91 7503-907302
6	IN	Vodafone	+91 2287-664895
Example Output:
international_calls_pct
50.0
Explanation
There is a total of 4 calls with 2 of them being international calls (from caller_id 1 => receiver_id 5, and caller_id 5 => receiver_id 1). Thus, 2/4 = 50.0%
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT 
  ROUND(100.0*SUM(CASE WHEN caller.country_id != receiver.country_id THEN 1 ELSE 0 END)
  /COUNT(*),1) AS international_call_pct
FROM phone_calls AS calls
JOIN phone_info AS caller ON calls.caller_id = caller.caller_id
JOIN phone_info AS receiver ON calls.receiver_id = receiver.caller_id

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Each call has two phone numbers (caller and receiver), and each needs a country lookup. One fact row needs the same dimension table twice thus join phone_info twice with different aliases (caller, receiver). Same trick as the manager/employee self-join, but on a dimension instead of a fact.
The ON clauses use the matching FK on each side: calls.caller_id = caller.caller_id and calls.receiver_id = receiver.caller_id. Note: phone_info only has one ID column (caller_id) which represents any phone number's info and both callers and receivers reference it.
INNER JOIN, not LEFT becausecalls with missing country info can't be classified as international or domestic, and including them in the denominator distorts the percentage.
Conditional aggregation for the count of international calls: SUM(CASE WHEN caller.country_id != receiver.country_id THEN 1 ELSE 0 END).
Divide by COUNT(*) for the total. Multiply by 100.0 to convert ratio to a percentage and force float arithmetic.
ROUND(..., 1) per the spec.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Joining the same dimension twice is the same mental move as a self-join: two aliases, each playing a different role. Whenever a fact row has multiple FKs into the same dimension (caller/receiver, source/destination, parent/child), this pattern fits.
INNER JOIN keeps percentages honest. LEFT JOIN inflates the denominator with rows we can't classify, dragging the percentage toward 0% for things classified as "not the target" and obscuring how much data is actually missing.
100.0 not 100 when computing percentages thus forces float math, immune to dialect quirks around integer division.
COUNT(*) is safer than COUNT(column) when you want "all rows" as the column version ignores NULLs.

Trap:
Reflexive LEFT JOIN. Always ask: "are unmatched rows useful for what I'm computing?" For percentages especially, unmatched rows in the denominator silently distort the answer.
*/
