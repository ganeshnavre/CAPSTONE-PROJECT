# E-Commerce Sales Management System

# Project Overview:
Create an E-commerce Sales Management System using SQL to manage products, customers, orders, and transactions. This system will track customer orders, manage inventory, analyze sales, and store customer details.

# Key Components:**
**1) Database Schema Design:**
Identify the entities and relationships required.
Tables may include Users, Products, Orders, Order Details, Payments, etc.
# Steps to Complete the Project:
**Define the Problem Statement:**

The goal is to create a database that helps an e-commerce company manage its operations efficiently, providing real-time insights into sales, product availability, and customer activities.

**2) Design Database Schema:**
Create the following tables based on the project scope:

**Users Table:**
**Fields:** UserID, Username, FullName, Email, Password, UserRole
Stores information about users (customers and administrators).

**Products Table:**

**Fields:** ProductID, ProductName, Description, Price, StockQuantity, CategoryID
Stores the product catalog, including descriptions, pricing, and stock details.
Categories Table:

**Fields:** CategoryID, CategoryName
Stores product categories to classify products.
Orders Table:

**Fields:** OrderID, UserID, OrderDate, TotalAmount, OrderStatus
Stores details of customer orders.
OrderDetails Table:

**Fields:** OrderDetailID, OrderID, ProductID, Quantity, UnitPrice
Stores information on each product ordered in an order.
Payments Table:

**Fields:** PaymentID, OrderID, PaymentDate, PaymentAmount, PaymentMethod
Stores payment information related to orders.

**3) Create Tables:**
Example SQL schema creation for the Products table:

**CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);**

**4) Insert Sample Data:** 
Populate tables with sample data for testing.

**INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity, CategoryID)
VALUES (1, 'Laptop', 'Gaming Laptop', 1200.99, 50, 1);**

**5) Write SQL Queries:**
Implement basic and advanced SQL queries to solve common use cases.
# Example Queries:
**Retrieve all products in stock:**

**SELECT ProductName, StockQuantity 
FROM Products 
WHERE StockQuantity > 0;**
**Calculate total sales for a product:**

**SELECT ProductID, SUM(Quantity * UnitPrice) AS TotalSales
FROM OrderDetails
GROUP BY ProductID;**
List customers who placed more than 5 orders:

**SELECT Username, COUNT(OrderID) AS TotalOrders
FROM Orders 
JOIN Users ON Orders.UserID = Users.UserID
GROUP BY Username
HAVING COUNT(OrderID) > 5;**

**6) Database Constraints and Relationships:**
Enforce data integrity with constraints like Primary Key, Foreign Key, and Unique.
Define relationships between tables, ensuring proper linkage between users, products, and orders.
# Advanced Features:

**7) Triggers:**
Automatically update the stock quantity when a new order is placed.

**CREATE TRIGGER UpdateStock AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
   UPDATE Products
   SET StockQuantity = StockQuantity - NEW.Quantity
   WHERE ProductID = NEW.ProductID;
END;**

**8) Stored Procedures:**
Create a stored procedure to generate a sales report for a given date range.

**CREATE PROCEDURE SalesReport (IN startDate DATE, IN endDate DATE)
BEGIN
   SELECT OrderID, TotalAmount
   FROM Orders
   WHERE OrderDate BETWEEN startDate AND endDate;
END;**

**9) Views:**
Create a view to simplify access to customer order details.

**CREATE VIEW CustomerOrders AS
SELECT Users.Username, Orders.OrderID, Orders.OrderDate, Orders.TotalAmount
FROM Orders
JOIN Users ON Orders.UserID = Users.UserID;**

# Project Features:

**CRUD Operations:**
Create, Read, Update, and Delete operations on products, users, and orders.

**Order Management:**
Track orders, update statuses (e.g., delivered, pending), and handle payments.

**Inventory Control:**
Automatically reduce stock when orders are placed and send alerts for low stock levels.

**Reports:**
Generate sales, order, and inventory reports using SQL queries.

# Project Deliverables:

**ER Diagram:** Visualize the schema and relationships between tables.

**SQL Code:** Include table creation scripts, sample data inserts, and complex query examples.

**Documentation:** Explain the schema design, use cases, and how to use the SQL queries.

**Presentation:** Show a demo of SQL queries solving key business operations (e.g., retrieving sales reports, user orders).


