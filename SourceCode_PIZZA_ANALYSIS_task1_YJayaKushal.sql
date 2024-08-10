-- PIZZA ANALYSIS
-- task 1
-- finish by 30th 

Create database Pizza_analysis;
use Pizza_analysis;

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

-- Q1: The total number of order place
SELECT COUNT(*) AS total_orders
FROM orders;


-- Q2: The total revenue generated from pizza sales
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details as od
JOIN pizzas as p
 ON od.pizza_id = p.pizza_id;


-- Q3: The highest priced pizza.
SELECT * 
FROM pizzas
ORDER BY price DESC
LIMIT 1;


-- Q4: The most common pizza size ordered.
SELECT p.size, SUM(od.quantity) AS total_quantity
FROM order_details as od
JOIN pizzas as p 
ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity DESC
LIMIT 1;


-- Q5: The top 5 most ordered pizza types along their quantities.
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM order_details as od
JOIN pizzas as p ON od.pizza_id = p.pizza_id
JOIN pizza_types as pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;


-- Q6: The quantity of each pizza categories ordered.
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details as od
JOIN pizzas as p ON od.pizza_id = p.pizza_id
JOIN pizza_types as pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;


-- Q7: The distribution of orders by hours of the day.
SELECT EXTRACT(HOUR FROM ord.time) AS hour, COUNT(*) AS total_orders
FROM orders as ord
GROUP BY EXTRACT(HOUR FROM ord.time)
ORDER BY hour;


-- Q8: The category-wise distribution of pizzas.
SELECT pt.category, COUNT(*) AS total_pizzas
FROM pizzas as p
JOIN pizza_types as pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;


-- Q9: The average number of pizzas ordered per day.	
SELECT AVG(daily_orders) AS avg_pizzas_per_day
FROM (
    SELECT ord.date, SUM(od.quantity) AS daily_orders
    FROM orders as ord
    JOIN order_details as od ON ord.order_id = od.order_id
    GROUP BY ord.date
) subquery;


-- Q10: Top 3 most ordered pizza type base on revenue.
SELECT pt.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details as od
JOIN pizzas as p ON od.pizza_id = p.pizza_id
JOIN pizza_types as pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;


-- Q11: The percentage contribution of each pizza type to revenue.	
SELECT pt.name, 
       SUM(od.quantity * p.price) AS total_revenue,
       (SUM(od.quantity * p.price) / total.total_revenue) * 100 AS revenue_percentage
FROM order_details as od
JOIN pizzas as p ON od.pizza_id = p.pizza_id
JOIN pizza_types as pt ON p.pizza_type_id = pt.pizza_type_id
CROSS JOIN (
    SELECT SUM(od.quantity * p.price) AS total_revenue
    FROM order_details as od
    JOIN pizzas as p ON od.pizza_id = p.pizza_id
) total
GROUP BY pt.name, total.total_revenue;


-- Q12: The cumulative revenue generated over time.
SELECT ord.date, SUM(od.quantity * p.price) OVER (ORDER BY ord.date) AS cumulative_revenue
FROM orders as ord
JOIN order_details as od ON ord.order_id = od.order_id
JOIN pizzas as p ON od.pizza_id = p.pizza_id
ORDER BY ord.date;






-- Q13: The top 3 most ordered pizza type based on revenue for each pizza category.
SELECT pt.category, pt.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details as od
JOIN pizzas as p ON od.pizza_id = p.pizza_id
JOIN pizza_types as pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, pt.name
ORDER BY pt.category, total_revenue DESC
LIMIT 3;
