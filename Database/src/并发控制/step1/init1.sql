drop database if exists testdb1;
create database testdb1;
use testdb1;

CREATE TABLE `dept` (  
     `id` int(11) NOT NULL AUTO_INCREMENT,  
	 `name` varchar(20) DEFAULT NULL,  
	 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

insert into dept(name) values("行政部");
