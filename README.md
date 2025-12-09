<h1 align="center">💳 Service Charge Analytics Pipeline</h1>

<p align="center">
  <strong>Automated ETL • Data Quality Framework • PostgreSQL Data Mart • Power BI Insights</strong>
</p>

<p align="center">
  End-to-end financial data engineering pipeline built using R, PostgreSQL, and Power BI to process, enrich, and analyze service charge transactions at scale.
</p>

<p align="center">

  <img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" />
  <img src="https://img.shields.io/badge/Data%20Engineering-4B8BBE?style=for-the-badge" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" />
  <img src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />
  <img src="https://img.shields.io/badge/Status-Production--Ready-brightgreen?style=for-the-badge" />

</p>

---

<p align="center">
  <em>This repository demonstrates enterprise-level ETL engineering, feature engineering, analytical modelling, and BI reporting.</em>
</p>

---

# 📦 **Project Overview**

This repository contains a production-ready **ETL and BI analytics system** for bank service charge transactions.  
The project transforms raw CSV, Excel, and ZIP files into a structured **PostgreSQL data mart**, enriched with engineered features and visualized through an interactive **Power BI dashboard**.

It demonstrates:

- Automated ingestion of multiple file formats  
- Robust data quality checks  
- Business-driven feature engineering  
- Relational database modelling  
- Insight generation for financial and operational teams  

---



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


## 📘 Project Background

ShopEase is a growing digital retail business with thousands of daily transactions processed across multiple channels.  
Every transaction attracts one or more service fees — from the platform, banks, or third-party processors.  

As transaction volume grew, the leadership team began experiencing:

- Unpredictable service charge expenses  
- Difficulty understanding which user groups drive fees  
- Rising complaints about “hidden charges”  
- A lack of visibility into peak fee-generating periods  

This project was initiated to build a **data-driven view of service fees**, uncover drivers of cost, and optimise ShopEase’s pricing model.

---

## 🔑 Key Variables

- **Business Name** → Identifies transacting entities and partners  
- **User Type** → Customer, agent, merchant, system user  
- **Reference & Unique Identifier** → Enables auditing and traceability  
- **Amount** → Monetary value of each transaction  
- **Service Fees** → Platform, Banker, and Customer fee components  
- **Transaction Type** → Withdrawal, deposit, payment, refund, P2P, etc.  
- **Status** → Successful / pending / failed  
- **Card Information** → Helps uncover consumer payment preferences  

These fields allow us to build a **360-degree view of transaction behaviour and cost structure**.

---

## ❗ Problem Statement

Service fees were significantly affecting customer experience and operational cost,  
but the business had **no consolidated analytics system** to understand:

- Which users generate the highest fee volume  
- Which transaction types are most expensive  
- How fee changes impact transaction behaviour  
- When (time of day) fees peak  
- Whether higher service fees discourage usage  

The challenge was to build a **full ETL → Database → BI solution** that provides real-time insights for decision-makers.

---

## 🔄 Analytics Process (ETL Architecture)

### **Step 1 — Extract**
Raw data in **CSV, Excel, and ZIP** formats was ingested using a custom R ETL pipeline.

### **Step 2 — Transform**
Data was cleaned, validated, de-duplicated, and enriched with engineered features like:

- `Full_Date`  
- `Time`  
- `Transaction_Period (Morning/Day/Evening/Night)`  

The final transformation script is included in `Tranformation_pipe_line_code.R`.

### **Step 3 — Load**
Curated data was loaded into a **PostgreSQL fact table**, forming the analytical data mart.

### **Step 4 — Report**
Power BI connected directly to PostgreSQL, enabling dynamic dashboards and interactive exploration.

---

## 🏗️ Data Model (Power BI)

<img width="620" src="https://github.com/user-attachments/assets/d548e3c1-31a9-4210-9128-dbb7f2f71667">

The dimensional model includes:

- **Fact Table** → Price_df (transaction + service fee details)  
- **Dimensions** → Transaction Type, User Type, Service Fee Category, Date Table  

This star-schema design ensures:

- Fast reporting  
- Clean relationships  
- Efficient DAX calculations  

---

## 💡 Power BI Solution

<img width="750" src="https://github.com/user-attachments/assets/6d56faaa-a32a-492d-a9cc-e5971466b7f1">

The dashboard answers ShopEase’s core business questions:

- *Where are service fees coming from?*  
- *Who is most affected by them?*  
- *What transactions drive the most costs?*  
- *Are users discouraged by high fees?*  
- *What time of day sees the most activity?*  

---

## 📊 Key Insights (Strengthened & More Strategic)

### **1️⃣ Agents are the most influential user group**
Agents account for the majority of transaction volume, meaning:

- They are extremely sensitive to changes in service fee policy  
- Their activity directly influences platform liquidity  
- Incentives or fee reductions targeted at agents could rapidly boost volume  

**Strategic Opportunity:**  
Introduce *tiered service fees* to reward high-performing agents.

---

### **2️⃣ A small number of transaction types dominate activity**
Withdrawals and commissions account for more than **70%** of all fees generated.

This concentration means:

- Small pricing adjustments in these two categories have *massive revenue impact*  
- Less frequently used transaction types (P2P, Cable TV, Wallet Top-ups) are under-leveraged  

**Strategic Opportunity:**  
Lower fees for the less popular types to stimulate adoption and diversify revenue streams.

---

### **3️⃣ Fee structure directly influences behaviour**
The analysis shows a clear relationship:

- **Higher service fees → Lower transaction volumes**
- Users avoid high-fee periods and prefer times when costs are lower

**Strategic Opportunity:**  
Introduce **time-of-day pricing**, reducing fees during low-activity windows.

---

### **4️⃣ Platform revenue potential is under-optimized**
With over **$184 million** processed and more than **11,000 transactions**,  
ShopEase can significantly enhance profitability by:

- Restructuring fees for high-impact transaction types  
- Improving transparency on customer fees  
- Offering discounts for digital wallet usage (higher-margin transactions)

---

## 🧠 Conclusion (Improved & More Convincing)

1. **Agents drive the business** — improving their fee experience will create the largest positive impact.
2. **Targeted fee optimization**—not across-the-board changes—will yield the best financial results.
3. **High-fee deterrence is real**, so pricing must balance revenue generation with customer retention.
4. **Data-driven fee restructuring** could unlock new revenue, improve user satisfaction, and increase transaction volume.

---

## 🚀 Why This Is a Strong Power BI Story (For Global Talent)

This project demonstrates:

- End-to-end system design  
- An enterprise-level BI model  
- Strong business thinking  
- Clear communication of insights  
- Application of analytics to real-world cost optimization  
- Leadership in defining the analytical narrative  


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

##          ETL Process
- The full ETL process code is in the file name Tranformation_pipe_line_code.R

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


