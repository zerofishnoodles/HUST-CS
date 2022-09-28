 #! /bin/bash

#---------- 数据准备 ----------
export MYSQL_PWD=123123
#mysql -h127.0.0.1 -uroot < src/test3/preprocess.sql 2>/dev/null

#---------- 运行学生代码 ---------- 
#mysql -h127.0.0.1 -uroot < src/test3/test3.sql 2>/dev/null

#---------- 检查结果 ---------- 
#mysql -h127.0.0.1 -uroot < src/test3/check.sql

#! /bin/bash

#---------- 数据准备 ----------
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test3/preprocess.sql >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test3/test3.sql >log.txt 2>&1

#---------- 检查结果 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "\d addressBook"