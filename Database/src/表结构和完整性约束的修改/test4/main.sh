 #! /bin/bash

#---------- 数据准备 ----------
#export MYSQL_PWD=123123
#mysql -h127.0.0.1 -uroot < src/test4/preprocess.sql 2>/dev/null

#---------- 运行学生代码 ---------- 
#mysql -h127.0.0.1 -uroot < src/test4/test4.sql 2>/dev/null

#---------- 插入几行数据 ----------
#mysql -h127.0.0.1 -uroot < src/test4/insert_data.sql 2>/dev/null

#---------- 检查结果 ---------- 
#mysql -h127.0.0.1 -uroot < src/test4/check.sql


#---------- 数据准备 ----------
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test4/preprocess.sql >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test4/test4.sql >log.txt 2>&1

#---------- 检查结果 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "\d Staff"
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "\d Dept"