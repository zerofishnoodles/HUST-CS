drop database if exists mydb;
CREATE DATABASE mydb;
USE mydb;

create table account(
	id int primary key auto_increment,
	name varchar(25) not null,
	money int not null
);

insert into account(name,money) values('A',100),('B',100);
