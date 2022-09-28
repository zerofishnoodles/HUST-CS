use covid19mon;
select id,location_name,capacity,occupied 
from isolation_location_status
order by id desc;