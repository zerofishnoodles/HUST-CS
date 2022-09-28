drop database if exists  covid19mon ;
create database covid19mon ;  
use covid19mon;

-- 表1 人员表(person)
create table person (
  id int not null,
  fullname char(20)   not null,
  telephone char(11) not null,
  constraint pk_person primary key(id)
);

-- 表2 地点表(location)
create table location (
  id int not null,
  location_name char(20)  not null,
  constraint pk_location primary key(id)
);

-- 表3 行程表（itinerary）
drop table if exists itinerary;
create table itinerary (
  id int  not null,
  p_id int,
  loc_id int,
  s_time datetime,
  e_time datetime,
  constraint pk_itinerary primary key(id),
  constraint fk_itinerary_pid foreign key(p_id) references person(id),
  constraint fk_itinerary_lid foreign key(loc_id) references location(id)
);

-- 表4 诊断表（diagnose_record）
create table diagnose_record (
  id int  not null,
  p_id int,
  diagnose_date datetime,
  result int,
  constraint pk_diagnose_record primary key(id),
  constraint fk_diagnose_pid foreign key(p_id) references person(id)
);


-- 表5 密切接触者表（close_contact）
create table close_contact (
  id int not null,
  p_id int ,
  contact_date datetime,
  loc_id int,
  case_p_id int,
  constraint pk_close_contact primary key(id),
  constraint fk_contact_pid foreign key(p_id) references person(id),
  constraint fk_contact_lid foreign key(loc_id) references location(id),
  constraint fk_contact_caseid foreign key(case_p_id) references person(id)
);

-- 表6 隔离地点表（isolation_location）
create table isolation_location (
  id int  not null,
  location_name char(20) ,
  capacity int,
  constraint pk_isolation_loc primary key(id)
);

-- 表7 隔离表（isolation_record）
create table isolation_record (
  id int  not null,
  p_id int,
  s_date datetime,
  e_date datetime,
  isol_loc_id int,
  state int,
  constraint pk_isolation primary key(id),
  constraint fk_isolation_pid foreign key(p_id) references person(id),
  constraint fk_isolation_lid foreign key(isol_loc_id) references isolation_location(id)
);
