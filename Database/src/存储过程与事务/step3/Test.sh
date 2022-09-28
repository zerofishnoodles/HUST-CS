#! /bin/bash

#---------- 数据准备 ----------
#export MYSQL_PWD=123123
#mysql -h127.0.0.1 -uroot < src/step3/finance1.sql 2>/dev/null
#mysql -h127.0.0.1 -uroot < src/step2/hms2.sql 2>/dev/null


#---------- 运行学生代码 ---------- 
#mysql -h127.0.0.1 -uroot < src/step3/test3.sql 
# 2>/dev/null

# 选择测试用例 
#read -p '' choice

#---------- 开始评测 ---------- 
#mysql -h127.0.0.1 -uroot < src/step3/check$choice.sql

# 选择测试用例
read -p '' choice
# 数据初始化
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/src/step3/finance1.sql >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "DROP PROCEDURE if exists sp_transfer;">log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f  /data/workspace/myshixun/src/step3/test3.sql 
#>log.txt 2>&1

#---------- 检查结果 ----------


gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f /data/workspace/myshixun/src/step3/check$choice.sql

