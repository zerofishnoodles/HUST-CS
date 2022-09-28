#---------- 数据准备 ----------
#export MYSQL_PWD=123123
#mysql -h127.0.0.1 -uroot < src/finance1.sql 2>/dev/null

#---------- 运行学生代码 ---------- 
#mysql -h127.0.0.1 -uroot < src/test.sql


# 选择测试用例 
#read -p '' choice

#---------- 开始评测 ---------- 
#mysql -h127.0.0.1 -uroot << EDF
#use finance1;
#set @para = $choice;
#select get_deposit(@para);

#EDF

#! /bin/bash
# 数据初始化
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < src/finance1.sql >log.txt 2>&1
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "drop function if exists get_deposit;">log.txt 2>&1
#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f  /data/workspace/myshixun/src//test.sql 

#---------- 检查结果 ----------
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f /data/workspace/myshixun/src/step1/check.sql
# 选择测试用例 
read -p '' choice

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -r << EDF
select get_deposit($choice);
EDF