--drop database if exists testdb1;
--create database testdb1;
--use testdb1;

drop table if exists ticket;
create table ticket(flight_no char(6) primary key, tickets int);
insert into ticket values('MU2455',159),('CZ5525',159),('CA8213',301);

create table result (
    t_seq datetime primary key,
    t int,
    tickets int
);
