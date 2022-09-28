
DROP TABLE IF EXISTS orderDetail;
DROP TABLE IF EXISTS orders;

create table orders(
    orderNo char(12) primary key,
    orderDate date,
    customerNo char(12),
    employeeNo char(12)
);

create table orderDetail(
    orderNo char(12) ,
    productNo char(12),
    quantityOrdered int,
    orderDate date,
   primary key(orderNo, productNo),
   constraint FK_orderDetail_orderNo foreign key(orderNo) references orders(orderNo)
);

