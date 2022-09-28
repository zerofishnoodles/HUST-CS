-- 19) 以日历表格式列出2022年2月每周每日基金购买总金额，输出格式如下：
-- week_of_trading Monday Tuesday Wednesday Thursday Friday
--               1
--               2    
--               3
--               4
--   请用一条SQL语句实现该查询：
SELECT
    CASE 
        WHEN t3.week=6 THEN 1
        WHEN t3.week=7 THEN 2
        WHEN t3.week=8 THEN 3
        WHEN t3.week=9 THEN 4
        END AS week_of_trading,
    CASE t3.dow WHEN 1 THEN t3.amount END AS monday,
    CASE t3.dow WHEN 2 THEN t3.amount END AS tuesday,
    CASE t3.dow WHEN 3 THEN t3.amount END AS wendnesday,
    CASE t3.dow WHEN 4 THEN t3.amount END AS thursday,
    CASE t3.dow WHEN 5 THEN t3.amount END AS friday
from (
    SELECT *
    FROM (
        SELECT t1.pro_purchase_time, SUM(t1.pro_quantity*t2.f_amount) AS amount, extract('dow' from t1.pro_purchase_time) AS dow, extract('week' from t1.pro_purchase_time) AS week
        FROM property t1, fund t2
        WHERE t1.pro_pif_id=t2.f_id AND t1.pro_type=3 AND extract('month' from t1.pro_purchase_time)=2 AND extract('year' from t1.pro_purchase_time)=2022
        GROUP BY t1.pro_purchase_time
    ) t4
    ORDER BY week, t4.pro_purchase_time
) t3


        









/*  end  of  your code  */