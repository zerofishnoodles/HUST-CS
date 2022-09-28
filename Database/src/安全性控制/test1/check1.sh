#! /bin/bash

# 数据初始化
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < src/test1/finance1.sql >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop user if exists cindy cascade;" >log.txt 2>&1


gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "create user Cindy with password 'hust_1234';" >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "GRANT SELECT  ON bank_card TO cindy;" >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop user if exists tom cascade;" >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop user if exists jerry cascade;" >log.txt 2>&1


#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f  src/test1/test1.sql 
#>log.txt 2>&1

#---------- 检查结果 ----------
#mysql -h127.0.0.1 -uroot < src/ins_upd.sql 2>/dev/null
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "SELECT rolname,rolpassword FROM pg_authid where rolname in ('tom','jerry') order by rolname desc;"

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from information_schema.usage_privileges where grantee='tom';"
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "\dp"
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from information_schema.table_privileges ;"

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from information_schema.role_table_grants where grantor='tom';"
#information_schema.role_table_grants
#select*frominformation_schema.usage_privilegeswheregrantee='postgres';
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from information_schema.usage_privileges where grantee='tom';"
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='tom' order by column_name desc;"

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='jerry' order by column_name;"

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='cindy' order by column_name;"

# 选择测试用例
#read -p '' choice

#---------- 检查结果 ---------- 
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f /data/workspace/myshixun/src/check$choice.sql
 
