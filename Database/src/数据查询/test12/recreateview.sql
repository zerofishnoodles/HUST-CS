use covid19mon;
go
create view isolation_location_status as
select id,location_name,capacity,(select count(*) from isolation_record where isol_loc_id =i.id and state = 1) as occupied 
from isolation_location i; 