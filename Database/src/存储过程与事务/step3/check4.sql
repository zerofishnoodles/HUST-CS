
\set payer_id   1600 
\set payer_card  '4270302211625243'
\set payee_id 100 
\set payee_card  '4270304201142362'
\set v  1095 
select sp_transfer(:payer_id, :payer_card, :payee_id, :payee_card, :v);
select * from bank_card order by b_number;