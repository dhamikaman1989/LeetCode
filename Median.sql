
# # Write your MySQL query statement below
with recursive c1 as(
         Select num, frequency, 1 lvl
              FROM Numbers
        UNION ALL
     SELECT c1.num, c1.frequency, lvl+1 from c1
             JOIN Numbers n ON n.num = c1.num
                WHERE lvl < c1.frequency    
 ),
orderNumAsc as(
    select num,
    ROW_NUMBER() OVER(ORDER BY num asc) rn_asc
    from c1
),
orderAll as(
    SELECT num, 
    
        abs(
        CAST(rn_asc AS SIGNED) -
        cast(ROW_NUMBER() OVER(ORDER BY rn_asc DESC) 
              AS
              SIGNED) 
            )as diff
    FROM 
        orderNumAsc
)

SELECT round(AVG(num),1) as median FROM orderAll 
            WHERE diff <= 1;