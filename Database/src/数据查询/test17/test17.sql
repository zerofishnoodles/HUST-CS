-- 17 查询2022年2月购买基金的高峰期。至少连续三个交易日，所有投资者购买基金的总金额超过100万(含)，则称这段连续交易日为投资者购买基金的高峰期。只有交易日才能购买基金,但不能保证每个交易日都有投资者购买基金。2022年春节假期之后的第1个交易日为2月7日,周六和周日是非交易日，其余均为交易日。请列出高峰时段的日期和当日基金的总购买金额，按日期顺序排序。总购买金额命名为total_amount。
--    请用一条SQL语句实现该查询:

SELECT t4.pro_purchase_time, t4.amount
FROM (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
)t4
WHERE t4.pro_purchase_time in (
SELECT t1.pro_purchase_time
FROM (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
) t1, (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
) t2, (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
)t3
WHERE t1.rank+1=t2.rank AND t2.rank+1=t3.rank AND t1.amount>1000000 AND t2.amount>1000000 AND t3.amount>1000000    
) or t4.pro_purchase_time in (
    SELECT t2.pro_purchase_time
FROM (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
) t1, (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
) t2, (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
)t3
WHERE t1.rank+1=t2.rank AND t2.rank+1=t3.rank AND t1.amount>1000000 AND t2.amount>1000000 AND t3.amount>1000000
) or t4.pro_purchase_time in (
   SELECT t3.pro_purchase_time
FROM (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
) t1, (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
) t2, (
    SELECT t1.pro_purchase_time, SUM(t2.f_amount*t1.pro_quantity) AS amount, row_number() over(order by t1.pro_purchase_time) as rank
    FROM property t1, fund t2
    WHERE t1.pro_type=3 AND t1.pro_pif_id=t2.f_id AND extract('year' from t1.pro_purchase_time)=2022 AND extract('month' from t1.pro_purchase_time)=2
    GROUP BY t1.pro_purchase_time
    ORDER BY t1.pro_purchase_time
)t3
WHERE t1.rank+1=t2.rank AND t2.rank+1=t3.rank AND t1.amount>1000000 AND t2.amount>1000000 AND t3.amount>1000000 
)








/*  end  of  your code  */