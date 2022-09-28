\set payer_id   700 
\set payer_card  '4270304201049444'
\set payee_id 100 
\set payee_card  '4270304201142362'
\set v  1000 
select sp_transfer(:payer_id, :payer_card, :payee_id, :payee_card, :v);
select * from bank_card order by b_number;