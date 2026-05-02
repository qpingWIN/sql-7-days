-- ============================================================
-- Problem:    Second Day Confirmation
-- Source:     DataLemur - https://datalemur.com/questions/second-day-confirmation
-- Difficulty: Easy
-- Day:        3
-- Date:       02/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account.

Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.

Definition:

action_date refers to the date when users activated their accounts and confirmed their sign-up through text messages.
emails Table:
Column Name	Type
email_id	integer
user_id	integer
signup_date	datetime
emails Example Input:
email_id	user_id	signup_date
125	7771	06/14/2022 00:00:00
433	1052	07/09/2022 00:00:00
texts Table:
Column Name	Type
text_id	integer
email_id	integer
signup_action	string ('Confirmed', 'Not confirmed')
action_date	datetime
texts Example Input:
text_id	email_id	signup_action	action_date
6878	125	Confirmed	06/14/2022 00:00:00
6997	433	Not Confirmed	07/09/2022 00:00:00
7000	433	Confirmed	07/10/2022 00:00:00
Example Output:
user_id
1052
Explanation:
Only User 1052 confirmed their sign-up on the second day.

The dataset you are querying against may have different input & output - this is just an example!
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT DISTINCT emails.user_id
FROM emails
JOIN texts ON emails.email_id = texts.email_id
WHERE texts.action_date = DATE_ADD(emails.signup_date, INTERVAL 1 DAY)
  AND texts.signup_action = 'Confirmed';

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
The signup info lives in emails, the confirmation info lives in texts. Linked by email_id. Need both on the same row thus join.
Two filter conditions: the action must be 'Confirmed' (status filter), and the action_date must be exactly one day after signup_date.
INNER JOIN (default) because users without a matching text aren't relevant, nothing to evaluate.
DISTINCT on user_id to deduplicate in case a user has multiple qualifying confirmations.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
Date-offset filters in WHERE. date1 = DATE_ADD(date2, INTERVAL 1 DAY) expresses "date1 is one day after date2." Same idea as the Rising Temperature ON clause, just used in WHERE here because the relationship isn't the join key but it's an additional filter on already-joined rows.
INTERVAL N UNIT requires the unit. Bare INTERVAL 1 is invalid, must be INTERVAL 1 DAY, INTERVAL 2 MONTH, etc.
I shouldn't combine alternative syntaxes. DATE_ADD(d, INTERVAL 1 DAY) and d + INTERVAL '1 day' are equivalent. I should pick one and not merge them.
DISTINCT for safety with one-to-many joins. When a left-side row could match multiple right-side rows, the same user can appear multiple times in the output. DISTINCT collapses that.
Sargability reminder: the form texts.action_date = DATE_ADD(emails.signup_date, ...) keeps texts.action_date naked on the left therefore indexable. Wrapping it in DATEDIFF would break that.
*/
