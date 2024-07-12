use master
create database session3 
go
use session3
go
-- Create the channels table
CREATE TABLE channels (
    id INT PRIMARY KEY IDENTITY(1,1),
    channel_name VARCHAR(255) NOT NULL
);

-- Create the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    registration_date DATE NOT NULL,
    channel_id INT,
    first_order_id INT,
    first_order_date DATE,
    last_order_id INT,
    last_order_date DATE,
    FOREIGN KEY (channel_id) REFERENCES channels(id)
);

-- Create the orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    ship_name VARCHAR(255) NOT NULL,
    ship_address VARCHAR(255) NOT NULL,
    ship_city VARCHAR(100) NOT NULL,
    ship_region VARCHAR(100),
    ship_postalcode VARCHAR(20) NOT NULL,
    ship_country VARCHAR(100) NOT NULL,
    shipped_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create the categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(255) NOT NULL,
    description TEXT
);

-- Create the products table
CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(255) NOT NULL,
    category_id INT,
    unit_price DECIMAL(10, 2) NOT NULL,
    discontinued BIT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Create the order_items table
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(5, 2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert data into channels table
INSERT INTO channels (channel_name) VALUES 
('Online'), 
('Referral'), 
('In-Store'), 
('Social Media'), 
('Direct Mail');

-- Insert data into customers table
INSERT INTO customers (email, full_name, address, city, region, postal_code, country, phone, registration_date, channel_id, first_order_id, first_order_date, last_order_id, last_order_date) VALUES 
('john.doe@example.com', 'John Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', '123-456-7890', '2024-01-15', 1, NULL, NULL, NULL, NULL),
('jane.smith@example.com', 'Jane Smith', '456 Maple Ave', 'Los Angeles', 'CA', '90001', 'USA', '987-654-3210', '2024-02-20', 2, NULL, NULL, NULL, NULL),
('alice.johnson@example.com', 'Alice Johnson', '789 Elm St', 'Chicago', 'IL', '60601', 'USA', '555-123-4567', '2024-03-10', 3, NULL, NULL, NULL, NULL),
('bob.brown@example.com', 'Bob Brown', '321 Oak St', 'Houston', 'TX', '77001', 'USA', '555-987-6543', '2024-04-05', 4, NULL, NULL, NULL, NULL),
('carol.white@example.com', 'Carol White', '654 Pine St', 'Phoenix', 'AZ', '85001', 'USA', '555-654-3210', '2024-05-25', 5, NULL, NULL, NULL, NULL);

-- Insert data into orders table
INSERT INTO orders (customer_id, order_date, total_amount, ship_name, ship_address, ship_city, ship_region, ship_postalcode, ship_country, shipped_date) VALUES 
(1, '2024-03-01', 619.98, 'John Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', '2024-03-02'),
(2, '2024-03-05', 29.98, 'Jane Smith', '456 Maple Ave', 'Los Angeles', 'CA', '90001', 'USA', '2024-03-06'),
(3, '2024-04-15', 49.99, 'Alice Johnson', '789 Elm St', 'Chicago', 'IL', '60601', 'USA', '2024-04-16'),
(4, '2024-05-10', 89.99, 'Bob Brown', '321 Oak St', 'Houston', 'TX', '77001', 'USA', '2024-05-11'),
(5, '2024-06-20', 119.99, 'Carol White', '654 Pine St', 'Phoenix', 'AZ', '85001', 'USA', '2024-06-21');

-- Update customers table with first and last order information
UPDATE customers SET first_order_id = 1, first_order_date = '2024-03-01', last_order_id = 1, last_order_date = '2024-03-01' WHERE customer_id = 1;
UPDATE customers SET first_order_id = 2, first_order_date = '2024-03-05', last_order_id = 2, last_order_date = '2024-03-05' WHERE customer_id = 2;
UPDATE customers SET first_order_id = 3, first_order_date = '2024-04-15', last_order_id = 3, last_order_date = '2024-04-15' WHERE customer_id = 3;
UPDATE customers SET first_order_id = 4, first_order_date = '2024-05-10', last_order_id = 4, last_order_date = '2024-05-10' WHERE customer_id = 4;
UPDATE customers SET first_order_id = 5, first_order_date = '2024-06-20', last_order_id = 5, last_order_date = '2024-06-20' WHERE customer_id = 5;

-- Insert data into categories table
INSERT INTO categories (category_name, description) VALUES 
('Electronics', 'Devices and gadgets'), 
('Books', 'All kinds of books'), 
('Clothing', 'Apparel for men, women, and children'), 
('Home Appliances', 'Various home appliances'), 
('Toys', 'Toys and games for children');

-- Insert data into products table
INSERT INTO products (product_name, category_id, unit_price, discontinued) VALUES 
('Smartphone', 1, 599.99, 0), 
('Laptop', 1, 999.99, 0), 
('Novel', 2, 19.99, 0), 
('T-Shirt', 3, 9.99, 0), 
('Blender', 4, 49.99, 0), 
('Action Figure', 5, 14.99, 0);

-- Insert data into order_items table
INSERT INTO order_items (order_id, product_id, unit_price, quantity, discount) VALUES 
(1, 1, 599.99, 1, 0.00), 
(1, 3, 19.99, 1, 0.00), 
(2, 4, 9.99, 2, 0.00), 
(3, 5, 49.99, 1, 0.00), 
(4, 2, 999.99, 1, 0.00), 
(5, 6, 14.99, 4, 0.00);

--2. List the Top 3 Most Expensive Orders

SELECT TOP 3
    o.order_id,
    c.full_name AS customer_name,
    o.total_amount
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
ORDER BY 
    o.total_amount DESC;

	--4. Compute the Running Total of Purchases per Customer
--	For each customer and their orders, show the following:
--	customer_id – the ID of the customer.
--	full_name – the full name of the customer.
--	order_id – the ID of the order.
--	order_date – the date of the order.
--	total_amount – the total spent on this order.
--	running_total – the running total spent by the given customer.


WITH CTE_CustomerOrders AS (
    SELECT 
        c.customer_id,
        c.full_name,
        o.order_id,
        o.order_date,
        o.total_amount,
        SUM(o.total_amount) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS running_total
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
)
SELECT 
    customer_id,
    full_name,
    order_id,
    order_date,
    total_amount,
    running_total
FROM 
    CTE_CustomerOrders
ORDER BY 
    customer_id, order_date;

--3. Compute Deltas Between Consecutive Orders
--	In this exercise, we're going to compute the difference between two consecutive orders from the same customer.Show the ID of the order (order_id), the ID 
--	of the customer (customer_id), the total_amount of the order, the total_amount of the previous order based on the order_date (name the column previous_value), 
--	and the difference between the total_amount of the current order and the previous order (name the column delta).