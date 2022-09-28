use MyDb;

select  TABLE_NAME as `Table`, COLUMN_NAME as Field, COLUMN_TYPE as Type, IS_NULLABLE as `Null`,COLUMN_KEY as `Key`
from  information_schema.COLUMNS
where TABLE_SCHEMA='MyDb' and TABLE_NAME in ('Dept', 'Staff') 
order by TABLE_NAME, ORDINAL_POSITION;

select TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME,
			 REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
from information_schema.KEY_COLUMN_USAGE
where TABLE_SCHEMA = 'MyDb' and REFERENCED_TABLE_NAME in ('Dept','Staff')
order by TABLE_NAME;


select constraint_name,table_name,constraint_type
from information_schema.TABLE_CONSTRAINTS
where table_schema = 'MyDb' and 	table_name in ('Dept', 'Staff')
order by TABLE_NAME, CONSTRAINT_NAME;

select staffNo, staffName,gender 
from Staff
where staffNo between 1357912 and 1357915
order by staffNo;