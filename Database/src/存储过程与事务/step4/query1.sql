USE mydb;
########## 修改存储过程 ———— 向 tb_emp 表中插入数据（注意请勿修改提供的代码框架） ##########
drop procedure if exists mydb.proc_insert;
delimiter $$
create procedure proc_insert()
Begin 
	

	#开启事务
	start transaction ;
    insert into t_emp values(4,'Tom',302,4800);
    insert into t_emp values(4,'Tony',302,5900);
	update t_emp set salary=0 where id=1;
	update t_emp set salery=8000 where id=2;
	#事务提交
	commit;


END $$
delimiter ;


