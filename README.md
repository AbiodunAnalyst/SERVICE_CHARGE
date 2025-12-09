# 💳 Service Charge Analytics – End-to-End ETL & BI Pipeline  
### R ETL • PostgreSQL Data Mart • Power BI Reporting

This repository contains an end-to-end **data engineering and analytics pipeline** for analysing bank **service charge transactions**.  

The project demonstrates how to:

- Ingest **multiple raw files** (CSV, Excel, ZIP)
- Clean and standardise transaction data
- Engineer time-based and business-friendly features
- Load curated data into a **PostgreSQL** database
- Expose the dataset to **Power BI** for interactive reporting

## 📦 End-to-End Data Pipeline Architecture

        ┌──────────────────────────────┐
        │     Raw Data Sources         │
        │  (CSV, Excel, ZIP Files)     │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │     R ETL Pipeline           │
        │  - File ingestion            │
        │  - Data cleaning             │
        │  - Missing value handling    │
        │  - Feature engineering       │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │     Curated Dataset          │
        │ (Cleaned & Enriched Service  │
        │        Charge Data)          │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │     PostgreSQL Database      │
        │  - service_charge_fact table │
        │  - Query-ready data mart     │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │       Power BI Dashboard     │
        │  - Trend analysis            │
        │  - Time-of-day analytics     │
        │  - User & transaction insight│
        │  - Operational intelligence  │
        └──────────────────────────────┘


---

## 🎯 Project Objectives

- Consolidate fragmented bank transaction files (CSV/XLSX/ZIP) into a single, clean dataset  
- Remove duplicates, missing values, and low-quality rows  
- Derive business-friendly variables such as **transaction time period**  
- Store the curated data in **PostgreSQL** for scalability and reuse  
- Enable advanced analytics and reporting through **Power BI**

---

## 🛠️ Tech Stack

- **Language:** R  
- **Libraries:**  
  - `data.table`, `dplyr`, `tidyverse` – data wrangling  
  - `readxl` – Excel ingestion  
  - `lubridate`, `hms` – date/time handling  
  - `DBI`, `RPostgres` – PostgreSQL connectivity  
- **Database:** PostgreSQL  
- **BI Tool:** Power BI  


##    ETL Process

library(data.table)
library(dplyr)
library(tidyverse)
library(sparklyr)
library(data.table)
library(readxl)
library(lubridate)

merge_csv_files <- function(mypath) {
  # Get the list of file names
  filenames <- list.files(path = mypath, full.names = TRUE)
  
  # Function to handle reading of files
  read_file <- function(file) {
    if (grepl("\\.zip$", file)) {
      # If the file is a zip, list the contents
      zip_contents <- unzip(file, list = TRUE)
      if (nrow(zip_contents) > 1) {
        stop("Compressed files containing more than 1 file are currently not supported.")
      }
      # Extract the single file and read it
      temp_file <- unzip(file, files = zip_contents$Name[1], exdir = tempdir())
      if (grepl("\\.csv$", temp_file)) {
        data <- fread(temp_file)
      } else if (grepl("\\.xlsx?$", temp_file)) {
        data <- as.data.table(read_excel(temp_file))
      } else {
        stop("Unsupported file type in zip.")
      }
    } else if (grepl("\\.csv$", file)) {
      # If the file is a CSV, read it directly
      data <- fread(file)
    } else if (grepl("\\.xlsx?$", file)) {
      # If the file is an Excel file, read it directly
      data <- as.data.table(read_excel(file))
    } else {
      stop("Unsupported file type.")
    }
    return(data)
  }
  
  # Apply the read_file function to each file
  data_list <- lapply(filenames, read_file)
  
  # Combine all data tables into one
  merged_data <- rbindlist(data_list, fill = TRUE)
  
  return(merged_data)
}

# Specify the directory containing CSV and Excel files

directory_path <- "C:/Users/DELL LATITUDE 7370/OneDrive/Documents/ENFORCA/bank"

# Call the merge_csv_files function to merge files from the directory

Price_df <- merge_csv_files(directory_path) %>%

