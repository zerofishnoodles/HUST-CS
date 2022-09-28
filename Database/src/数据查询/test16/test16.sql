-- 16) 查询持有相同基金组合的客户对，如编号为A的客户持有的基金，编号为B的客户也持有，反过来，编号为B的客户持有的基金，编号为A的客户也持有，则(A,B)即为持有相同基金组合的二元组，请列出这样的客户对。为避免过多的重复，如果(1,2)为满足条件的元组，则不必显示(2,1)，即只显示编号小者在前的那一对，这一组客户编号分别命名为c_id1,c_id2。

-- 请用一条SQL语句实现该查询：

SELECT t1.pro_c_id AS c_id1, t2.pro_c_id AS c_id2
FROM (
    SELECT pro_c_id, array_to_string(ARRAY(SELECT DISTINCT unnest(array_agg(pro_pif_id order by pro_pif_id))), ',') AS fund
    FROM property
    WHERE pro_type=3
    GROUP BY pro_c_id
) t1, (
    SELECT pro_c_id, array_to_string(ARRAY(SELECT DISTINCT unnest(array_agg(pro_pif_id order by pro_pif_id))), ',') AS fund
    FROM property
    WHERE pro_type=3
    GROUP BY pro_c_id  
) t2
WHERE t1.pro_c_id<t2.pro_c_id AND t1.fund=t2.fund







/*  end  of  your code  */