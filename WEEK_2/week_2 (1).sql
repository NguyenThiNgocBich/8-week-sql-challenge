-- STEP 1: Create Database Pizza_runner --
USE master
CREATE DATABASE Pizza_runner;
GO

USE Pizza_runner
GO
-- STEP 2: Create Table runners --
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER PRIMARY KEY,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
GO

-- STEP 3: Create Table runner_orders--
DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER PRIMARY KEY,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
  constraint fk_order_runners foreign key (runner_id) references runners (runner_id)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
 GO

 -- STEP 4: Create Table pizza_names--
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER PRIMARY KEY,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');
GO

-- STEP 5: Create Table pizza_recipes --
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER PRIMARY KEY,
  "toppings" NVARCHAR
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');
GO

-- STEP 6: Create Table pizza_toppingss --
DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER PRIMARY KEY,
  "topping_name" NVARCHAR
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
GO

 -- STEP 7: Create Table customer_orders--
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" VARCHAR(50)
  constraint fk_order_customer foreign key(order_id) references runner_orders(order_id),
  constraint fk_order_pizza foreign key(pizza_id) references pizza_names(pizza_id)
);
GO

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
 GO
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
       
--Case Study #2 Pizza Runner
--Solution - B. Runner and Customer Experience
--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
  DATEPART(WEEK, registration) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY DATEPART(WEEK, registration);

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH time_taken_cte AS
(
  SELECT 
    c.order_id, 
    c.order_date,
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_date, pickup_time)AS pickup_minutes
  FROM customer_order AS c
  JOIN runner_order AS r
    ON c.order_id = r.order_id
  WHERE r.distance !='0'
  GROUP BY c.order_id, c.order_date, r.pickup_time
)

SELECT 
  AVG(pickup_minutes) AS avg_pickup_minutes
FROM time_taken_cte
WHERE pickup_minutes > 1;

--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH prep_time_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.order_id) AS pizza_order, 
    c.order_date, 
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_date, r.pickup_time) AS prep_time_minutes
  FROM customer_order AS c
  JOIN runner_order AS r
    ON c.order_id = r.order_id
  WHERE r.distance != '0'
  GROUP BY c.order_id, c.order_date, r.pickup_time
)

SELECT 
  pizza_order, 
  AVG(prep_time_minutes) AS avg_prep_time_minutes
FROM prep_time_cte
WHERE prep_time_minutes > 1
GROUP BY pizza_order;

----4----

 WITH customer_distance_cte AS (
  SELECT 
    c.customer_id,
    AVG(CAST(SUBSTRING(r.distance, 1, LEN(r.distance) - 3) AS FLOAT)) AS avg_distance
  FROM customer_order AS c
  JOIN runner_order AS r
    ON c.order_id = r.order_id
  WHERE r.duration != '0'
  GROUP BY c.customer_id
)
SELECT 
  customer_id,
  avg_distance
FROM customer_distance_cte
ORDER BY avg_distance ASC;

--5. What was the difference between the longest and shortest delivery times for all orders?

	SELECT 
	order_id, duration
	FROM runner_order
	WHERE duration not like ' ';

--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- 7. What is the successful delivery percentage for each runner? 

	SELECT 
	runner_id,
	SUM(CASE 
	WHEN distance = '0' THEN '0'
	ELSE 1 
	END) * 100 / COUNT(*)
	AS success_percentage
	FROM runner_order
	GROUP by runner_id;

	--C. Ingredient Optimisation
	-- 1. What are the standard ingredients for each pizza?

SELECT
    pr.pizza_id,
    pt.topping_name
FROM pizza_recipes pr
JOIN pizza_toppings pt ON CHARINDEX(',' + CAST(pt.topping_id AS VARCHAR) + ',', ',' + REPLACE(pr.toppings, ' ', ',') + ',') > 0
ORDER BY pr.pizza_id;


	--2. What was the most commonly added extra?

WITH Toppings AS (
    SELECT
        pizza_id,
        CAST(value AS INTEGER) AS topping_id
    FROM pizza_recipes
    CROSS APPLY STRING_SPLIT(toppings, ',')
)
SELECT 
    t.topping_id, 
    pt.topping_name, 
    COUNT(t.topping_id) AS topping_count
FROM Toppings t 
JOIN pizza_toppings pt ON t.topping_id = pt.topping_id
GROUP BY t.topping_id, pt.topping_name
ORDER BY topping_count DESC;

-- 3. What was the most common exclusion?

WITH exclusions_topping AS (
    SELECT
  		value AS topping_id
    FROM customer_order
    CROSS APPLY STRING_SPLIT(exclusions, ',')
    WHERE exclusions IS NOT NULL AND exclusions != ''
)
SELECT 
	et.topping_id,
    pt.topping_name,
    COUNT(et.topping_id) AS the_most_common_exclusion
