 #! /bin/bash
#检查模板
# 选择数据库实例 
read -p '' choice
#---------- 数据准备 ----------
#export MYSQL_PWD=123123
#mysql -h127.0.0.1 -uroot < src/common/finance1.sql 2>/dev/null
#mysql -h127.0.0.1 -uroot < src/common/finance2.sql 2>/dev/null
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "drop database finance;"	
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "create database finance;"
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/src/common/$choice.sql >log.txt 2>&1

# 选择数据库实例 
#read -p '' choice

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f  /data/workspace/myshixun/src/test1/test1.sql

