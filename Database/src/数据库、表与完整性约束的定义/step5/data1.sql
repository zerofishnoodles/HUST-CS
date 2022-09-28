USE MyDb;

-- create table hr(id char(10) primary key, name varchar(32), mz char(16) default('汉族'));
delete from hr where id = 'TEST01';

insert into hr(id,name) values('TEST01','张三丰');