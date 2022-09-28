use fib;

select '---- case 1 -----';
call sp_fibonacci(1);
select * from fibonacci where n <= 1;

select '---- case 2 -----';
call sp_fibonacci(2);
select * from fibonacci where n <= 2;

select '---- case 3 -----';
call sp_fibonacci(10);
select * from fibonacci where n <= 10;

select '---- case 4 -----';
call sp_fibonacci(20);
select * from fibonacci where n <= 20;
