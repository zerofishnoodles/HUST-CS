\set payer_id  110 
\set payer_card '4270302211625243'
\set  payee_id  100 
\set payee_card  '4270304201142362'
\set v  1000 
\set retcode 1
--call sp_transfer(:payer_id, :payer_card, :payee_id, :payee_card, :v, :retcode);
 select  sp_transfer(:payer_id, :payer_card, :payee_id, :payee_card, :v);

--select :retcode;
select * from bank_card order by b_number;
