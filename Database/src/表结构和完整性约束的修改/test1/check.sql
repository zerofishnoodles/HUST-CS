use TestDb1;

select  TABLE_NAME as `Table`, COLUMN_NAME as Field, COLUMN_TYPE as Type, IS_NULLABLE as `Null`,COLUMN_KEY as `Key`
from  information_schema.COLUMNS
where TABLE_SCHEMA='TestDb1' and TABLE_NAME in ('your_table','my_table') 
order by COLUMN_NAME;