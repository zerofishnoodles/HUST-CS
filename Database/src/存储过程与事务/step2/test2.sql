
-- 编写一存储过程，自动安排某个连续期间的大夜班的值班表:

create procedure sp_night_shift_arrange(in start_date date, in end_date date)
AS
	DECLARE cur_date date default start_date;
	DECLARE doc_name char(30);
	DECLARE doc_type char(30);
	DECLARE nurse1 char(30);
	DECLARE nurse2 char(30);

	CURSOR cur_doctor FOR (
		SELECT e_name,e_type
		FROM employee
		WHERE e_type=1 or e_type=2
	);
	CURSOR cur_nurse FOR (
		SELECT e_name
		FROM employee
		WHERE e_type=3
	);
begin
	DELETE FROM night_shift_schedule;
	OPEN cur_doctor;
	OPEN cur_nurse;
	WHILE cur_date<=end_date LOOP
		IF extract('DOW' FROM cur_date)>=1 AND extract('DOW' FROM cur_date)<=5
		THEN
			IF NOT exists(SELECT * FROM night_shift_schedule WHERE cur_date=n_date)
			THEN
				FETCH cur_doctor INTO doc_name,doc_type;
				IF cur_doctor%FOUND=0
				THEN 
					close cur_doctor;
					open cur_doctor;
					FETCH cur_doctor INTO doc_name,doc_type;
				END IF;
			END IF;

			FETCH cur_nurse INTO nurse1;
			IF cur_nurse%FOUND=0
			THEN 
				close cur_nurse;
				open cur_nurse;
				FETCH cur_nurse INTO nurse1;
			END IF;
			FETCH cur_nurse INTO nurse2;
			IF cur_nurse%FOUND=0
			THEN 
				close cur_nurse;
				open cur_nurse;
				FETCH cur_nurse INTO nurse2;
			END IF;
			IF NOT exists(SELECT * FROM night_shift_schedule WHERE cur_date=n_date)
			THEN
				INSERT INTO night_shift_schedule VALUES(cur_date, doc_name, nurse1, nurse2);
			ELSE
				UPDATE night_shift_schedule
				SET n_nurse1_name=nurse1, n_nurse2_name=nurse2
				WHERE n_date=cur_date;
			END IF;
		ELSE
			FETCH cur_doctor INTO doc_name,doc_type;
			IF cur_doctor%FOUND=0
			THEN 
				close cur_doctor;
				open cur_doctor;
				FETCH cur_doctor INTO doc_name,doc_type;
			END IF;
			FETCH cur_nurse INTO nurse1;
			IF cur_nurse%FOUND=0
			THEN 
				close cur_nurse;
				open cur_nurse;
				FETCH cur_nurse INTO nurse1;
			END IF;
			FETCH cur_nurse INTO nurse2;
			IF cur_nurse%FOUND=0
			THEN 
				close cur_nurse;
				open cur_nurse;
				FETCH cur_nurse INTO nurse2;
			END IF;
			
			IF doc_type=2
			THEN
				INSERT INTO night_shift_schedule VALUES(cur_date, doc_name, nurse1, nurse2);
			ELSE
				IF extract('DOW' FROM cur_date)=0
				THEN
					INSERT INTO night_shift_schedule VALUES(cur_date+integer'1', doc_name, 'temp', 'temp');
				ELSE
					INSERT INTO night_shift_schedule VALUES(cur_date+integer'2', doc_name, 'temp', 'temp');
				END IF;

				FETCH cur_doctor INTO doc_name,doc_type;
				IF cur_doctor%FOUND=0
				THEN 
					close cur_doctor;
					open cur_doctor;
					FETCH cur_doctor INTO doc_name,doc_type;
				END IF;
				INSERT INTO night_shift_schedule VALUES(cur_date, doc_name, nurse1, nurse2);
			END IF;

		END IF;
		cur_date := cur_date + integer'1';
	END LOOP;

	DELETE FROM night_shift_schedule
	WHERE n_date > end_date;

end;

/*  end  of  your code  */ 
