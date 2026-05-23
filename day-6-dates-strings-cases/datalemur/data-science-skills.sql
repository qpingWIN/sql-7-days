-- ============================================================
-- Problem:    Data Science Skills
-- Source:     DataLemur - https://datalemur.com/questions/matching-skills
-- Difficulty: Easy
-- Day:        6
-- Date:       23/05/2026
-- ============================================================

/*
PROBLEM STATEMENT
-----------------
Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

Assumption:

There are no duplicates in the candidates table.
candidates Table:
Column Name	Type
candidate_id	integer
skill	varchar
candidates Example Input:
candidate_id	skill
123	Python
123	Tableau
123	PostgreSQL
234	R
234	PowerBI
234	SQL Server
345	Python
345	Tableau
Example Output:
candidate_id
123
Explanation
Candidate 123 is displayed because they have Python, Tableau, and PostgreSQL skills. 345 isn't included in the output because they're missing one of the required skills: PostgreSQL.
*/

-- ============================================================
-- MY SOLUTION
-- ============================================================

SELECT candidate_id
FROM candidates
where skill IN ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(skill) = 3
order by candidate_id

--OR THIS--

WITH tmp AS(SELECT candidate_id, SUM(CASE 
                                  WHEN skill='Python' or skill='Tableau' or skill='PostgreSQL'
                                  THEN 1 ELSE 0 END) as summa
            FROM candidates
            GROUP BY candidate_id
)
SELECT candidate_id
FROM tmp
WHERE summa=3
ORDER BY candidate_id

-- ============================================================
-- THOUGHT PROCESS
-- ============================================================
/*
Need candidates with all three specific skills out of a long-format table (one row per candidate-skill pair)
WHERE skill IN (...) narrows to only the relevant rows, anything else is noise.
GROUP BY candidate_id collapses to one row per candidate.
HAVING COUNT(skill) = 3 keeps only those who hit all three of the filtered values.
ORDER BY candidate_id because DataLemur expects sorted output.
*/

-- ============================================================
-- WHAT I LEARNED
-- ============================================================
/*
The "has all of N values" pattern:

  WHERE col IN (list of N values)
  GROUP BY entity
  HAVING COUNT(DISTINCT col) = N

WHERE IN (...) is just multiple ORs in disguise. cleaner to read, identical performance, and works the same in HAVING too.
COUNT(col) vs COUNT(DISTINCT col): equivalent only when the column is unique within each group. DISTINCT is the safe default
as it costs nothing to write, prevents a silent correctness bug when the assumption breaks.
| ≠ OR in SQL because | is bitwise, OR is logical. 
*/
