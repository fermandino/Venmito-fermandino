/* Below are queries showing some insight in the data in addition 
to the aggregations found in the Target Tables*/
--


Begin -- Using transfers data to strategize promotion (tgt_transfers_promo)
/*	
	- This Table is created to focus on the recipients of a transfer and joining the promotion
	- By filtering the matches based on a 'YES' response to a past promotion there are opportunities
	  to engage once again with the client now that a transfer has been received. 

	- We can go further into this table and prioritize what promotion to select based on the amount received, location and even date (holidays, seasons, etc) 
	
*/
	select * from tgt_transfers_promo
	where promotion_id is not null
	and responded = 'YES'

END
GO

BEGIN --Creating full view of promotion table with data from people on emails and phone numbers that were missing. 

	
/*Possibe way to change the response for client from NO to YES
	- Some promotions only had 1 method of contacting the client. Reach out through the missing method (either email or phone) found in the created new_reach column
	
*/
	select * from T_full_promotion_people
	where responded = 'NO'
	order by new_reach desc 
	
	-- We can also Target promotions based on location as there are regions where high negative response based on the promotion 
	select 
			promotion, 
			CONCAT(city, ', ', country) as location_,
			responded, 
			count(*) as cnt
	from T_full_promotion_people
	where responded = 'NO'
	group by promotion, CONCAT(city, ', ', country), responded
	order by cnt desc

	
END
GO

BEGIN--Combining the Promotions with Transactions to see the impact of promotion reach
/*	
	- Of all the transactions (200) only 3 were reached through a promotion. 
		It doesn't seem that the promotions have an effect on the outcome of sales with this dataset. 
	
	- Store with Most Profit = Trader Tales
	- Store with Least Profit = Targeted Treasures
	- Best Seller Item (based in quantity) = Dove
	- Unpopular item (based in quantity) = Coca Cola
	
*/
SELECT 
	   transaction_id
      ,store
      ,phone
      ,item
	  ,responded as responded_to_promotion
      ,quantity
	  ,price_per_item
      ,total_item_amount
	  , SUM(quantity) OVER (Partition by item) as total_item_quantity_sold
	  , SUM(quantity) OVER (Partition by item, store) as total_item_quantity_sold_per_store 
	  , SUM(total_item_amount) OVER (Partition by store) as total_sales_per_store
	  , SUM(total_item_amount) OVER (Partition by store, item) as total_sales_items_per_store
	  ,total_transaction_amount
	  
  FROM stg_transactions t
  LEFT JOIN T_full_promotion_people promo
	    ON promo.telephone = t.phone
	   AND promo.promotion = t.item
END
GO

