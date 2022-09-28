  #执行sql文件
# 选择测试用例 
read -p '' choice

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < src/step4/testdb$choice.sql >log.txt 2>&1

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
  sh src/step6/testt$i.sh  
    
 }&  
 
done

wait;


#mysql -h127.0.0.1 -uroot << EDF
#use testdb$choice;
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select row_number() over (order by t_seq) time_seq, t, tickets from result order by t_seq;"
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select t_seq,t,tickets   from result order by t_seq;"