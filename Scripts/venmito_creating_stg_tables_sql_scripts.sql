/*Below is a Stored Procedure to execute all necessary scripts to create RAW landing tables for data ingestion*/
CREATE PROCEDURE Create_Venmito_StageTables
AS
BEGIN
    SET NOCOUNT ON;

    -- Create stg_promotions table 
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'stg_promotions')
    BEGIN
        SELECT
			id as promotion_id,
			client_email,
			telephone,
			CASE WHEN map.target_value IS NULL THEN promotion
					ELSE map.target_value 
					END as promotion,--if mapping doesn't exist then the source value will be passed instead
			UPPER(responded) as responded
		INTO
			stg_promotions
		FROM raw_csv_promotions p
		LEFT JOIN venmito_mapping_tool map
			   ON UPPER(map.source_value) = UPPER(p.promotion)
			  AND map.category = 'promotion';
    END

    -- Create stg_transfers table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'stg_transfers')
    BEGIN
        SELECT 
			sender_id,
			recipient_id,
			FORMAT(amount,'C') as amount,
			date
		INTO stg_transfers
		FROM raw_csv_transfers;
    END

    -- Create stg_transactions table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'stg_transactions')
    BEGIN
        SELECT
			transaction_id,
			store,
			phone,
			CASE WHEN map.target_value IS NULL THEN item
				 ELSE map.target_value 
				 END as item,
			quantity,
			FORMAT(price_per_item,'C') as price_per_item,
			FORMAT(price,'C') as total_item_amount,  
			sum(price) OVER (partition by transaction_id ) as total_transaction_amount
		INTO stg_transactions
		FROM raw_xml_transactions t
		LEFT JOIN venmito_mapping_tool map
			ON UPPER(map.source_value) = UPPER(t.item)
			AND map.category = 'promotion';
    END

    -- Create stg_merged_people table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'stg_merged_people')
    BEGIN
        WITH JSON_PEOPLE AS (
	select 
		CAST(id as INT) as people_id,
		'JSON' as source,
		CONCAT(TRIM(first_name), ' ' , TRIM(last_name)) as full_name,
		first_name, 
		last_name, 
		telephone,
		email,
		city,
		country,
		CASE WHEN UPPER(devices) LIKE '%Android%' THEN 'Yes' ELSE 'No' END AS android,
		CASE WHEN UPPER(devices) LIKE '%Desktop%' THEN 'Yes' ELSE 'No' END AS desktop,
		CASE WHEN UPPER(devices) LIKE '%Iphone%' THEN 'Yes' ELSE 'No' END AS iphone
	from raw_json_people
	)
	,YAML_PEOPLE AS (
		select	
			id as people_id,
			'YAML' as source,
			trim(name) as full_name,
			trim(SUBSTRING(name, 1, CHARINDEX(' ', name))) as first_name,
			trim(RIGHT(name, len(name) - CHARINDEX(' ', name))) as last_name,
			phone as telephone,
			email,
			trim(SUBSTRING(city, 1, CHARINDEX(',', city) -1)) as city,
			trim(RIGHT(city, len(city) - CHARINDEX(',', city))) as country,
			CASE WHEN android = 1 THEN 'Yes' ELSE 'No'END as android,
			CASE WHEN desktop = 1 THEN 'Yes' ELSE 'No'END as desktop,
			CASE WHEN iphone = 1 THEN 'Yes' ELSE 'No'END as iphone
		from raw_yaml_people
		)
	,ONLY_EXIST_IN_YAML AS (
			select  *
			from  YAML_PEOPLE JSON_PEOPLE 
			where people_id not in (
					select people_id from JSON_PEOPLE)
		)
	,COMPILED_PEOPLE_DATA as (
			select 
					*
			from JSON_PEOPLE
		UNION
			select
					* 
			from ONLY_EXIST_IN_YAML
		)
	Select 
			*
	INTO stg_merged_people
	from COMPILED_PEOPLE_DATA
    END


    PRINT 'All staging tables created successfully.';
END;
GO  -- Batch separator to ensure stored procedure is created first

-- Execute the stored procedure
EXEC Create_Venmito_StageTables;
