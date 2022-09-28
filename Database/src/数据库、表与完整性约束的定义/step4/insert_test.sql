use MyDb;

delete from products where pid in ('TEST01','TEST02','TEST03','TEST04');

insert into products(pid,brand,price) values('TEST01','A',1000);
insert into products(pid,brand,price) values('TEST02','B',2000);
insert into products(pid,brand,price) values('TEST03','C',1000);
insert into products(pid,brand,price) values('TEST04','A',-500);
