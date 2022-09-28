drop table if exists night_shift_schedule;

create table night_shift_schedule(
     n_date date primary key,
	 n_doctor_name char(30) not null,
	 n_nurse1_name char(30) not null,
	 n_nurse2_name char(30) not null
 ) ;
 
 drop table if exists employee;
 create table employee(
     e_id int primary key,
	 e_name char(30) not null,
	 e_type int not null -- 1 for director/doctor, 2 for doctor, 3 for nurse
 ) ;
 
 insert into employee values (1,'赵杏林',1),
(2,'李无病',2),(3,'周护',3),(4,'张去疾',2),(5,'王逢春',3),
(6,'孙小兰',3),(7,'郑莉莉',3),(8,'徐小慧',3),(9,'李实珍',2); 