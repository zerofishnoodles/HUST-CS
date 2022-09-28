 #! /bin/bash
#---------- 评测前删除TestDb ---------
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "drop table if exists products;" >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -f /data/workspace/myshixun/src/step4/test4.sql >log.txt 2>&1

#---------- 检查结果 ----------
#----c = check constraint
#----f = foreign key constraint
#----p = primary key constraint
#----u = unique constraint
#----t = constraint trigger
#----x = exclusion constraint

gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "SELECT pg_constraint.contype,pg_attribute.attname AS colname,pg_type.typname AS typename, (case atttypid  when 1700 then case when atttypmod =-1 then null else ('('|| to_char( ((atttypmod - 4) >> 16) & 65535)|| ','|| to_char((atttypmod - 4) & 65535)||')') end else  (case when attlen =-1  THEN to_char(atttypmod -4) ELSE to_char(attlen) END) end ) as length,attnotnull,atthasdef FROM pg_attribute INNER JOIN pg_class ON pg_attribute.attrelid = pg_class.oid left JOIN pg_constraint ON pg_constraint.conrelid = pg_class.oid AND pg_attribute.attnum = pg_constraint.conkey[1] INNER JOIN pg_type ON pg_type.oid = pg_attribute.atttypid  WHERE     pg_class.relname = 'products'  and attnum>0 order by attname;
"

gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "select pgc.conname as constraint_name,ccu.table_schema as table_schema,ccu.table_name,ccu.column_name,pg_get_constraintdef(pgc.oid) from pg_constraint pgc join pg_namespace nsp on nsp.oid = pgc.connamespace join pg_class  cls on pgc.conrelid = cls.oid left join information_schema.constraint_column_usage ccu on pgc.conname = ccu.constraint_name  and nsp.nspname = ccu.constraint_schema where (contype ='c' or  contype ='p') and table_name='products' order by pgc.conname;
"
