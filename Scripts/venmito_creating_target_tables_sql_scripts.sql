/* Below are queries to create target table for further insight and possible connection to visualization tools*/
--
CREATE PROCEDURE Create_Venmito_TGT_Table
AS
BEGIN
    SET NOCOUNT ON;

    -- Create TGT_full_promotion_people table 
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TGT_full_promotion_people')
    BEGIN
        select * 
		INTO TGT_full_promotion_people
		from 
			(select 
					promotion_id, 
					CASE WHEN client_email = '' THEN p.email ELSE client_email END as client_email,
					CASE WHEN pro.telephone = '' THEN p.telephone ELSE pro.telephone END as telephone,
					promotion,
					responded,
					CASE WHEN client_email = '' THEN p.email
						 WHEN pro.telephone = '' THEN p.telephone
						 ELSE ''
						 END as new_reach,
					people_id,
					full_name,
					city,
					country,
					android, 
					desktop,
					iphone
			from stg_promotions pro
			JOIN stg_merged_people p
				ON pro.client_email = p.email
				OR pro.telephone = p.telephone) a
    END
	

    -- Create TGT_transaction_full table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TGT_transaction_full')
    BEGIN
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

		INTO TGT_transaction_full
		  FROM stg_transactions t
		  LEFT JOIN TGT_full_promotion_people promo
				ON promo.telephone = t.phone
			   AND promo.promotion = t.item
	END

	

	-- Create TGT_transfers_promo table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TGT_transfers_promo')
    BEGIN
		SELECT 
				sender_id,
				recipient_id,
				amount,
				date,
				p.full_name as full_recipient_name,
				p.telephone,
				email,
				p.city, 
				p.country,
				fp.promotion_id, 
				fp.promotion,
				fp.responded,
				p.android,
				p.desktop,
				p.iphone
		INTO TGT_transfers_promo
		from stg_transfers t
		LEFT JOIN stg_merged_people p
			   ON p.people_id = t.recipient_id
		LEFT JOIN TGT_full_promotion_people fp
			   ON fp.people_id = t.recipient_id
	END

		PRINT 'All target tables created successfully.';
END;
GO  -- Batch separator to ensure stored procedure is created first

-- Execute the stored procedure
EXEC Create_Venmito_TGT_Table;
