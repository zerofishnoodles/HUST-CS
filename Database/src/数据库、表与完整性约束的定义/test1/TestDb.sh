#!/bin/bash

#执行sql语句
export MYSQL_PWD=123123
mysql -h127.0.0.1 -uroot << EOF

SELECT information_schema.SCHEMATA.SCHEMA_NAME 
FROM information_schema.SCHEMATA 
where SCHEMA_NAME='MyDb';

EOF

#touch /tmp/temp.log  
#mysql -uroot -p123123 -h127.0.0.1 -e"SELECT information_schema.SCHEMATA.SCHEMA_NAME FROM information_schema.SCHEMATA where SCHEMA_NAME='MyDb';" > /tmp/temp.log   
#more /tmp/temp.log

