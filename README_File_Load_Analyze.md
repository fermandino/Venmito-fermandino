# Venmito Data Engineering Project - Solution

## **Author**

Fernando Martinez\
fernandomandino@gmail.com

## **Description**

This solution aims to consolidate and analyze data from multiple disparate sources to extract meaningful insights for Venmito, a payment company. The solution reads, loads, and integrates data from the following formats:

- **JSON**  (`people.json`) – Contains client information
- **YAML** (`people.yml`) – Additional client data
- **CSV** (`transfers.csv`, `promotions.csv`) – Records of transferred funds and promotions
- **XML** (`transactions.xml`) – Transaction details

The goal is to clean, transform, and match this data into a structured SQL Server database for easy querying and analysis.

## **Design Approach**

- Python & Jupyter Notebook for data ingestion: Used to extract files, minimal transformation, and load data into SQL Server.
- SQL Server for Storage: Chosen for its robust querying capabilities.
- Structured Data Schema:
  - Landing Phase (**raw_** sourcefiletype_datafilename): All raw files are loaded as-is, ensuring original data is always available for reference.
  - Staging Phase (**stg_** tables): Data is processed, transformed, and structured to support analysis.
  - Processed tables (**T_** tables): Created a structured dataset for accurate reporting and visualization.
  - This approach ensures traceability and allows for data audits when necessary.

## **Installation & Setup**  

### **1. Prerequisites**  
- **SQL Server & SSMS** is installed
- **Python 3.x** is installed
- **Jupyter Notebook** is installed
- Required Python libraries:  
  ```sh
  pip install pandas pyodbc yaml xmltodict

### **2. Running the Solution**  
#### **Step 2.1: Create Database Schema & Tables in SQL Server**
  1. Open SQL Server Management Studio (SSMS) and connect to your server which should be already created (as noted in pre-requisite)
  2. The Object Explorer will open and might need to expand it to see the Databases folder
  3. Go to your folders and Right-Click on Databases
     - Select _New Database_
     - A new window will open, please create a Database name. Notice the Server name as this will be used in future steps which is highlighted under _Connection:_ in below image.
     - ![create_database_ssms](https://github.com/user-attachments/assets/f088c4f2-82e4-4ec5-b4cd-10321e74c525)
    
#### **Step 2.2: Create Raw Tables in SQL Server**
  1. Once Database is created as mentioned in previous step 2.1, open a new query window to start creating our schema.
    - ![database_ssms_new_query](https://github.com/user-attachments/assets/77282d02-7f37-41e6-aadc-e9e3fb9fcac6)
  2. Now execute the entirety of the code _venmito_creating_raw_tables_sql_scripts.sql_ located in the Scripts folder.
    - This will create a stored procedure and execute it as well. In result all neccesary raw tables and a mapping table will be created. 
     
#### **Step 2.3: Load Data into SQL Server using Jupyter Notebook** 
  1. Open Jupyter Notebook and create a new session with Python 3*
  2. There are 2 python scypts that will load the raw tables created in step 2.2.
     - Copy and paste the query inside the file name _import_code_python_load_compile.txt_ in the Scripts folder. Make sure to run the statement to load successfully 
     - Now repeat the step with file name _import_code_transfers_csv.txt_
     ![Jupyter_notebook_load_compile](https://github.com/user-attachments/assets/39e2ff5c-8a97-4152-8e81-7fd5699dec8b)

#### **Step 2.4: Create Staging Tables for analysis**
  1. Similar to step 2.1, open a new query window and execute the entirety of the code _venmito_creating_stg_tables_sql_scripts.sql_ located in the _Scripts_ folder
     - This will create a stored procedure and execute it as well.
  2. All tables are now avaialble in the schema for analysis and reporting.
     - stg_merged_people
     - stg_promotions
     - stg_transactions
     - stg_transfers
       
#### Step 2.5: Create Transformed Tables for analysis and Visualization
  1. Similar to step 2.1, open a new query window and execute the entirety of the code _venmito_creating_target_tables_sql_scripts.sql_ located in the _Scripts_ folder
     - This will create a stored procedure and execute it as well.
 2. All tables are now avaialble in the schema for analysis and reporting.
     - TGT_full_promotion_people
     - TGT_transaction_full
     - TGT_transfers_promo

## **Data Consumption**
  1. Now that we have created a database and structured tables in SQL Server, technical users can access the data for analysis or their respective needs. 
  2. With the creation of the database we are able to export the tables in a _csv_ file format and share with non-technical users. Please find the csv files in the _CSV Tables_ folder.
  3. Data analysis and initial insight can be found in the _Scripts_ folder with file name venmito_insights_sql_scripts.sql

## **Future Enhancements**
- Adding the transfers.csv load step to the compiled file for simplicity.
- Automate the pipeline by using orchestration tools like Airflow.
- Update Database Schema by implementing rules in the ingestion and validation of records (Primary Keys, Nullable Columns, etc)
- Creating a connection to a visualization tool (like Tableau) for reporting graphs and additional insights for business and technical users. 
- Migrate to a cloud-based solution (e.g., AWS, Azure).
