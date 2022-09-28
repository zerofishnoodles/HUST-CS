#read -p '' choice
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 < src/test1/finance$choice.sql 
#>log.txt 2>&1

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "\d"

#chmod -R 700 /var/lib/opengauss/data
#chown  -R omm  /var/lib/opengauss/data   
#su omm -c "/usr/local/opengauss/bin/gs_ctl restart -D /var/lib/opengauss/data/"

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "alter system set enable_cbm_tracking=on;"

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "show enable_cbm_tracking;"

#su - omm

#chmod -R 700 /var/lib/opengauss/data/base
#chown  -R omm  /var/lib/opengauss/data/base   
#rm -rf /home/omm/backup$choice
#mkdir /home/omm/backup$choice
#chmod -R 700 /home/omm/backup$choice
#chown  -R omm  /home/omm/backup$choice   
#gs_basebackup  -U gaussdb  -D /home/omm/backup$choice -h localhost  -p5432
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "drop table client;" >log.txt 2>&1
#su omm -c "/usr/local/opengauss/bin/gs_ctl stop -D /var/lib/opengauss/data/"

#cp -r /home/omm/backup$choice/* /var/lib/opengauss/data/
#chmod -R 700 /home/omm/backup$choice
#chown  -R omm  /home/omm/backup$choice  

#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "\d"

read -p '' choice
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 < src/test1/finance$choice.sql 
#>log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "\d"

#su - omm

chmod -R 700 /var/lib/opengauss/data/base
chown  -R omm  /var/lib/opengauss/data/base   
rm -rf /home/omm/backup$choice
mkdir /home/omm/backup$choice
gs_basebackup  -U gaussdb  -D /home/omm/backup$choice -h localhost  -p5432
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  -c "drop table client;" >log.txt 2>&1

cp -r /home/omm/backup$choice/* /var/lib/opengauss/data/

su  omm -c"/usr/local/opengauss/bin/gs_ctl restart -D /var/lib/opengauss/data -M primary"
#gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select * from client order by c_id;"
gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "\d"
