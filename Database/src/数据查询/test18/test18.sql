 -- 18) 查询至少有一张信用卡余额超过5000元的客户编号，以及该客户持有的信用卡总余额，总余额命名为credit_card_amount。
--    请用一条SQL语句实现该查询：

SELECT t4.c_id AS b_c_id, SUM(t5.b_balance) AS credit_card_amount
FROM client t4, bank_card t5
WHERE t4.c_id=t5.b_c_id AND t5.b_type='信用卡' AND t4.c_id in (
    SELECT t3.c_id
    FROM client t3
    WHERE EXISTS (
        SELECT *
        FROM client t1, bank_card t2
        WHERE t1.c_id=t2.b_c_id AND t2.b_type='信用卡' AND t2.b_balance>5000 AND t3.c_id=t1.c_id
    )
)
GROUP BY t4.c_id
ORDER BY t4.c_id






/*  end  of  your code  */


 