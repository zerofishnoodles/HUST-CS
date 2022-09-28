-- 创建存储过程`sp_fibonacci(in m int)`，向表fibonacci插入斐波拉契数列的前m项，及其对应的斐波拉契数。fibonacci表初始值为一张空表。请保证你的存储过程可以多次运行而不出错。

create procedure sp_fibonacci(in m int)
as
DECLARE i int default 2;
DECLARE f1 int;
DECLARE f2 int;
begin
-- ######## 请补充代码完成存储过程体 ########
DELETE FROM fibonacci;
IF m=1 THEN INSERT INTO fibonacci VALUES(0, 0);
ELSEIF m=2 THEN 
	INSERT INTO fibonacci VALUES(0, 0);
	INSERT INTO fibonacci VALUES(1, 1);
ELSE 
	INSERT INTO fibonacci VALUES(0, 0);
	INSERT INTO fibonacci VALUES(1, 1);
	WHILE i<m LOOP
		SELECT fibn into f1
		FROM fibonacci
		WHERE n=i-1;

		SELECT fibn into f2
		FROM fibonacci
		WHERE n=i-2;

		INSERT INTO fibonacci VALUES(i, f1+f2);
		i := i+1;
	END LOOP;
END IF;
end;
/
 
