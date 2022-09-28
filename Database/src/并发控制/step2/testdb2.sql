drop database if exists testdb2;
create database testdb2;
use testdb2;

drop table if exists ticket;
create table ticket(flight_no char(6) primary key, tickets int);
insert into ticket values('MU2455',159),('CZ5525',167),('CA8213',301);

create table result (
    t_seq datetime primary key,
    t int,
    tickets int
);
 