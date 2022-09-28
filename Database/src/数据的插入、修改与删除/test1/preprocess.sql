drop table if exists  client;

--CREATE TABLE person (
--  id int primary key,
--  fullname char(20)  not null,
--  telephone char(11)  not null
--);

CREATE TABLE client(
  c_id int NOT NULL ,
  c_name varchar(100) NOT NULL ,
  c_mail char(30)  NULL DEFAULT NULL ,
  c_id_card char(18)  NOT NULL ,
  c_phone char(11)  NOT NULL ,
  c_password char(20) NOT NULL ,
  PRIMARY KEY(c_id)
  );