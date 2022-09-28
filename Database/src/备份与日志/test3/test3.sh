# 没有第3关，这里只是个备份文件

read -p '' choice
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 < src/test1/finance$choice.sql 
#>log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "\d"

su - omm

chmod -R 700 /var/lib/opengauss/data/base
chown  -R omm  /var/lib/opengauss/data/base   
rm -rf /home/omm/backup$choice
mkdir /home/omm/backup$choice
gs_basebackup  -U gaussdb  -D /home/omm/backup$choice -h localhost  -p5432
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "drop table client;" >log.txt 2>&1

cp -r /home/omm/backup$choice/* /var/lib/opengauss/data/

su omm -c "/usr/local/opengauss/bin/gs_ctl restart -D /var/lib/opengauss/data/"
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "\d"

