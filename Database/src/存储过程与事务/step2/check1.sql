
-- delete from night_shift_schedule;
-- show procedure status where db = 'hms1';
call sp_night_shift_arrange('2022-5-1','2022-5-31');

--select n_date `date`,dayname(n_date) dayofweek,n_doctor_name doctor,n_nurse1_name nurse1,n_nurse2_name nurse2 from night_shift_schedule;

select n_date ,extract(DOW FROM cast(n_date as TIMESTAMP))  as dayofweek,n_doctor_name doctor,n_nurse1_name nurse1,n_nurse2_name nurse2 from night_shift_schedule;
