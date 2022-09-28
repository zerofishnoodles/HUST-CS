#! /bin/bash
#mysql -uroot -p123123 <<EDF
#drop database if exists mydb;
#CREATE DATABASE mydb;
#USE mydb;

#create table account(
#	name varchar(25) not null,
#	money int not null
#);

#insert into account values ('A',100),('B',100);
#EDF
#执行sql文件
#mysql -uroot -p123123 -t < src/step2/query2.sql

 #! /bin/bash

#---------- 数据准备 ----------
#export MYSQL_PWD=123123
#mysql -h127.0.0.1 -uroot < src/step2/testdb1.sql 2>/dev/null
#mysql -h127.0.0.1 -uroot < src/step2/testdb2.sql 2>/dev/null

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < src/step2/testdb1.sql >log.txt 2>&1

#---------- 运行学生代码 ---------- 
#mysql -h127.0.0.1 -uroot < src/step3/test3.sql 
# 2>/dev/null

#sh src/step2/testt1t2.sh

# 选择测试用例 
#read -p '' choice

#cat src/step2/head$choice.sql src/step2/t1.sql > src/step2/todo1.sql 2>&1
#cat src/step2/head$choice.sql src/step2/t2.sql > src/step2/todo2.sql 2>&1

for ((i=1;i<=2;i++))
do
{
  #mysql -h127.0.0.1 -uroot < src/step2/todo$i.sql
  sh src/step2/testt$i.sh 
    
 }&  
 
done

wait;


#mysql -h127.0.0.1 -uroot << EDF
#use testdb$choice;
#select row_number() over (order by t_seq) time_seq, t, tickets from result order by t_seq;

#EDF
#source src/step2/t1.sql;
#source src/step2/t2.sql;

#---------- 开始评测 ---------- 
#mysql -h127.0.0.1 -uroot < src/step3/check$choice.sql

#
