# CREATE DATABASE if not exists MyDb;

use MyDb;
desc dept; 
desc staff;
select TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME 
from information_schema.KEY_COLUMN_USAGE 
where TABLE_SCHEMA = 'MyDb' and REFERENCED_TABLE_NAME in ('dept','staff');