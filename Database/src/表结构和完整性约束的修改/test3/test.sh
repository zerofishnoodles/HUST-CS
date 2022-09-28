#! /bin/bash

#---------- 数据准备 ----------
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test3/preprocess.sql >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 < src/test3/test3.sql >log.txt 2>&1

#---------- 检查结果 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -p5432 -c "\d addressBook"