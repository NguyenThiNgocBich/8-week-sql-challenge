
--1. Create Tables
use master
    go
    create database session1
    use session1
    go
 -- Create the color table
	CREATE TABLE color (
	id INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(50) NOT NULL,
	extra_fee DECIMAL(10, 2) DEFAULT 0.00
	);

	-- Create the customer table
	CREATE TABLE customer (
	id INT PRIMARY KEY IDENTITY(1,1),
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	favorite_color_id INT,
	FOREIGN KEY (favorite_color_id) REFERENCES color(id)
	);

	-- Create the category table
	CREATE TABLE category (
		id INT PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(50) NOT NULL,
		parent_id INT,
		FOREIGN KEY (parent_id) REFERENCES category(id)
	);

	-- Create the clothing table
	CREATE TABLE clothing (
		id INT PRIMARY KEY IDENTITY(1,1),
		name VARCHAR(50) NOT NULL,
		size CHAR(3) CHECK (size IN ('S', 'M', 'L', 'XL', '2XL', '3XL')),
		price DECIMAL(10, 2) NOT NULL,
		color_id INT,
		category_id INT,
		FOREIGN KEY (color_id) REFERENCES color(id),
		FOREIGN KEY (category_id) REFERENCES category(id)
	);

	-- Create the clothing_order table
	CREATE TABLE clothing_order (
		id INT PRIMARY KEY IDENTITY(1,1),
		customer_id INT,
		clothing_id INT,
		items INT NOT NULL,
		order_date DATE NOT NULL,
		FOREIGN KEY (customer_id) REFERENCES customer(id),
		FOREIGN KEY (clothing_id) REFERENCES clothing(id)
	);

	-- Insert data into the color table
	INSERT INTO color (name, extra_fee) VALUES
	('Red', 5.00),
	('Blue', 0.00),
	('Green', 3.00),
	('Yellow', 2.50),
	('Black', 1.00);

	-- Insert data into the customer table
	INSERT INTO customer (first_name, last_name, favorite_color_id) VALUES
	('John', 'Doe', 1),
	('Jane', 'Smith', 2),
	('Emily', 'Johnson', 3),
	('Michael', 'Brown', 4),
	('Sarah', 'Davis', 5);

	-- Insert data into the category table
	INSERT INTO category (name, parent_id) VALUES
	('Men', NULL),
	('Women', NULL),
	('Kids', NULL),
	('T-Shirts', 1),
	('Jeans', 2);

	-- Insert data into the clothing table
	INSERT INTO clothing (name, size, price, color_id, category_id) VALUES
	('Men T-Shirt', 'M', 20.00, 1, 4),
	('Women Jeans', 'L', 50.00, 2, 5),
	('Kids T-Shirt', 'S', 15.00, 3, 3),
	('Men Jeans', 'XL', 55.00, 4, 1),
	('Women T-Shirt', '2XL', 25.00, 5, 2);

	-- Insert data into the clothing_order table
	INSERT INTO clothing_order (customer_id, clothing_id, items, order_date) VALUES
	(1, 1, 2, '2024-07-01'),
	(2, 2, 1, '2024-07-02'),
	(3, 3, 3, '2024-07-03'),
	(4, 4, 2, '2024-07-04'),
	(5, 5, 1, '2024-07-05');


  --2. List All Clothing Items
  --Display the name of clothing items (name the column clothes), their color (name the column color), and the last name and first name of the customer(s) who bought this apparel in 
  --their favorite color. Sort rows according to color, in ascending order.

	SELECT 
		c.name AS clothes,
		clr.name AS color,
		cust.last_name,
		cust.first_name
	FROM 
		clothing c
	JOIN 
		color clr ON c.color_id = clr.id
	JOIN 
		clothing_order co ON c.id = co.clothing_id
	JOIN 
		customer cust ON co.customer_id = cust.id
	WHERE 
		c.color_id = cust.favorite_color_id
	ORDER BY 
		clr.name ASC;

   --3. Get All Non-Buying Customers
   --Select the last name and first name of customers and the name of their favorite color for customers with no purchases.

	SELECT 
		cust.last_name,
		cust.first_name,
		clr.name AS favorite_color
	FROM 
		customer cust
	LEFT JOIN 
		color clr ON cust.favorite_color_id = clr.id
	LEFT JOIN 
		clothing_order co ON cust.id = co.customer_id
	WHERE 
		co.id IS NULL;

   --4. Select All Main Categories and Their Subcategories
   --Select the name of the main categories (which have a NULL in the parent_id column) and the name of their direct subcategory (if one exists). Name the first column category 
   --and the second column subcategory.

	SELECT 
		main_cat.name AS category,
		sub_cat.name AS subcategory
	FROM 
		category main_cat
	LEFT JOIN 
		category sub_cat ON main_cat.id = sub_cat.parent_id
	WHERE 
		main_cat.parent_id IS NULL;

