-- 14) 查询每份保险金额第4高保险产品的编号和保险金额。
--     在数字序列8000,8000,7000,7000,6000中，
--     两个8000均为第1高，两个7000均为第2高,6000为第3高。
-- 请用一条SQL语句实现该查询：

SELECT t3.i_id, t3.i_amount
FROM insurance t3
WHERE t3.i_id in (
    SELECT t1.i_id
    FROM insurance t1, (
        SELECT DISTINCT i_amount
        FROM insurance
        ORDER BY i_amount DESC
    ) t2
    WHERE t1.i_amount < t2.i_amount
    GROUP BY t1.i_id
    HAVING COUNT(*) = 3
);









/*  end  of  your code  */ 