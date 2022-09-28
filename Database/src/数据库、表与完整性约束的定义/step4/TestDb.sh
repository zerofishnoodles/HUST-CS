#! /bin/bash

#执行sql语句
export MYSQL_PWD=123123
mysql -h127.0.0.1 -uroot --force < src/step4/insert_test.sql 2>/dev/null

mysql -h127.0.0.1 -uroot << EOF
use MyDb;
desc products;

select constraint_name,constraint_type  
from information_schema.table_constraints  
where TABLE_SCHEMA = 'MyDb' and table_name='products';

select pid,brand,price from products 
where pid in ('TEST01','TEST02','TEST03','TEST04');
EOF

#touch /tmp/temp.log  
#mysql -uroot -p123123 -h127.0.0.1 -e"use MyDb;desc t_user1; desc t_user2;" >/tmp/temp.log   
#more /tmp/temp.log

