#! /bin/bash

#---------- 数据准备 ----------
#export MYSQL_PWD=123123
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test2/preprocess.sql >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test2/test2.sql >log.txt 2>&1

#---------- 检查结果 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "\d orderdetail"