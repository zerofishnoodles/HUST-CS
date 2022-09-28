 ##
use MyDb;
desc products;

select constraint_name,constraint_type  
from information_schema.table_constraints  
where TABLE_SCHEMA = 'MyDb' and table_name='products';

select pid,brand,price from products 
where pid in ('TEST01','TEST02','TEST03','TEST04');

