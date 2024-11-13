-- Drop the database if it exists to avoid duplication (used only during development)
DROP DATABASE IF EXISTS `CustomerAnalyticsDB`;
CREATE DATABASE `CustomerAnalyticsDB`;
USE `CustomerAnalyticsDB`;

-- Customer Insights and Sales Analysis Project
-- This database tracks customers, their orders, products, and order details.

-- Drop existing tables if they exist (development only)
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- 1. Create the necessary tables

-- Table for Customers, including basic customer details
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,           -- Unique customer identifier
    first_name VARCHAR(50),                   -- Customer's first name
    last_name VARCHAR(50),                    -- Customer's last name
    email VARCHAR(100),                       -- Customer's email address
    join_date DATE                            -- The date the customer joined
);

-- Table for Products, tracking product details like price and category
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,           -- Unique product identifier
    product_name VARCHAR(100),               -- Name of the product
    category VARCHAR(50),                    -- Product category (e.g., electronics, furniture)
    price DECIMAL(10, 2)                      -- Product price (e.g., 799.99)
);

-- Orders table to store order details
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,             -- Unique order identifier
    customer_id INT REFERENCES Customers(customer_id),  -- Link to the customer placing the order
    order_date DATE,                         -- The date the order was placed
    status VARCHAR(20)                       -- Order status (e.g., 'delivered', 'shipped', 'returned')
);

-- Table for Order_Details, linking products to orders with their quantities
CREATE TABLE Order_Details (
    order_detail_id SERIAL PRIMARY KEY,      -- Unique identifier for each order detail
    order_id INT REFERENCES Orders(order_id), -- Link to the order
    product_id INT REFERENCES Products(product_id), -- Link to the product
    quantity INT                              -- Quantity of the product in this order
);

-- 2. Inserting Sample Data to Populate the Tables

-- Insert data for Customers (with diverse names and join dates)
INSERT INTO Customers (first_name, last_name, email, join_date)
VALUES 
    ('Alice', 'Smith', 'alice.smith@example.com', '2023-01-15'),
    ('Bob', 'Johnson', 'bob.johnson@example.com', '2023-02-10'),
    ('Charlie', 'Williams', 'charlie.williams@example.com', '2023-03-05'),
    ('David', 'Brown', 'david.brown@example.com', '2023-04-20'),
    ('Eve', 'Jones', 'eve.jones@example.com', '2023-05-12'),
    ('Frank', 'Miller', 'frank.miller@example.com', '2023-06-18'),
    ('Grace', 'Wilson', 'grace.wilson@example.com', '2023-07-22'),
    ('Hannah', 'Moore', 'hannah.moore@example.com', '2023-08-05');

-- Insert data for Products (expanded range of products with prices)
INSERT INTO Products (product_name, category, price)
VALUES 
    ('Laptop', 'Electronics', 799.99),
    ('Smartphone', 'Electronics', 499.99),
    ('Headphones', 'Accessories', 59.99),
    ('Monitor', 'Electronics', 199.99),
    ('Keyboard', 'Accessories', 29.99),
    ('Chair', 'Furniture', 89.99),
    ('Desk', 'Furniture', 150.00),
    ('Tablet', 'Electronics', 299.99),
    ('Mouse', 'Accessories', 15.99),
    ('Smartwatch', 'Electronics', 149.99),
    ('Sofa', 'Furniture', 499.99);

-- Insert data for Orders (more variety in order dates and statuses)
INSERT INTO Orders (customer_id, order_date, status)
VALUES 
    (1, '2023-03-01', 'delivered'),
    (1, '2023-05-15', 'shipped'),
    (2, '2023-06-05', 'delivered'),
    (3, '2023-07-20', 'returned'),
    (4, '2023-08-10', 'delivered'),
    (5, '2023-08-20', 'shipped'),
    (6, '2023-09-12', 'delivered'),
    (7, '2023-09-25', 'delivered'),
    (8, '2023-10-03', 'shipped');

-- Insert data for Order_Details (linking products with orders and quantities)
INSERT INTO Order_Details (order_id, product_id, quantity)
VALUES 
    (1, 1, 1),
    (1, 3, 2),
    (2, 2, 1),
    (2, 5, 1),
    (3, 4, 1),
    (4, 6, 1),
    (5, 7, 2),
    (6, 1, 1),
    (7, 8, 1),
    (8, 9, 1),
    (8, 10, 2);

-- 3. Analytical Queries

-- Query 1: Find the top 3 customers by total spending
SELECT c.customer_id, c.first_name, c.last_name, SUM(od.quantity * p.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 3;

-- Query 2: List top 5 most popular products by quantity sold
SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_sold
FROM Products p
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC
LIMIT 5;

-- Query 3: Calculate monthly sales totals (with grouped date formatting)
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, 
       SUM(od.quantity * p.price) AS monthly_sales
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Query 4: Identify customers who have made multiple orders
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;

-- Query 5: Calculate the average order value
SELECT AVG(total_order_value) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(od.quantity * p.price) AS total_order_value
    FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) AS order_totals;

-- Query 6: Display total sales by product category
SELECT p.category, SUM(od.quantity * p.price) AS category_sales
FROM Products p
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY category_sales DESC;

-- Query 7: Find products that have never been ordered
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
WHERE od.order_id IS NULL;
