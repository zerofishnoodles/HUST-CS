DROP TABLE IF EXISTS addressBook;

create table addressBook(
   serialNo serial primary key,
   name char(32),
   company char(32),
   position char(10),
   workPhone char(16),
   mobile char(11),
   QQ int
);


