#! /bin/bash
mysql -uroot -p123123 << EDF  
drop database if exists School;
CREATE DATABASE School;
USE School;
create table student(
	stu_id int primary key,
	name varchar(25) not null,
	math int not null,
    chinese int not null
);

insert into student values (2,'Jack',10,80);

EDF

rm info.log >/dev/null
sh src/step1/run.sh 2>&1 | tee -a info.log >/dev/null
var=$(sed -n 1p info.log)
echo ${var##*file:} 


#执行sql文件
mysql -uroot -p123123 -DSchool -t << EDF  
select * from student;
EDF
