--drop database if exists testdb1;
--create database testdb1;
--use testdb1;

drop table if exists ticket;
create table ticket(flight_no char(6) primary key, tickets int);
insert into ticket values('MU2455',159),('CZ5525',167),('CA8213',265);
drop table if exists result;
create table result (
    t_seq serial primary key,
    t int,
    tickets int
);
