-- 15) 查询资产表中客户编号，客户基金投资总收益,基金投资总收益的排名(从高到低排名)。
--     总收益相同时名次亦相同(即并列名次)。总收益命名为total_revenue, 名次命名为rank。
--     第一条SQL语句实现全局名次不连续的排名，
--     第二条SQL语句实现全局名次连续的排名。

-- (1) 基金总收益排名(名次不连续)
SELECT t1.c_id AS pro_c_id, t1.total_revenue, COUNT(t2.c_id)+1 AS rank
FROM (
    SELECT c_id, SUM(pro_income) AS total_revenue
    FROM client, property
    WHERE c_id=pro_c_id AND pro_type=3
    GROUP BY c_id
) t1 LEFT JOIN (
    SELECT c_id, SUM(pro_income) AS total_revenue
    FROM client, property
    WHERE c_id=pro_c_id AND pro_type=3
    GROUP BY c_id   
) t2 ON t1.total_revenue < t2.total_revenue
GROUP BY t1.c_id, t1.total_revenue
ORDER BY rank, t1.c_id;



-- (2) 基金总收益排名(名次连续)
SELECT t1.c_id AS pro_c_id, t1.total_revenue, COUNT(t2.total_revenue)+1 AS rank
FROM (
    SELECT c_id, SUM(pro_income) AS total_revenue
    FROM client, property
    WHERE c_id=pro_c_id AND pro_type=3
    GROUP BY c_id
) t1 LEFT JOIN (
    SELECT DISTINCT SUM(pro_income) AS total_revenue
    FROM client, property
    WHERE c_id=pro_c_id AND pro_type=3
    GROUP BY c_id   
) t2 ON t1.total_revenue < t2.total_revenue
GROUP BY t1.c_id, t1.total_revenue
ORDER BY rank, t1.c_id;

/*  end  of  your code  */