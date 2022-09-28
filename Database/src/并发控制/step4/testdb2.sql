--drop database if exists testdb1;
--create database testdb1;
--use testdb1;

drop table if exists ticket;
create table ticket(flight_no char(6) primary key, aircraft char(10), tickets int);
insert into ticket values('MU2455','B737-300',159),('CZ5525','B737-300',167),('CA1558','B777-300ER',392);
drop table if exists result;
create table result (
    flight_no char(6) , aircraft char(10), tickets int,t int,
    t_seq serial primary key
);