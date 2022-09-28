gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "DROP Database if exists beijing2022;" >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432  < /data/workspace/myshixun/src/step1/test1.sql >log.txt 2>&1

gsql -d postgres -U gaussdb -W'Passwd123@123' -h localhost  -p5432 -c "select datname,usename,encoding,datcollate,datctype from pg_database,pg_user where datname='beijing2022' and pg_database.datdba=usesysid;
"	