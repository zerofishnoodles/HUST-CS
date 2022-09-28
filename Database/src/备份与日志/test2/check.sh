 read -p '' choice
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "create database residents;" >log.txt 2>&1
gsql -d residents -U gaussdb -W'Passwd123@123' -h localhost  -p5432 < src/test1/finance$choice.sql >log.txt 2>&1



#gs_dump -U gaussdb -W'Passwd123@123' -f backup.tar -p5432 residents -F t
sh src/test1/test1_1.sh >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "drop database residents" >log.txt 2>&1

 gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "create database residents;" >log.txt 2>&1

#gs_restore -U gaussdb -W'Passwd123@123'  backup.tar -p5432  -d residents
sh src/test1/test1_2.sh >log.txt 2>&1

gsql -d residents -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select * from client order by c_id;"
