/*
Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
fail_date is the primary key for this table.
This table contains the days of failed tasks.
 

Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
success_date is the primary key for this table.
This table contains the days of succeeded tasks.
 

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Return the result table ordered by start_date.

The query result format is in the following example.

 

Example 1:

Input: 
Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+
Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+
Output: 
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+
Explanation: 
The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and the system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and the system state was "succeeded".
*/

-- # Write your MySQL query statement below

WITH allDates AS(
            SELECT *
                FROM
                (   
                    SELECT success_date, 'succeeded' flag FROM Succeeded
                        UNION ALL
                    SELECT fail_date, 'failed' flag FROM Failed
                    ORDER BY 1
                )Temp
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
    ),
rankSuccessFail AS(
    SELECT  
            flag,
            success_date,
            DATE_SUB(success_date,
            INTERVAL ROW_NUMBER() OVER(PARTITION BY flag ORDER BY success_date)
            DAY)as diff
            FROM
            allDates 
    )
    
    SELECT flag AS period_state,
            MIN(success_date) AS start_date,
            MAX(success_date) AS end_date
            FROM rankSuccessFail
        GROUP BY flag,diff
        ORDER BY 2;
    