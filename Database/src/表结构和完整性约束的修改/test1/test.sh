#! /bin/bash
#---------- 评测前删除my_table your_table ---------
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 -c "DROP TABLE IF EXISTS my_table;" >log.txt 2>&1
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 -c "DROP TABLE IF EXISTS your_table;" >log.txt 2>&1

#---------- 准备评测表--------
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 -c "create table your_table(c1 int primary key,c2 varchar(32));" >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 -f /data/workspace/myshixun/src/test1/test1.sql >log.txt 2>&1

#---------- 检查结果 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "SELECT pg_constraint.contype,confkey,pg_attribute.attname AS colname,pg_type.typname AS typename, (case when attlen =-1  THEN atttypmod -4 ELSE attlen END) as length,attnotnull,atthasdef FROM pg_attribute INNER JOIN pg_class ON pg_attribute.attrelid = pg_class.oid left JOIN pg_constraint ON pg_constraint.conrelid = pg_class.oid AND pg_attribute.attnum = pg_constraint.conkey[1] INNER JOIN pg_type ON pg_type.oid = pg_attribute.atttypid  WHERE   pg_class.relname = 'my_table'  and attnum>0 order by attname;
"


