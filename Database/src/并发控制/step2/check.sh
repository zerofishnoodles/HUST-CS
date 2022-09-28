 #! /bin/bash

#---------- 数据准备 ----------
export MYSQL_PWD=123123
mysql -h127.0.0.1 -uroot < src/step2/testdb1.sql 2>/dev/null
mysql -h127.0.0.1 -uroot < src/step2/testdb2.sql 2>/dev/null


#---------- 运行学生代码 ---------- 
#mysql -h127.0.0.1 -uroot < src/step3/test3.sql 
# 2>/dev/null

# 选择测试用例 
read -p '' choice

cat src/step2/head$choice.sql src/step2/t1.sql > src/step2/todo1.sql 2>&1
cat src/step2/head$choice.sql src/step2/t2.sql > src/step2/todo2.sql 2>&1

for ((i=1;i<=2;i++))
do
{
  mysql -h127.0.0.1 -uroot < src/step2/todo$i.sql
    
 }&  
 
done

wait;


mysql -h127.0.0.1 -uroot << EDF
use testdb$choice;
select row_number() over (order by t_seq) time_seq, t, tickets from result order by t_seq;

EDF
#source src/step2/t1.sql;
#source src/step2/t2.sql;

#---------- 开始评测 ---------- 
#mysql -h127.0.0.1 -uroot < src/step3/check$choice.sql

#
