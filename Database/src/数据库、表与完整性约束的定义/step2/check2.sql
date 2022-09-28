 -- 列出表结构和主码
CREATE DATABASE if not exists TestDb;

use TestDb;

select  COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE,COLUMN_KEY 
from  information_schema.COLUMNS
where TABLE_SCHEMA='TestDb' and TABLE_NAME in  ('t_emp') 
order by column_name;