# Remove duplicate rows   
  distinct() %>%  
  # Select required columns
  select('Date', 'User Type', 'Transaction Type','Service Fee','Banker Service Fee',
         'Customer Service Fee', 'Amount') %>%  
  # Remove rows where all specified columns are NA or empty
  filter(!(
    (is.na(Date) | trimws(Date) == "") &
    (is.na(`User Type`) | trimws(`User Type`) == "") &
    (is.na(`Transaction Type`) | trimws(`Transaction Type`) == "") &
    (is.na(Amount) | trimws(Amount) == "")
  )) %>%  
  # Convert and separate into date and time columns
   mutate(
    Date = ymd_hms(Date),
    Full_date = as.Date(Date),
    Time = format(Date, "%H:%M:%S")
  ) %>% 
  mutate(
    # Parse the Time column to a period object
    Time = hms(Time),
    
    # Create Service_Period based on the hour of the Time column
    Service_Period = case_when(
      hour(Time) >= 5 & hour(Time) < 12 ~ 'Morning',
      hour(Time) >= 12 & hour(Time) < 17 ~ 'Daytime',
      hour(Time) >= 17 & hour(Time) < 21 ~ 'Evening',
      TRUE ~ 'Night'
    )
  ) %>%
  # Convert Time back to character to keep only the time part
  mutate(
    Time = format(Time, format = "%H:%M:%S")
  ) %>% 
  # Renaming varaibles
  rename(
    User_Type = `User Type`, 
    Transaction_Type = `Transaction Type`, 
    Service_Fee = `Service Fee`, 
    Banker_Service_Fee = `Banker Service Fee`, 
    Customer_Service_Fee = `Customer Service Fee`,
    Transaction_Time = Service_Period
  ) %>%
  # Select final required row  
  select("Full_date", "User_Type", "Transaction_Type", "Transaction_Time", "Service_Fee", 
         "Banker_Service_Fee", "Customer_Service_Fee", "Amount")


View(Price_df)

nrow(Price_df)

summary(Price_df)

str(Price_df)

############### Connection to Posgresql ######################################

install.packages("RPostgres")

library(odbc)
library(RODBC)
library(DBI)
library(RPostgres)



# Connection to the database
con <- dbConnect(RPostgres::Postgres(), 
                 dbname = "BankProject",
                 host = "localhost",
                 port = 5432,
                 user = "postgres",
                 password = "marvel")  # Password should be enclosed in quotes

# Write to the database, overwriting existing table
dbWriteTable(con, "Price_df", Price_df, overwrite = TRUE)



# Write to the database, appending data to existing table
#dbWriteTable(con, "Price_df", Price_df, append = TRUE)


dbDisconnect(con)




### Project Background
#### ShopEase is a mid-sized retail business, which operates an online store where customers can make purchases using various payment methods. 
---
#### Key Variable:
1.  Business Name: This field captures the name of the businesses involved in the transactions. It allows us to categorize and identify key participants.
2.  User Type: Differentiates between user categories such as customers, merchants, or system users, giving insights into transaction flow between different actors.
3.  Reference & Unique Identifier: These fields can help track individual transactions, allowing for traceability and auditing.
4.  Amount: This is the transaction value, which helps us evaluate overall monetary flow.
5.  Service Fees (General, Banker, Customer): These indicate fees associated with the transaction from different perspectives.
6.  Transaction Type: Determines whether it’s a payment, refund, or other kinds of transactions, providing more context.
7.  Status: Provides information on whether the transaction is successful, pending, or failed.
8.  Card Type, Masked PAN, Card Description: Offers details about the payment method used, critical for understanding consumer preferences.
---
### Problem: 
#### The project looks at the impact of various service fee structures on user behavior.
---
### Analysis Process:
#### In this project, we follow the ETL (Extract, Transform, Load) process to analyze transaction data, using various tools such as RStudio, PostgreSQL, and Power BI to create insightful reports.
---
### Step 1: Extract Data
##### The first step in the ETL process involves extracting the raw transaction data from a CSV files.
---
### Step 2: Transform Data
#### Once the data is extracted, the next step is to clean and transform the data for analysis. Transformation Code is attached in file name Enforca_Solution.R
---
### Step 3: Load Data
#### Once the data is transformed, it needs to be loaded into PostgreSQL for storage and further reporting. The transformed data is sent to a PostgreSQL database using RStudio's database connection libraries such as RPostgres.
---
### Step 4: Reporting with Power BI
####  With the transformed data now stored in PostgreSQL, the final step is to create reports and visualizations using Power BI. Power BI connects directly to the  PostgreSQL database using the PostgreSQL connector.
---
### Model
<img width="614" alt="image" src="https://github.com/user-attachments/assets/d548e3c1-31a9-4210-9128-dbb7f2f71667">

---

### Solution
<img width="743" alt="image" src="https://github.com/user-attachments/assets/6d56faaa-a32a-492d-a9cc-e5971466b7f1">



---

### Insight
  1. Agents are the largest contributors to transaction volume, making them the most critical group to focus on when considering service fee adjustments or promotional   efforts. 
  2. Commissions and withdrawals dominate transaction types, optimizing service fees for these categories will have the greatest impact on revenue. Less common 
transaction types like P2P and Cable TV may be opportunities for growth if made more attractive with lower fees.
  3. Higher service fees correlate with lower transaction volumes, which indicates that fees may be a deterrent for higher usage. Reducing fees or introducing tiered 
pricing for high-volume users could increase overall transaction volume.
---

### Conclusion:
  1.  With agents forming the majority of users, focusing on optimizing their experience could have the most significant impact on transaction volumes.
  2.  A reduction in higher fees or creating incentives for frequently used transaction types could lead to increased activity across the platform.


