
-- 在金融应用场景数据库中，编程实现一个转账操作的存储过程sp_transfer_balance，实现从一个帐户向另一个帐户转账。
-- 请补充代码完成该过程：
create procedure sp_transfer(IN applicant_id int,      
                     IN source_card_id char(30),
					 IN receiver_id int, 
                     IN dest_card_id char(30),
					 IN	amount numeric(10,2),
					 OUT return_code int)
as
DECLARE receiver_type char(20) default '0';
	
begin
return_code := 0;
IF exists(SELECT * FROM bank_card WHERE applicant_id=b_c_id AND source_card_id=b_number AND b_type='储蓄卡' AND b_balance>amount)
THEN
	SELECT b_type into receiver_type
	FROM bank_card
	WHERE receiver_id=b_c_id AND dest_card_id=b_number;

	IF receiver_type='储蓄卡'
	THEN 
		UPDATE bank_card
		SET b_balance=b_balance+amount
		WHERE receiver_id=b_c_id AND dest_card_id=b_number;

		UPDATE bank_card
		SET b_balance=b_balance-amount
		WHERE applicant_id=b_c_id AND source_card_id=b_number;
		return_code := 1;
	ELSEIF receiver_type='信用卡'
	THEN
		UPDATE bank_card
		SET b_balance=b_balance-amount
		WHERE receiver_id=b_c_id AND dest_card_id=b_number;
		UPDATE bank_card
		SET b_balance=b_balance-amount
		WHERE applicant_id=b_c_id AND source_card_id=b_number;
		return_code := 1;
	END IF;
END IF;
end; 


/*  end  of  your code  */ 








/*  end  of  your code  */ 