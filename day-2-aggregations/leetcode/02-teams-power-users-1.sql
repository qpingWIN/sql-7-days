-- ============================================================
-- Problem:    Teams Power Users
-- Source:     DataLemur — https://datalemur.com/questions/teams-power-users
-- Difficulty: Easy
-- Day:        2
-- Date:       28/04/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.

Assumption:

No two users have sent the same number of messages in August 2022.
messages Table:
Column Name	Type
message_id	integer
sender_id	integer
receiver_id	integer
content	varchar
sent_date	datetime
messages Example Input:
message_id	sender_id	receiver_id	content	sent_date
901	3601	4500	You up?	08/03/2022 00:00:00
902	4500	3601	Only if you're buying	08/03/2022 00:00:00
743	3601	8752	Let's take this offline	06/14/2022 00:00:00
922	3601	4500	Get on the call	08/10/2022 00:00:00
Example Output:
sender_id	message_count
3601	2
4500	1
The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT sender_id, count(message_id) AS message_count
FROM messages
WHERE sent_date >= '2022-08-01' AND sent_date < '2022-09-01'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
What does one row in my output represent?
One sender so GROUP BY sender_id.

What am I calculating per group?
How many messages each sender sent, COUNT(message_id).

Date filter: problem specifies August 2022 only. Two conditions
needed YEAR(sent_date) = 2022 AND MONTH(sent_date) = 8.
Both go in WHERE because they filter raw rows before grouping.

Top 2 senders: problem asks for the highest senders, not all.
Sort by message_count DESC first to put highest at the top,
then LIMIT 2 to cap the result.
No HAVING needed, the LIMIT handles the "top N" restriction,
not a group-level filter.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Top N pattern:
  ORDER BY metric DESC
  LIMIT n
Always in that order. Sort descending first, cap second.
LIMIT without ORDER BY gives arbitrary rows, not the top ones.

MONTH(date) extracts the month as an integer (1-12).
YEAR(date) extracts the year.

YEAR()/MONTH() are used in MySQL only.
EXTRACT(YEAR FROM col) / EXTRACT(MONTH FROM col) is the PostgreSQL/ANSI standard.
Date range (>= start AND < end) is most performant.
*/
