#! /bin/bash

# 选择数据库实例 
read -p '' choice

# 数据初始化
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/src/common/$choice.sql >log.txt 2>&1

#---------- 运行学生代码 ---------- 
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -f  /data/workspace/myshixun/src/test14/test14.sql
