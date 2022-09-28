#! /bin/bash
#---------- 评测前删除hr ---------
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "drop table if exists hr;" >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -f /data/workspace/myshixun/src/step5/step5.sql >log.txt 2>&1

#---------- 检查结果 ----------
#----c = check constraint
#----f = foreign key constraint
#----p = primary key constraint
#----u = unique constraint
#----t = constraint trigger
#----x = exclusion constraint

gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "SELECT pg_constraint.contype,pg_attribute.attname AS colname,pg_type.typname AS typename, (case atttypid  when 1700 then case when atttypmod =-1 then null else ('('|| to_char( ((atttypmod - 4) >> 16) & 65535)|| ','|| to_char((atttypmod - 4) & 65535)||')') end else  (case when attlen =-1  THEN to_char(atttypmod -4) ELSE to_char(attlen) END) end ) as length,attnotnull,atthasdef,PG_ATTRDEF.adsrc FROM pg_attribute INNER JOIN pg_class ON pg_attribute.attrelid = pg_class.oid left JOIN pg_constraint ON pg_constraint.conrelid = pg_class.oid AND pg_attribute.attnum = pg_constraint.conkey[1] INNER JOIN pg_type ON pg_type.oid = pg_attribute.atttypid left join PG_ATTRDEF on PG_ATTRDEF.adrelid=pg_attribute.attrelid and PG_ATTRDEF.adnum=pg_attribute.attnum  WHERE     pg_class.relname = 'hr'  and attnum>0 order by attname;
"
