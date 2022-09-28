#!/bin/bash

#执行sql语句
export MYSQL_PWD=123123
mysql -h127.0.0.1 -uroot << EDF
use MyDb;
desc dept; 
desc staff;
select TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME 
from information_schema.KEY_COLUMN_USAGE 
where TABLE_SCHEMA = 'MyDb' and REFERENCED_TABLE_NAME in ('dept','staff');

EDF
