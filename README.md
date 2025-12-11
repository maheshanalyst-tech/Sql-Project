# SQL-Project
📊 MySQL Capstone Project – E-Commerce Customer Churn Analysis

This project focuses on analyzing customer churn for an E-Commerce business using MySQL. It includes data cleaning, transformation, exploration, and business insights extracted from SQL queries.

📁 Project Overview

Customer churn is a major problem for e-commerce platforms, impacting revenue and long-term customer loyalty.
In this project, we perform:

✔ Data Cleaning

✔ Handling Missing & Inconsistent Values

✔ Data Transformation

✔ Feature Creation

✔ Exploratory Data Analysis (EDA)

✔ Business-Driven Insights

✔ Additional Table Integration (Customer Returns)

The dataset used: customer_churn (stored in a MySQL database).

🛠 Technologies Used

MySQL 8+

SQL Queries (DDL + DML)

Joins, Grouping, Case Statements

Data Cleaning and Pre-processing operations

📂 Project Structure
📦 E-Commerce Customer Churn Analysis
 ┣ 📄 customer_churn.sql
 ┣ 📄 README.md

🧹 1. Data Cleaning
🔧 Missing Value Treatment

The dataset contained missing values in:

WarehouseToHome

HoursSpentOnApp

OrderAmountHikeFromlastYear

DaySinceLastOrder

Tenure

CouponUsed

OrderCount

Different techniques used:

Mean imputation for numerical columns

Mode imputation for categorical / frequency-based columns

❌ Outlier Removal

Rows where:

WarehouseToHome > 100

were removed.

🔄 2. Data Transformation
🔤 Column Renaming

PreferedOrderCat → PreferredOrderCat

HourSpendOnApp → HoursSpentOnApp

🆕 New Columns Created

ComplaintReceived → Yes/No

ChurnStatus → Active / Churned

🗑 Dropped Columns

Churn

Complain

📊 3. Exploratory Data Analysis (EDA)

Key analysis performed using SQL:

Churned vs Active customer distribution

Average tenure and cashback for churned customers

Complaint trends among churned customers

Device preference, payment behavior, and coupon usage

Category-wise customer time spent on app

Churn patterns based on warehouse distance

Marital status, city tier, and ordering behavior

High-value customer segmentation

Insights from customer returns dataset

🔍 4. Additional Dataset Integration – Customer Returns

A new table customer_returns was created and linked using JOIN to analyze:

Refund amounts

Return behavior of churned customers

Complaint + churn relationships

💡 Key Insights

Some major insights drawn from the analysis:

Customers with high complaints are more likely to churn.

City Tier has a significant influence on churn patterns.

Laptop & Accessory category shows notable churn in Tier-1 cities.

Customers spending fewer hours on the app churn more.

Credit Card is the most popular payment mode among active users.

Distance from warehouse influences churn (far distance → higher churn).

🧾 SQL Features Used

UPDATE, DELETE, ALTER TABLE

CASE WHEN

JOIN

GROUP BY, ORDER BY, LIMIT

Subqueries (correlated & non-correlated)

Derived tables

Aggregate functions (AVG, SUM, COUNT, MAX)

🚀 How to Use This Project

Import the SQL file into your MySQL environment:

SOURCE customer_churn.sql;


Make sure database ecomm exists.

Run queries step-by-step to understand the analysis.

Use the insights to build dashboards or ML churn prediction later.

📈 Future Enhancements

Build a Power BI / Tableau dashboard

Connect SQL results to Machine Learning models

Automate data cleaning scripts

Integrate real-time churn alerts

Create stored procedures for recurring analysis

👨‍💻 Author

Mahesh
E-Commerce Analytics & SQL Enthusiast
