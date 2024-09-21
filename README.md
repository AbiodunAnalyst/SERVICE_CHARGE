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
### Problem: The project looks at the impact of various service fee structures on user behavior.
---
### Analysis Process

##### ETL Process for Transaction Data Analysis
In this case study, we follow the ETL (Extract, Transform, Load) process to analyze transaction 
data, using various tools such as RStudio, PostgreSQL, and Power BI to create insightful reports.

##### Step 1: Extract Data
The first step in the ETL process involves extracting the raw transaction data 
from a CSV files.

##### Step 2: Transform Data
Once the data is extracted, the next step is to clean and transform the data for analysis.
Transformation Code is attached in file name Enforca_Solution.R


##### Step 3: Load Data
Once the data is transformed, it needs to be loaded into PostgreSQL for storage and further 
reporting. The transformed data is sent to a PostgreSQL database using RStudio's database 
connection libraries such as RPostgres.


##### Step 4: Reporting with Power BI
With the transformed data now stored in PostgreSQL, the final step is to create reports and 
visualizations using Power BI. Power BI connects directly to the PostgreSQL database using 
the PostgreSQL connector.

##### Model
<img width="614" alt="image" src="https://github.com/user-attachments/assets/d548e3c1-31a9-4210-9128-dbb7f2f71667">

### Solution
<img width="736" alt="image" src="https://github.com/user-attachments/assets/9966bcc1-aa1c-4aca-a5f5-38da46cac15f">



### Insight
The lower the service fee, the higher the transaction volume
Service fees of 110 contribute the second highest total amount with moderate transaction volume
Service fees of  50 contribute significant amount to total amount with low transaction volume
Service fees of  20 contribute the highest amount to total amount with significant transaction volume
Service fees of  0.55 contribute significant amount to total amount with second highest transaction volume
Service fees of 0 contribute low amount to total amount with highest transaction volume


The above insight will help the organization to make decisions about designing and adjusting pricing models that maximize transaction volume and profitability and direct focus to the segment of customers that contribute more profit to the business



