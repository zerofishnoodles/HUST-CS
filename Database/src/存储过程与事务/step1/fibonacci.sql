--drop database if exists fib; 
--create database fib;
--use fib;

drop table if exists fibonacci;
create table fibonacci(
    n int primary key,
	fibn bigint
); 