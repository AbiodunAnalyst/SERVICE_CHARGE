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
The project transforms raw CSV, Excel, and ZIP files into a structured **PostgreSQL data mart**, enriched with engineered features and visualized through an interactive **Power BI dashboard and BI App deployment**.

It demonstrates:

- Automated ingestion of multiple file formats  
- Robust data quality checks  
- Business-driven feature engineering  
- Relational database modelling  
- Insight generation for financial and operational teams  


---


## 📘 Project Background

ShopEase is a growing digital retail business with thousands of daily transactions processed across multiple channels.  
Every transaction attracts one or more service fees from the platform, banks, or third-party processors.  

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

## 💡 Power BI Solution and Streamlit App deployment

<img width="750" src="https://github.com/user-attachments/assets/6d56faaa-a32a-492d-a9cc-e5971466b7f1">

---

**Service_Charge_App** *[Service_Charge_App](https://servicecharge-vbifffsc9ydwrc4cnwfuyd.streamlit.app/)*

---

The dashboard answers ShopEase’s core business questions:

- *Where are service fees coming from?*  
- *Who is most affected by them?*  
- *What transactions drive the most costs?*  
- *Are users discouraged by high fees?*  
- *What time of day sees the most activity?*  

---

## 📊 Key Insights

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
With over **£184 million** processed and more than **11,000 transactions**,  
ShopEase can significantly enhance profitability by:

- Restructuring fees for high-impact transaction types  
- Improving transparency on customer fees  
- Offering discounts for digital wallet usage (higher-margin transactions)


