# Venmito Data Engineering Project - Solution

## **Author**

Fernando Martinez\
fernandomandino@gmail.com

## **Description**

This solution aims to consolidate and analyze data from multiple disparate sources to extract meaningful insights for Venmito, a payment company. The solution reads, loads, and integrates data from the following formats:

- **JSON**  (`people.json`) – Contains client information\
- **YAML** (`people.yml`) – Additional client data\
- **CSV** (`transfers.csv`, `promotions.csv`) – Records of transfered funds and promotions\
- **XML** (`transactions.xml`) – Transaction details

The goal is to clean, transform, and match this data into a structured SQL Server database for easy querying and analysis.

## **Design Approach**

- Python & Jupyter Notebook for data ingestion: Used to extract files, minimal transformation, and load data into SQL Server.
- SQL Server for Storage: Chosen for its robust querying capabilities.
- Structured Data Schema:
  - Landing Phase (**raw_** sourcefileformat_datafilename): All raw files are loaded as-is(some exceptions captured in **UPDATE WHEN FILE IS AVAILABLE**), ensuring original data is always available for reference.
  - Staging Phase (**stg_** tables): Data is processed, transformed, and structured to support analysis.
  - Processed tables (**T_** tables): Created a structured dataset for accurate reporting and visualization.
  - This approach ensures traceability and allows for data audits when necessary.

## **Installation & Setup**  

### **1. Prerequisites**  
- **SQL Server & SSMS** is installed
- **Python 3.x** is installed  
- Required Python libraries:  
  ```sh
  pip install pandas pyodbc pyyaml xmltodict

### **2. Running the Solution**  
#### **Step 2.1: Create Database Schema & Tables in SQL Server**
  1. Run the provided SQL scripts (setup.sql**UPDATE WHEN FILE IS AVAILABLE**) to create tables raw tables.
     
#### **Step 2.2: Load Data into SQL Server using Jupyter Notebook** 
  1. Execute the Python scripts (setup.sql**UPDATE WHEN FILE IS AVAILABLE**) to ingest and transform data
     
