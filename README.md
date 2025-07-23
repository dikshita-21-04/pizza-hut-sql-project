# 🍕 Pizza Hut Sales Analysis (SQL Project)

This project uses SQL to explore and analyze a fictional Pizza Hut sales dataset. The project includes database schema creation, data import from CSV, and a variety of SQL queries ranging from basic to advanced levels.

---

## 📁 Files Included

- `pizza_hut_project.sql` – Contains:
  - Table creation scripts
  - Data import (CSV)
  - SQL queries for analysis (basic, intermediate, advanced)

---

## 🧾 Database Schema

- **pizzas** – Details of each pizza (size, price, type)
- **pizza_types** – Pizza categories and ingredients
- **orders** – Order timestamps
- **order_details** – Pizzas in each order with quantities

---

## 🛠️ Technologies Used

- PostgreSQL
- SQL (DDL + DML + Analytical Queries)
- CSV data import using `COPY` command

---

## 🔍 SQL Analysis

---

### ✅ Basic Questions

1. Retrieve total number of orders placed
2. Calculate the total revenue generated from pizza sales  
3. Identify the highest-price pizza
4. Identify the most common pizza size ordered 
5. List the top 5 most ordered pizza types along with their quantities

---

### ⚙️ Intermediate Questions

1. Find the total quantity of each pizza category ordered
2. Determine the distribution of orders by hour of the day  
3. Category-wise distribution of pizzas available
4. Average number of pizzas ordered per day
5. Top 3 most ordered pizza types based on revenue

---

### 🔬 Advanced Questions

1. Calculate the percentage contribution of each pizza category to total revenue
2. Analyze the cumulative revenue generated over time
3. Top 3 most ordered pizza types based on revenue for each pizza category (two query methods provided)

---

## 🧪 How to Use

1. Run the schema and data loading queries in `pizza_hut_project.sql`.
2. Make sure to replace `COPY FROM 'C:\SQL Pizza Sales Project\...` with the path where your CSV files are stored.
3. Execute the SQL analysis queries directly in PostgreSQL.

---

## 👩‍💻 Author

Dikshita Waghamare


