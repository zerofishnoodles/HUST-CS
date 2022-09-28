#!/bin/bash
#请在下方编写创建数据库的代码

export MYSQL_PWD=123123
mysql -h127.0.0.1 -uroot << EDF
SELECT information_schema.SCHEMATA.SCHEMA_NAME FROM information_schema.SCHEMATA where SCHEMA_NAME='beijing2022';
EDF