 #! /bin/bash

# 数据初始化
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < src/test1/finance1.sql >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop user if exists cindy cascade;" >log.txt 2>&1
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "create user Cindy with password 'hust_1234';" 
#>log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop user if exists tom cascade;" >log.txt 2>&1
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "create user tom with password 'hust_1234';"
# >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop user if exists jerry cascade;" >log.txt 2>&1
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "create user jerry with password 'hust_1234';" 
#>log.txt 2>&1




gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop Role if exists client_manager ;" 
#>log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c  "drop user if exists fund_manager ;" 
#>log.txt 2>&1


#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f  src/test2/test2.sql 
#>log.txt 2>&1

#---------- 检查结果 ----------
#mysql -h127.0.0.1 -uroot < src/ins_upd.sql 2>/dev/null
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "SELECT rolname,rolpassword FROM pg_authid where rolname in ('client_manager','fund_manager','tom','cindy')  order by rolname;"

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from information_schema.usage_privileges where grantee='tom';"
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "\dp"
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from information_schema.table_privileges ;"


gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='client_manager'  order by column_name,privilege_type;"

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='fund_manager' order by column_name,privilege_type;"

#information_schema.role_table_grants
#select*frominformation_schema.usage_privilegeswheregrantee='postgres';
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from information_schema.usage_privileges where grantee='tom';"
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='tom';"

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "\du tom;"

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "\du jerry;"

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "\du cindy;"


#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='jerry';"

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "select * from INFORMATION_SCHEMA.role_column_grants where grantee='cindy';"

# 选择测试用例
#read -p '' choice

#---------- 检查结果 ---------- 
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f /data/workspace/myshixun/src/check$choice.sql
 
