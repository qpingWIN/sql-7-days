-- ============================================================
-- Problem:    Signup Activation Rate
-- Source:     DataLemur - https://datalemur.com/questions/signup-confirmation-rate
-- Difficulty: Medium
-- Day:        4
-- Date:       05/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.

A senior analyst is interested to know the activation rate of specified users in the emails table. Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:

emails table contain the information of user signup details.
texts table contains the users' activation information.
Assumptions:

The analyst is interested in the activation rate of specific users in the emails table, which may not include all users that could potentially be found in the texts table.
For example, user 123 in the emails table may not be in the texts table and vice versa.
Effective April 4th 2023, we added an assumption to the question to provide additional clarity.

emails Table:
Column Name	Type
email_id	integer
user_id	integer
signup_date	datetime
emails Example Input:
email_id	user_id	signup_date
125	7771	06/14/2022 00:00:00
236	6950	07/01/2022 00:00:00
433	1052	07/09/2022 00:00:00
texts Table:
Column Name	Type
text_id	integer
email_id	integer
signup_action	varchar
texts Example Input:
text_id	email_id	signup_action
6878	125	Confirmed
6920	236	Not Confirmed
6994	236	Confirmed
'Confirmed' in signup_action means the user has activated their account and successfully completed the signup process.

Example Output:
confirm_rate
0.67
Explanation:
67% of users have successfully completed their signup and activated their accounts. The remaining 33% have not yet replied to the text to confirm their signup.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

WITH confirmed AS (
    SELECT e.user_id
    FROM emails e
    JOIN texts t ON e.email_id = t.email_id
    WHERE t.signup_action = 'Confirmed'
),
total AS (
    SELECT e.user_id
    FROM emails e
    JOIN texts t ON e.email_id = t.email_id
)
SELECT ROUND(1.00 * COUNT(DISTINCT c.user_id) / COUNT(DISTINCT tt.user_id), 2) AS confirm_rate
FROM total tt
LEFT JOIN confirmed c ON tt.user_id = c.user_id;


--OR THIS--

SELECT ROUND(1.00*COUNT(email_id)/
  (SELECT COUNT(DISTINCT user_id)
   FROM emails
  ),2)
FROM texts
WHERE signup_action ='Confirmed'

--OR THIS--

SELECT 
  ROUND(1.0*COUNT(texts.email_id)
    /COUNT(DISTINCT emails.email_id),2) AS activation_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND texts.signup_action = 'Confirmed'; 
-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Numerator: users who received a text and confirmed. Denominator: all users who received a text
Core calculation: confirmed / total, rounded to 2 decimal places
Joined texts to emails on email_id to link the two populations
Filtered WHERE signup_action = 'Confirmed' for the numerator count
Wrapped in ROUND(1.00 * ... , 2) to avoid integer division and hit the decimal spec
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
CTEs lift subqueries out of nested positions and give them names, making multi-step logic readable top-to-bottom. 
Same execution as a derived table, better readability especially when chaining multiple steps.
Multiple CTEs chain with commas under one WITH. Later CTEs can reference earlier ones.
CTEs aren't faster, modern optimizers treat them identically to subqueries. They're a readability tool, not a performance tool.
CTEs aren't persistent meaning they exist only for the duration of the single query that defines them.
When to use a CTE vs inline subquery: anything multi-step or reused -> CTE. Simple scalar subqueries in WHERE -> fine inline.
*/
