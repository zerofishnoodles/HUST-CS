
 delete from night_shift_schedule;
--insert into employee values (8,'徐小慧',3),(9,'李实珍',2);
call sp_night_shift_arrange('2022-6-1','2022-6-30');

--select n_date `date`,dayname(n_date) dayofweek,n_doctor_name doctor,n_nurse1_name nurse1,n_nurse2_name nurse2 from night_shift_schedule;

select n_date ,extract(DOW FROM cast(n_date as TIMESTAMP))  as dayofweek,n_doctor_name doctor,n_nurse1_name nurse1,n_nurse2_name nurse2 from night_shift_schedule;