FROM exclusions_topping AS et
JOIN pizza_toppings pt ON et.topping_id = pt.topping_id
GROUP BY et.topping_id, pt.topping_name
ORDER BY the_most_common_exclusion DESC;

--D. Pricing and Ratings
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes --how much money has Pizza Runner made so far if there are no delivery fees?

WITH Toppings AS (
    SELECT 
      pr.pizza_id, 
      pt.topping_name
    FROM pizza_recipes pr
    CROSS APPLY STRING_SPLIT(pr.toppings, ',') AS toppings_split
    JOIN pizza_toppings pt ON pt.topping_id = toppings_split.value
)
SELECT 
  pizza_id, 
  STRING_AGG(topping_name, ', ') WITHIN GROUP(ORDER BY topping_name) AS toppings
FROM Toppings
GROUP BY pizza_id;

-- 2. Total revenue with an additional $1 charge for extras
WITH total_with_extras AS (
    SELECT
        order_id,
        SUM(
            CASE
                WHEN pizza_id = 1 THEN 12  
                WHEN pizza_id = 2 THEN 10  
                ELSE 0
            END
        ) + 
        SUM(
            CASE 
                WHEN (extras IS NOT NULL AND extras != '') THEN (LEN(extras) - LEN(REPLACE(extras, ',', '')) + 1) * 1
                ELSE 0 
            END
        ) AS money_total
    FROM customer_order
    GROUP BY order_id
)
SELECT 
    SUM(money_total) AS total_revenue  
FROM total_with_extras;


-- 3 Design new table for ratings for each successful customer order between 1 to 5.
CREATE TABLE customer_runner_rating (
    rating_id INT,
    order_id INT,
    customer_id INT,
    runner_id INT,
    rating INT,
    comment VARCHAR(255),
    rating_date DATETIME
 )
INSERT INTO customer_runner_ratings (rating_id, order_id, customer_id, runner_id, rating, comment, rating_date)
VALUES 
	(1, 1, 101, 1, 5, 'Great service, fast delivery!', '2021-01-01 18:30:00'),
	(2, 2, 101, 1, 4, 'Friendly runner, but a bit late.', '2021-01-01 19:30:00'),
	(3, 3, 102, 1, 5, 'Excellent service, highly recommend!', '2021-01-03 00:30:00'),
	(4, 4, 103, 2, 3, 'Food was cold, but the runner was nice.', '2021-01-04 14:30:00'),
	(5, 5, 104, 3, 5, 'Fast and efficient delivery!', '2021-01-08 21:30:00'),
	(6, 7, 105, 2, 4, 'Good communication, arrived on time.', '2021-01-08 22:00:00'),
	(7, 8, 102, 2, 5, 'Amazing service, will order again!', '2021-01-10 00:45:00'),
	(8, 9, 103, 2, 2, 'Late delivery, food was soggy.', '2021-01-10 12:00:00'),
	(9,10, 104, 1, 4, 'Good service, but forgot the extra sauce.', '2021-01-11 19:30:00');

	-- 4 Create a table which has the following information for successful deliveries?
SELECT
    c.customer_id,
    c.order_id,
    r.runner_id,
    cr.rating,
    c.order_date,
    r.pickup_time,
    DATEDIFF(MINUTE, c.order_date, r.pickup_time) AS time_between_order_and_pickup,
    r.duration AS delivery_duration, 
    ROUND((r.distance / TRY_CAST(r.duration AS FLOAT))* 60, 2) AS average_speed,
    COUNT(c.order_id) AS total_number_of_pizzas 
FROM customer_order c
JOIN runner_order r ON c.order_id = r.order_id
JOIN customer_runner_ratings cr ON c.order_id = cr.order_id
WHERE r.cancellation IS NULL OR r.cancellation = ''  
GROUP BY
    c.customer_id, c.order_id, r.runner_id, cr.rating, c.order_date, r.pickup_time, r.distance, r.duration;

-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
--    how much money does Pizza Runner have left over after these deliveries?

WITH total AS (
SELECT
c.order_id,
SUM(
CASE WHEN c.pizza_id = 1 THEN 12
WHEN c.pizza_id = 2 THEN 10
 ELSE 0 
END
 ) + 
SUM(
CASE WHEN c.extras IS NOT NULL AND c.extras != ''
THEN (LEN(c.extras) - LEN(REPLACE(c.extras, ',', '')) + 1)
ELSE 0 
END)
-SUM( CASE WHEN TRY_CAST(REPLACE(r.distance, ' km', '') AS float) IS NOT NULL
 THEN CAST(REPLACE(r.distance, ' km', '') AS float) * 3 / 10
ELSE 0 
END) AS money_total
FROM customer_order c
 JOIN runner_order r ON c.order_id = r.order_id
GROUP BY c.order_id
)
SELECT 
 ROUND(SUM(money_total), 2) AS total_revenue  
FROM total;





	
							
								
								
								
								

	

























	



					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						

