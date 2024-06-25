use master
create database Pizza_runner
go
use Pizza_runner
go
create table runners(
	runner_id int primary key,
	registration date
);
create table runner_order(
	order_id int primary key,
	runner_id int,
	pickup_time varchar(20),
	distance varchar(7),
	duration varchar(10),
	cancellation varchar(23),
	constraint fk_order_runners foreign key (runner_id) references runners (runner_id)
);
create table pizza(
	pizza_id int primary key,
	pizza_name nvarchar(30)
);
create table toppings(
	topping_id int primary key,
	topping_name nvarchar(30)
);
create table customer_order(
	customer_id int primary key,
	order_id int ,
	pizza_id int,
	topping_id int,
	exclusions varchar(20),
	extras varchar (20),
	order_date time
	constraint fk_order_customer foreign key(order_id) references runner_order(order_id),
	constraint fk_order_pizza foreign key(pizza_id) references pizza(pizza_id),
	constraint fk_order_topping foreign key (topping_id) references toppings(topping_id)
	
)
INSERT INTO runners (runner_id, registration) VALUES
  (1, '2024-06-20'),
  (2, '2024-05-15'),
  (3, '2024-04-10'),
  (4, '2024-03-05'),
  (5, '2024-02-01');
  go
INSERT INTO runner_order (order_id, runner_id, pickup_time, distance, duration, cancellation) VALUES
  (1, 1, '12:00 PM', '5 km', '30 min', 'No'),
  (2, 2, '01:00 PM', '3 km', '20 min', 'Yes'),
  (3, 3, '05:00 PM', '7 km', '45 min', 'No'),
  (4, 4, '10:00 AM', '2 km', '15 min', 'No'),
  (5, 5, '07:00 PM', '8 km', '50 min', 'No');
  go
  INSERT INTO pizza (pizza_id, pizza_name) VALUES
  (1, 'Meat Lovers'),
  (2, 'Vegetarian');
  go
INSERT INTO toppings (topping_id, topping_name) VALUES
  (1, 'Pepperoni'),
  (2, 'Ham'),
  (3, 'Pineapple'),
  (4, 'Mushrooms'),
  (5, 'Onions');
  go
  INSERT INTO customer_order (customer_id, order_id, pizza_id, topping_id, exclusions, extras, order_date) VALUES
  (1, 1, 1, 1, 'None', 'None', '11:30:00'),
  (2, 2, 1, 3, 'Onions', 'None', '13:15:00'),
  (3, 3, 2, 2, 'None', 'Extra Cheese', '17:45:00'),
  (4, 4, 2, 4, 'Pineapple', 'None', '09:00:00'),
  (5, 5, 2, 3, 'Ham', 'None', '10:45:00');
  ----1----
  select count(order_id) as total_order
  from customer_order
  ----2----
  select count( distinct order_id) as total_order
  from customer_order
  ----3----
  select runner_id,
		 count(order_id) as total_deliver 
  from runner_order
  where cancellation = 'No'
  group by runner_id
  ----4----
SELECT p.pizza_name,
	   COUNT(c.pizza_id) as total
FROM customer_order as c
JOIN runner_order AS r
  ON c.order_id = r.order_id
JOIN pizza AS p
  ON c.pizza_id = p.pizza_id
WHERE r.distance != '0 km'
GROUP BY p.pizza_name;
----5----
SELECT 
  c.customer_id, 
  p.pizza_name, 
  COUNT(p.pizza_name) AS order_count
FROM customer_order AS c
JOIN pizza AS p
  ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name;
----6----

WITH pizza_count_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.pizza_id) AS pizza_per_order
  FROM customer_order AS c
  JOIN runner_order AS r
    ON c.order_id = r.order_id
	WHERE r.distance != '0'
  GROUP BY c.order_id
) 

SELECT 
  MAX(pizza_per_order) AS pizza_count
FROM pizza_count_cte;

----7----

SELECT 
  c.customer_id,
  SUM(
    CASE WHEN c.exclusions <> 'None' OR c.extras <> 'None' THEN 1
    ELSE 0
    END) AS at_least_1_change,
  SUM(
    CASE WHEN c.exclusions = 'None' AND c.extras = 'None' THEN 1 
    ELSE 0
    END) AS no_change
FROM customer_order AS c
JOIN runner_order AS r
  ON c.order_id = r.order_id
WHERE r.distance != '0'
GROUP BY c.customer_id;

----8----
SELECT 
  c.customer_id,
  SUM(
    CASE WHEN c.exclusions <> 'None' and c.extras <> 'None' THEN 1
    ELSE 0
    END) AS at_least_1_change
FROM customer_order AS c
JOIN runner_order AS r
  ON c.order_id = r.order_id
WHERE r.distance != '0'
GROUP BY c.customer_id;

----9----
SELECT 
  DATEPART(HOUR, [order_date]) AS hour_of_day, 
  COUNT(order_id) AS pizza_count
FROM customer_order
GROUP BY DATEPART(HOUR, [order_date]);

----10----
SELECT 
  DATENAME(WEEKDAY, CAST('2021-01-01' AS datetime) + CAST(order_date AS datetime)) AS day_of_week, 
  COUNT(order_id) AS order_volume
FROM customer_order
GROUP BY DATENAME(WEEKDAY, CAST('2021-01-01' AS datetime) + CAST(order_date AS datetime));
       






