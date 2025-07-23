DROP TABLE IF EXISTS pizzas;
CREATE TABLE pizzas(
		pizza_id VARCHAR(50) PRIMARY KEY,
		pizza_type_id VARCHAR(50),
		size VARCHAR(10),
		price NUMERIC(10,2)
);


DROP TABLE IF EXISTS pizza_types;
CREATE TABLE pizza_types(
		pizza_type_id VARCHAR(50) NOT NULL,
		name VARCHAR(50),
		category VARCHAR(50),
		ingredients VARCHAR(500)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
		order_id INT PRIMARY KEY,
		date DATE,
		time TIME
);

CREATE TABLE order_details(
		order_details_id INT NOT NULL,
		order_id INT REFERENCES orders(order_id),
		pizza_id VARCHAR(50) REFERENCES pizzas(pizza_id),
		quantity INT
);

COPY
pizzas(pizza_id, pizza_type_id, size, price)
FROM 'C:\SQL Pizza Sales Project\pizzas.csv'
DELIMITER ','
CSV HEADER;

COPY
pizza_types(pizza_type_id, name, category, ingredients)
FROM 'C:\SQL Pizza Sales Project\pizza_types.csv'
DELIMITER ','
CSV HEADER;

COPY 
orders(order_id, date, time)
FROM 'C:\SQL Pizza Sales Project\orders.csv'
DELIMITER ','
CSV HEADER;

COPY 
order_details(order_details_id, order_id, pizza_id, quantity)
FROM 'C:\SQL Pizza Sales Project\order_details.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM pizzas;
SELECT * FROM pizza_types;
SELECT * FROM orders;
SELECT * FROM order_details;



-- Basic Questions

--1. Retrieve total number of orders placed
SELECT COUNT(order_id) AS total_orders
FROM orders;

--2. Calculate the total Revenue generated from pizza sales
SELECT SUM(p.price * od.quantity) AS total_revenue
FROM pizzas p 
JOIN order_details od
ON p.pizza_id = od.pizza_id;

--3. Identify the highest-price pizza
SELECT pt.name, p.price AS  highest_priced_pizza 
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name, p.price
ORDER BY p.price DESC LIMIT 1;

--4. Identify the most common pizza size ordered.
SELECT p.size, COUNT(od.order_details_id) AS common_pizza_size_ordered
FROM pizzas p 
JOIN order_details od
ON p.pizza_id = od. pizza_id
GROUP BY p.size
ORDER BY common_pizza_size_ordered DESC
LIMIT 1;

--5. List the top 5 most ordered pizza types along with their quantities
SELECT pt.name,  
	   SUM(od.quantity) AS quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name, p.pizza_type_id
ORDER BY quantity DESC
LIMIT 5;

-- Intermidiate Questions

SELECT * FROM pizzas;
SELECT * FROM pizza_types;
SELECT * FROM orders;
SELECT * FROM order_details;

--1. Join the necessary tables to find the total quantity of each pizza category ordered
SELECT pt.category, 
	   SUM(quantity) AS quantity
FROM pizza_types pt
JOIN pizzas p ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;

--2. Determine the distribution of orders by hour of the day
SELECT EXTRACT(HOUR FROM time) AS hour_of_day,
		COUNT(order_id) AS order_count
FROM orders
GROUP BY hour_of_day
ORDER BY hour_of_day ;

--3. Join relevant tables to find the category-wise distribution of pizzas.
SELECT category,
	   COUNT(name) AS pizza_count
FROM pizza_types
GROUP BY category;

--4. Group the orders by date and calculate the average number of pizzas ordered per day. (Uses SUBQUERIES)
SELECT AVG(quantity) AS avg_quantity FROM
(SELECT DISTINCT o.date, SUM(od.quantity) AS quantity
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY date);

--5. Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name,
	   SUM(p.price * od.quantity) AS revenue
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;


--Advance Questions
SELECT * FROM pizzas;
SELECT * FROM pizza_types;
SELECT * FROM orders;
SELECT * FROM order_details;

--1. Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.category, 
	   ROUND(SUM(od.quantity*p.price)*100 / (SELECT SUM(od.quantity*p.price) 
	   FROM pizzas p 
       JOIN order_details od ON p.pizza_id = od.pizza_id 
       JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id)) ||'%' AS revenue	
	   
FROM pizzas p 
JOIN order_details od ON p.pizza_id = od.pizza_id 
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category 
ORDER BY revenue DESC;

--2. Analyze the cumulative revenue generated over time
WITH daily_revenue AS(
SELECT o.date, SUM(od.quantity * p.price) AS daily_revenue
FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id
JOIN orders o ON o.order_id = od.order_id
GROUP BY o.date
ORDER BY o.date
)
SELECT date, daily_revenue,
	   SUM(daily_revenue) OVER(ORDER BY date) AS cumulative_revenue
FROM daily_revenue;

--3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name, category,revenue
FROM (
		SELECT pt.name, pt.category,
		SUM(od.quantity*p.price) AS revenue,
		RANK() OVER(PARTITION BY category ORDER BY SUM(od.quantity*p.price) DESC) AS rnk
	
FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name, pt.category
)ranked
WHERE rnk <= 3
ORDER BY category, revenue DESC;

--alternate answer
SELECT name,revenue FROM
(SELECT category, name, revenue,
RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
FROM
(SELECT pt.category, pt.name,
	   SUM(p.price * od.quantity) AS revenue
FROM pizzas p 
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category, pt.name) ) AS b
WHERE rn <= 3; 
