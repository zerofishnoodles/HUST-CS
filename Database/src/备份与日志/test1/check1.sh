 #! /bin/bash

# 选择测试用例 
read -p '' choice

#---------- 数据准备 ----------
# export MYSQL_PWD=123123
# mysql -h127.0.0.1 -uroot < secret/resident$choice.sql 2>/dev/null
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "create database residents;" >log.txt 2>&1
gsql -d residents -U gaussdb -W'Passwd123@123' -h localhost  -p5432 < src/test1/resident$choice.sql >log.txt 2>&1

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/secret/resident$choice.sql 2>/dev/null >log.txt 2>&1

# 执行学生的备份语句
#gs_dump -U gaussdb -W'Passwd123@123' -f backup.tar -p5432 residents -F t
#source /data/workspace/myshixun/src/test1/test1_1.sh
sh /data/workspace/myshixun/src/test1/test1_1.sh

#sh src/test1/test1_1.sh >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "drop database residents" >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "create database residents;" >log.txt 2>&1

#gs_restore -U gaussdb -W'Passwd123@123'  backup.tar -p5432  -d residents
#sh src/test1/test1_2.sh >log.txt 2>&1

#gsql -d residents -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select * from client order by c_id;"

#cat residents_bak.sql

# 删数据 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "drop database residents" >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "create database residents;" >log.txt 2>&1

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "drop table residents;"

# 执行学生写的恢复指令
# gs_restore -d postgres -U gaussdb -W'Passwd123@123' -h localhost -p5432 -F c ~/residents_bak.sql
# gs_restore -U gaussdb -W'Passwd123@123'  backup.tar -p5432  -d residents
sh /data/workspace/myshixun/src/test1/test1_2.sh
#sh src/test1/test1_2.sh >log.txt 2>&1


#---------- 检查恢复后的数据---------- 
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select * from residents;"

gsql -d residents -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select * from residents;"
