/*Below is a Stored Procedure to execute all necessary scripts to create RAW landing tables for data ingestion*/
CREATE PROCEDURE Create_Venmito_RawTables
AS
BEGIN
    SET NOCOUNT ON;

    -- Create raw_csv_promotions table 
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'raw_csv_promotions')
    BEGIN
        CREATE TABLE raw_csv_promotions  (
			id FLOAT NULL, 
			client_email VARCHAR(255) NULL,
			telephone VARCHAR(50) NULL,
			promotion VARCHAR(255) NULL,
			responded VARCHAR(50) NULL
		);
    END

    -- Create raw_csv_transfers table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'raw_csv_transfers')
    BEGIN
        CREATE TABLE raw_csv_transfers  (
			sender_id int NULL, 
			recipient_id int NULL,
			amount float NULL,
			date date NULL
		);
    END

    -- Create raw_json_people table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'raw_json_people')
    BEGIN
        CREATE TABLE raw_json_people  (
			id VARCHAR(50) NULL, 
			first_name VARCHAR(255) NULL,
			last_name VARCHAR(255) NULL,
			telephone VARCHAR(50) NULL,
			email VARCHAR(255) NULL,
			devices VARCHAR(255) NULL,
			city VARCHAR(255) NULL, 
			country VARCHAR(255) NULL
		);
    END

    -- Create raw_yaml_people table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'raw_yaml_people')
    BEGIN
        CREATE TABLE raw_yaml_people  (
			android INT NULL, 
			desktop INT NULL,
			Iphone INT NULL,
			city VARCHAR(255) NULL,
			email VARCHAR(255) NULL,
			id INT NULL,
			name VARCHAR(255) NULL, 
			phone VARCHAR(255) NULL
		);
    END

    -- Create raw_xml_transactions table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'raw_xml_transactions')
    BEGIN
        CREATE TABLE raw_xml_transactions  (
			transaction_id INT NULL,
			store VARCHAR(255) NULL,
			phone VARCHAR(255) NULL,
			item VARCHAR(255) NULL,
			price float NULL,
			price_per_item float NULL,
			quantity INT NULL,
		);
    END

	-- Create venmito_mapping_tool table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'venmito_mapping_tool')
    BEGIN
        CREATE TABLE venmito_mapping_tool (
		mapping_id INT NOT NULL,
		category varchar(50) NULL,
		source_value VARCHAR(50) NULL,
		target_value VARCHAR(50) NULL
		);

		INSERT INTO venmito_mapping_tool (mapping_id, category, source_value, target_value) VALUES 
		(1, 'promotion', 'Coca-Splash', 'Coca-Cola'),
		(2, 'promotion', 'Colgatex','Colgate' ),
		(3, 'promotion', 'Dovee','Dove'),
		(4, 'promotion', 'Flixnet', 'Netflix'),
		(5, 'promotion', 'GatorBoost', 'Gatorade'),
		(6, 'promotion', 'KittyKat', 'Kit-Kat'),
		(7, 'promotion', 'Krafty Cheddar', 'Kraft Cheese'),
		(8, 'promotion', 'Oreoz', 'Oreo'),
		(9, 'promotion', 'Popsi', 'Pepsi'),
		(10, 'promotion', 'RedCow', 'RedBull')
    END

    PRINT 'All raw tables and mapping_table created successfully.';
END;
GO  -- Batch separator to ensure stored procedure is created first

-- Execute the stored procedure
EXEC Create_Venmito_RawTables;
