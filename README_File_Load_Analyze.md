# Venmito Data Engineering Project - Solution

## **Author**

Fernando Martinez\
fernandomandino@gmail.com

## **Description**

This solution aims to consolidate and analyze data from multiple disparate sources to extract meaningful insights for Venmito, a payment company. The solution reads, loads, and integrates data from the following formats:

- **JSON**  (`people.json`) – Contains client information
- **YAML** (`people.yml`) – Additional client data
- **CSV** (`transfers.csv`, `promotions.csv`) – Records of transfered funds and promotions
- **XML** (`transactions.xml`) – Transaction details

The goal is to clean, transform, and match this data into a structured SQL Server database for easy querying and analysis.

## **Design Approach**

- Python & Jupyter Notebook for data ingestion: Used to extract files, minimal transformation, and load data into SQL Server.
- SQL Server for Storage: Chosen for its robust querying capabilities.
- Structured Data Schema:
  - Landing Phase (**raw_** sourcefiletype_datafilename): All raw files are loaded as-is(some exceptions captured in **UPDATE WHEN FILE IS AVAILABLE**), ensuring original data is always available for reference.
  - Staging Phase (**stg_** tables): Data is processed, transformed, and structured to support analysis.
  - Processed tables (**T_** tables): Created a structured dataset for accurate reporting and visualization.
  - This approach ensures traceability and allows for data audits when necessary.

## **Installation & Setup**  

### **1. Prerequisites**  
- **SQL Server & SSMS** is installed
- **Python 3.x** is installed  
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
    
#### **Step 2.2: Create Tables in SQL Server**
  1. Once Databse is created as mentioned in previous step 2.1, open a new query window to start creating our schema.
    - ![database_ssms_new_query](https://github.com/user-attachments/assets/77282d02-7f37-41e6-aadc-e9e3fb9fcac6)
  2. 
  3. The Object Explorer will open and might need to expand it to see the Databases folder
  5. Run the provided SQL scripts (setup.sql**UPDATE WHEN FILE IS AVAILABLE**) to create tables raw tables.
  6. **UPDATE** Why Use a Stored Procedure?
  7. **UPDATE** Ensures all tables are created in one execution.
  8. **UPDATE** Prevents duplicate table creation with IF NOT EXISTS.
  9. **UPDATE** Simplifies database setup for future users.
     
#### **Step 2.2: Load Data into SQL Server using Jupyter Notebook** 
  1. Execute the Python scripts (setup.sql**UPDATE WHEN FILE IS AVAILABLE**) to ingest and transform data
     
## **Future Enhancements** 
- **(Need to update wording)** Adding transfers.csv file to the importing all codes
- **(Need to update wording)** Create a Stored Procedure to create all SQL tables from 1 action
- **(Need to update wording)** Update Database Schema by implementing rules in the ingestion and validation of records (Primary Keys, Nullable Columns, etc)
- Automate the pipeline by using orchestration tools like Airflow.
- Migrate to a cloud-based solution (e.g., AWS, Azure).
- **(Need to update wording)** Tableau
