-----请在以下空白处填写完成任务的语句，空白行可通过回车换行添加。
-----你也可以在命令行窗口完成任务，不过，在命令行键入的语句不会被保存。

CREATE TABLE dept (
    deptNo INT,
    deptName VARCHAR(32),
    CONSTRAINT PK_dept PRIMARY KEY (deptNo)
);

CREATE TABLE staff (
    staffNo INT,
    staffName VARCHAR(32),
    gender CHAR(1),
    dob date,
    Salary numeric(8,2),
    deptNo INT,
    CONSTRAINT PK_staff PRIMARY KEY (staffNo),
    CONSTRAINT FK_staff_deptNo  FOREIGN KEY (deptNo) REFERENCES dept(deptNo)
);



------结束 