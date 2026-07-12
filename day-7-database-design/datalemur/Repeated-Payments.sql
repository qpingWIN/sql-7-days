-- ============================================================
-- Problem:    Repeated Payments
-- Source:     DataLemur - https://datalemur.com/questions/repeated-payments
-- Difficulty: Hard
-- Day:        7
-- Date:       12/07/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or a retry error that causes a credit card to be charged twice.

Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.

Assumptions:

The first transaction of such payments should not be counted as a repeated payment. This means, if there are two transactions performed by a merchant with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.
transactions Table:
Column Name	Type
transaction_id	integer
merchant_id	integer
credit_card_id	integer
amount	integer
transaction_timestamp	datetime
transactions Example Input:
transaction_id	merchant_id	credit_card_id	amount	transaction_timestamp
1	101	1	100	09/25/2022 12:00:00
2	101	1	100	09/25/2022 12:08:00
3	101	1	100	09/25/2022 12:28:00
4	102	2	300	09/25/2022 12:00:00
6	102	2	400	09/25/2022 14:00:00
Example Output:
payment_count
1
Explanation
Within 10 minutes after Transaction 1, Transaction 2 is conducted at Merchant 1 using the same credit card for the same amount. This is the only instance of repeated payment in the given sample data.

Since Transaction 3 is completed after Transactions 2 and 1, each of which occurs after 20 and 28 minutes, respectively hence it does not meet the repeated payments' conditions. Whereas, Transactions 4 and 6 have different amounts.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================
WITH matched AS (
    SELECT DISTINCT
        t1.transaction_id
    FROM transactions t1
    JOIN transactions t2
        ON  t1.merchant_id     = t2.merchant_id
        AND t1.credit_card_id  = t2.credit_card_id
        AND t1.amount          = t2.amount
        AND t2.transaction_timestamp <= t1.transaction_timestamp
        AND t1.transaction_timestamp - t2.transaction_timestamp <= INTERVAL '10 minutes'
        AND t1.transaction_id <> t2.transaction_id
        AND (t1.transaction_timestamp > t2.transaction_timestamp
             OR t1.transaction_id > t2.transaction_id)
)
SELECT COUNT(*) AS payment_count
FROM matched;

--OR THIS--
WITH lagged AS (
  SELECT transaction_timestamp,
         LAG(transaction_timestamp) OVER (
           PARTITION BY merchant_id, credit_card_id, amount
           ORDER BY transaction_timestamp
         ) AS prev_ts
  FROM transactions
)
SELECT COUNT(*) AS payment_count
FROM lagged
WHERE transaction_timestamp - prev_ts <= INTERVAL '10 minutes';

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Definition: a transaction is a "repeat" if the same (merchant_id,
credit_card_id, amount) occurred EARLIER, within 10 minutes. Count repeats.
Key: pairs are asymmetric — the original doesn't count, only the repeat.

1. Self-join on the identity triple (merchant, card, amount) to find
   candidate pairs.

2. Make the join directional: t2.ts <= t1.ts, so t1 only qualifies via an
   earlier partner. This is what excludes the first payment in a cluster.
   (A symmetric condition like ABS(diff) <= 600 marks both sides of every
   pair and double-counts.)

3. Window: t1.ts - t2.ts <= INTERVAL '10 minutes' — direct interval
   comparison

4. Tiebreak for identical timestamps: t1.ts > t2.ts OR t1.id > t2.id.
   Imposes a total order so exactly one of a same-timestamp pair counts
   as the repeat.

5. DISTINCT on t1.transaction_id: a repeat with multiple earlier matches
   produces multiple join rows — count each repeat once. Dedup here is
   by design (fan-out from the join), not a patch.





   Alternative: LAG(ts) OVER (PARTITION BY merchant,
card, amount ORDER BY ts), count rows where ts - prev_ts <= 10 min.
Direction, dedup, and single-scan come free. Sufficient because timestamps
are ordered — if the immediate predecessor is >10 min back, all earlier
ones are too. Self-join generalizes to non-adjacent relationships,
LAG/LEAD is the tool when the relationship is adjacency.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
-
*/
