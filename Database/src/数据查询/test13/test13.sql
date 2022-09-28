-- 13) 综合客户表(client)、资产表(property)、理财产品表(finances_product)、
--     保险表(insurance)、基金表(fund)和投资资产表(property)，
--     列出所有客户的编号、名称和总资产，总资产命名为total_property。
--     总资产为储蓄卡余额，投资总额，投资总收益的和，再扣除信用卡透支的金额
--     (信用卡余额即为透支金额)。客户总资产包括被冻结的资产。
--    请用一条SQL语句实现该查询：


SELECT client.c_id, client.c_name, COALESCE(a_amount,0)+COALESCE(b_amount,0)+COALESCE(c_amount, 0)+COALESCE(save_balance, 0)-COALESCE(debt_balance, 0)+COALESCE(total_income,0) AS total_property
FROM client LEFT JOIN(
    SELECT c_id, COALESCE(SUM(f_amount*pro_quantity),0) AS c_amount
    FROM client LEFT JOIN property ON c_id=pro_c_id LEFT JOIN fund ON pro_pif_id=f_id
    WHERE pro_type=3
    GROUP BY c_id
) first ON client.c_id=first.c_id
LEFT JOIN (
    SELECT c_id, COALESCE(SUM(i_amount*pro_quantity), 0) AS b_amount
    FROM client LEFT JOIN property ON c_id=pro_c_id LEFT JOIN insurance ON pro_pif_id=i_id
    WHERE pro_type=2
    GROUP BY c_id
) second ON client.c_id=second.c_id
LEFT JOIN (
    SELECT c_id, COALESCE(SUM(p_amount*pro_quantity), 0) AS a_amount
    FROM client LEFT JOIN property ON c_id=pro_c_id LEFT JOIN finances_product ON pro_pif_id=p_id
    WHERE pro_type=1
    GROUP BY c_id
) third ON client.c_id=third.c_id
LEFT JOIN (
    SELECT c_id, SUM(b_balance) AS save_balance
    FROM client, bank_card
    WHERE c_id=b_c_id AND b_type='储蓄卡'
    GROUP BY c_id
) fourth ON client.c_id=fourth.c_id
LEFT JOIN (
    SELECT c_id, SUM(b_balance) AS debt_balance
    FROM client, bank_card
    WHERE c_id=b_c_id AND b_type='信用卡'
    GROUP BY c_id   
) fifth ON client.c_id=fifth.c_id
LEFT JOIN (
    SELECT c_id, SUM(pro_income) AS total_income
    FROM client, property
    WHERE c_id=pro_c_id
    GROUP BY c_id
) sixth ON client.c_id=sixth.c_id
ORDER BY client.c_id;





/*  end  of  your code  */ 