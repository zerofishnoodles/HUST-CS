--- 如果存在循环参照引用，则以下语句难以执行。
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS Dept CASCADE;


create table Dept(
    deptNo int primary key,
	deptName varchar(32),
	tel char(11),
	mgrStaffNo int
);

create table Staff(
    staffNo int,
	staffName varchar(32),
	gender char(1),
	dob date,
	salary numeric(8,2),
	dept int
);
