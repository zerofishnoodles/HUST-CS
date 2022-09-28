-- 10) 查询当前总的可用资产收益(被冻结的资产除外)前三名的客户的名称、身份证号及其总收益，按收益降序输出，总收益命名为total_income。不考虑并列排名情形。
--    请用一条SQL语句实现该查询：

SELECT a1.c_name, a1.c_id_card, a1.total_income
FROM (
    SELECT c_id, c_name, c_id_card, SUM(pro_income) AS total_income
    FROM client, property
    WHERE c_id=pro_c_id AND pro_status='可用'
    GROUP BY c_id
) a1
WHERE c_id in (
    SELECT first.c_id
    FROM (
        SELECT c_id, c_name, c_id_card, SUM(pro_income) AS total_income
        FROM client, property
        WHERE c_id=pro_c_id
        GROUP BY c_id

    ) first left join  (
        SELECT c_id, c_name, c_id_card, SUM(pro_income) AS total_income
        FROM client, property
        WHERE c_id=pro_c_id AND pro_status='可用'
        GROUP BY c_id 
    ) second on first.total_income < second.total_income
    GROUP BY first.c_id
    HAVING COUNT(*)<=2
)

ORDER BY a1.total_income DESC;








/*  end  of  your code  */ 