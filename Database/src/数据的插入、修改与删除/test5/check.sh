#---------- 数据准备 ----------
#export MYSQL_PWD=123123
#mysql -h127.0.0.1 -uroot < src/test1/finance1.sql 2>/dev/null

#---------- 运行学生代码 ---------- 
#mysql -h127.0.0.1 -uroot < src/test5/test5.sql 2>/dev/null

#---------- 检查结果 ---------- 
#mysql -h127.0.0.1 -uroot < src/test5/check.sql

#! /bin/bash
# 数据初始化
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/src/test1/finance1.sql >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f  /data/workspace/myshixun/src/test5/test5.sql >log.txt 2>&1

#---------- 检查结果 ----------
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f /data/workspace/myshixun/src/test5/check.sql