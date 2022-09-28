 #! /bin/bash
 #! /bin/bash
#---------- 评测前删除TestDb ---------
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "drop table if exists staff;" >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "drop table if exists dept;" >log.txt 2>&1
#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -f /data/workspace/myshixun/src/step3/test3.sql >log.txt 2>&1

#---------- 检查结果 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "SELECT pg_constraint.contype,pg_attribute.attname AS colname,pg_type.typname AS typename, (case atttypid  when 1700 then case when atttypmod =-1 then null else ('('|| to_char( ((atttypmod - 4) >> 16) & 65535)|| ','|| to_char((atttypmod - 4) & 65535)||')') end else  (case when attlen =-1  THEN to_char(atttypmod -4) ELSE to_char(attlen) END) end ) as length,attnotnull,atthasdef FROM pg_attribute INNER JOIN pg_class ON pg_attribute.attrelid = pg_class.oid left JOIN pg_constraint ON pg_constraint.conrelid = pg_class.oid AND pg_attribute.attnum = pg_constraint.conkey[1] INNER JOIN pg_type ON pg_type.oid = pg_attribute.atttypid  WHERE     pg_class.relname = 'dept'  and attnum>0 order by attname;
"
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "SELECT pg_constraint.contype,pg_attribute.attname AS colname,pg_type.typname AS typename, (case atttypid  when 1700 then case when atttypmod =-1 then null else ('('|| to_char( ((atttypmod - 4) >> 16) & 65535)|| ','|| to_char((atttypmod - 4) & 65535)||')') end else  (case when attlen =-1  THEN to_char(atttypmod -4) ELSE to_char(attlen) END) end ) as length,attnotnull,atthasdef FROM pg_attribute INNER JOIN pg_class ON pg_attribute.attrelid = pg_class.oid left JOIN pg_constraint ON pg_constraint.conrelid = pg_class.oid AND pg_attribute.attnum = pg_constraint.conkey[1] INNER JOIN pg_type ON pg_type.oid = pg_attribute.atttypid  WHERE     pg_class.relname = 'staff'  and attnum>0 order by attname;
"
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "SELECT  x.table_name,x.column_name,conname FROM  information_schema.key_column_usage x   INNER JOIN  (SELECT  t.relname, a.conname  FROM  pg_constraint a INNER JOIN pg_class  ft   ON ft.oid = a.confrelid  INNER JOIN pg_class t  ON t.oid = a.conrelid   WHERE  a.contype = 'f' AND  a.confrelid =  (select e.oid  from pg_class e  where e.relname = 'dept') ) tp  ON (x.table_name = tp.relname AND   x.constraint_name = tp.conname);	
"