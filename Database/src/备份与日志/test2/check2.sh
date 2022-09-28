 #! /bin/bash


# 选择测试用例 
read -p '' choice

# 时刻1：写数据part I
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/src/test2/train$choice.sql 2>/dev/null >log.txt 2>&1


# 时刻2：执行学生备份脚本
source /data/workspace/src/test2/test2_1.sh


# 时刻3：写数据part II
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/src/test2/train3.sql 2>/dev/null >log.txt 2>&1


# 接着复制日志-- 以下只适用于MySQL，不适用于OpenGuass
#b=`expr 7 + $choice`
#ls -ll /var/lib/mysql/binlog.0*

files=($(ls /var/lib/mysql/binlog.0*))
#for(( i=0;i<${#files[@]};i++)) do echo ${files[i]}; done;
len=${#files[@]}
#echo $len
index=`expr $len - 1`
#echo $index
filename=${files[index]}
#echo $filename
cp $filename log/binlog.000018


# 时刻4：清理全部数据
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "drop table routine;"

# 时刻5：执行学生恢复脚本 
source /data/workspace/src/test2/test2_2.sh


#----------检查恢复后的数据 ----------
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select * from routine;"