drop table if exists ticket;
create table ticket(flight_no char(6) primary key, aircraft char(10), tickets int);
insert into ticket values('MU2455','B737-800',167),('CZ5525','B737-800',159),('CA8213','A330-300',301);
drop table if exists result;
create table result (
    flight_no char(6) , aircraft char(10), tickets int,t int,
    t_seq serial primary key
);

