-- 事务1:
use testdb1;
## 请设置适当的事务隔离级别
set session transaction isolation level ;

start transaction;

-- 时刻2 - 事务1读航班余票,发生在事务2修改之后
## 添加等待代码，确保读脏

select tickets from ticket where flight_no = 'CA8213';
commit;
