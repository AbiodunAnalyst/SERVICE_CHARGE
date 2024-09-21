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
  In this project, we follow the ETL (Extract, Transform, Load) process to analyze transaction data, using various tools such as RStudio, PostgreSQL, and Power BI to create 
  insightful reports.
---
#### Step 1: Extract Data
##### The first step in the ETL process involves extracting the raw transaction data from a CSV files.
---
#### Step 2: Transform Data
  Once the data is extracted, the next step is to clean and transform the data for analysis. Transformation Code is attached in file name Enforca_Solution.R
---
#### Step 3: Load Data
  Once the data is transformed, it needs to be loaded into PostgreSQL for storage and further reporting. The transformed data is sent to a PostgreSQL database using 
  RStudio's database connection libraries such as RPostgres.
---
#### Step 4: Reporting with Power BI
  With the transformed data now stored in PostgreSQL, the final step is to create reports and visualizations using Power BI. Power BI connects directly to the PostgreSQL 
  database using the PostgreSQL connector.
---
### Model
<img width="614" alt="image" src="https://github.com/user-attachments/assets/d548e3c1-31a9-4210-9128-dbb7f2f71667">

---

### Solution
<img width="743" alt="image" src="https://github.com/user-attachments/assets/6d56faaa-a32a-492d-a9cc-e5971466b7f1">



---

### Insight
  1. Agents are the largest contributors to transaction volume, making them the most critical group to focus on when considering service fee adjustments or promotional   
     efforts. Bankers are underutilized in this system.
  2. Since commissions and withdrawals dominate transaction types, optimizing service fees for these categories will have the greatest impact on revenue. Less common 
     transaction types like P2P and Cable TV may be opportunities for growth if made more attractive with lower fees.
  3. Higher service fees seem to correlate with lower transaction volumes, which indicates that fees may be a deterrent for higher usage. Reducing fees or introducing tiered 
     pricing for high-volume users could increase overall transaction volume.
---

### Conclusion:
  1.  Agent-driven transactions: With agents forming the majority of users, focusing on optimizing their experience could have the most significant impact on transaction 
      volumes.
  2.  Service fee structure: A reduction in higher fees or creating incentives for frequently used transaction types could lead to increased activity across the platform.


