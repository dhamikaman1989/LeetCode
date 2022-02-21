-- 1285 - Find the Start and End Number of Continuous Ranges

# Write your MySQL query statement below
WITH c1 AS(
        SELECT 
                log_id,
                log_id - ROW_NUMBER() OVER(ORDER BY log_id) as diff
            FROM
        Logs)
 ,
 c2 AS(
    SELECT 
        MIN(log_id) start_id,
        MAX(log_id) end_id
        FROM c1
     GROUP BY diff
 )
 
 SELECT * FROM c2;   