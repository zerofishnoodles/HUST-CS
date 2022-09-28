\set payer_id   1900 
\set payer_card  '6228365310342443'
\set payee_id 1900
\set payee_card  '4270304201500306'
\set v  9042 
select sp_transfer(:payer_id, :payer_card, :payee_id, :payee_card, :v);
select * from bank_card order by b_number;

--4270304201500306	
--6228365310342443	