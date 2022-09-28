drop database if exists  covid19mon ;
create database covid19mon ;  
use covid19mon;

 CREATE TABLE person (
    id int primary key,
    fullname char(20)  not null,
    telephone char(11)  not null
 );
 
 INSERT INTO person VALUES (1, '张小敏', '13907110001'),
 (3, '孙二娘', '13307100003');