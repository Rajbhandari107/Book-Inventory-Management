CREATE DATABASE InventoryDB;
USE InventoryDB;

-- Authors Table
CREATE TABLE Authors (
  AuthorID INT PRIMARY KEY AUTO_INCREMENT,
  AuthorName VARCHAR(100) NOT NULL
);

-- Categories Table
CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY AUTO_INCREMENT,
  CategoryName VARCHAR(50) UNIQUE NOT NULL
);

-- Books Table
CREATE TABLE Books (
  BookID INT PRIMARY KEY AUTO_INCREMENT,
  Title VARCHAR(150) NOT NULL,
  AuthorID INT NOT NULL,
  CategoryID INT,
  Price DECIMAL(10,2) NOT NULL,
  StockQuantity INT NOT NULL DEFAULT 0,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE CASCADE,
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL
);

-- Customers Table
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE NOT NULL
);

-- Orders Table (Fixed: OrderDate uses CURRENT_TIMESTAMP with DATETIME)
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerID INT NOT NULL,
  OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
  OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID INT NOT NULL,
  BookID INT NOT NULL,
  Quantity INT NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
  FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE
);

-- Sample Authors
INSERT INTO Authors (AuthorName) VALUES
('George Orwell'), ('J.K. Rowling'), ('Paulo Coelho'), ('Dan Brown'), 
('J.R.R. Tolkien'), ('Chetan Bhagat'), ('Haruki Murakami'), 
('Stephen King'), ('Agatha Christie'), ('Mark Manson'), 
('Khaled Hosseini'), ('Chinua Achebe'), ('Yuval Noah Harari'), 
('Jane Austen'), ('Ernest Hemingway');

-- Sample Categories
INSERT INTO Categories (CategoryName) VALUES
('Self-help'), ('Mystery'), ('Fantasy'), ('Romance'), 
('Science'), ('Thriller'), ('Philosophy'), ('Adventure');

-- Sample Books
INSERT INTO Books (Title, AuthorID, CategoryID, Price, StockQuantity) VALUES
('Harry Potter and the Sorcerer''s Stone', 2, 3, 399.99, 50),
('The Da Vinci Code', 4, 6, 349.50, 40),
('The Hobbit', 5, 3, 280.75, 35),
('Five Point Someone', 6, 1, 199.99, 60),
('Norwegian Wood', 7, 4, 320.00, 25),
('The Shining', 8, 2, 360.00, 20),
('Murder on the Orient Express', 9, 2, 270.00, 50),
('The Subtle Art of Not Giving a F*ck', 10, 1, 310.00, 55),
('A Thousand Splendid Suns', 11, 4, 290.00, 30),
('Things Fall Apart', 12, 7, 275.00, 30),
('Sapiens', 13, 5, 450.00, 25),
('Pride and Prejudice', 14, 4, 299.99, 40),
('The Old Man and the Sea', 15, 7, 220.00, 35),
('Harry Potter and the Chamber of Secrets', 2, 3, 420.00, 45),
('The Alchemist', 3, 8, 250.00, 60),
('The Lost Symbol', 4, 6, 320.00, 30);

-- Sample Customers
INSERT INTO Customers (FirstName, LastName, Email) VALUES
('Himal', 'Chaudhary', 'himal@example.com'),
('John', 'Smith', 'john.smith@example.com'),
('Emily', 'Johnson', 'emily.j@example.com'),
('Michael', 'Williams', 'michael.w@example.com'),
('Sarah', 'Brown', 'sarah.b@example.com'),
('David', 'Jones', 'david.j@example.com'),
('Jennifer', 'Garcia', 'jennifer.g@example.com'),
('Robert', 'Miller', 'robert.m@example.com'),
('Lisa', 'Davis', 'lisa.d@example.com'),
('James', 'Rodriguez', 'james.r@example.com');

-- Sample Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2023-01-01 10:00:00', 499.98), (2, '2023-01-15 11:30:00', 670.00),
(3, '2023-02-20 09:45:00', 540.00), (4, '2023-03-10 14:15:00', 810.00),
(5, '2023-04-05 16:20:00', 290.00), (6, '2023-05-12 13:00:00', 640.00),
(7, '2023-06-18 10:10:00', 380.00), (8, '2023-07-22 17:00:00', 520.00),
(9, '2023-08-30 12:30:00', 700.00), (10, '2023-09-14 15:00:00', 450.00);

-- Sample OrderDetails
INSERT INTO OrderDetails (OrderID, BookID, Quantity, Price) VALUES
(1, 1, 1, 399.99), (1, 2, 1, 349.50),
(2, 3, 1, 280.75), (2, 4, 1, 199.99),
(3, 5, 1, 320.00), (3, 6, 1, 360.00),
(4, 7, 1, 270.00), (4, 8, 1, 310.00),
(5, 9, 1, 290.00),
(6, 10, 1, 275.00), (6, 11, 1, 450.00),
(7, 12, 1, 299.99),
(8, 13, 1, 220.00), (8, 14, 1, 420.00),
(9, 15, 1, 250.00), (9, 16, 1, 320.00),
(10, 1, 1, 399.99);

-- Views
CREATE VIEW BooksWithAuthors AS
SELECT 
    b.BookID, b.Title, a.AuthorName, c.CategoryName, 
    b.Price, b.StockQuantity
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
LEFT JOIN Categories c ON b.CategoryID = c.CategoryID;

CREATE VIEW CustomerOrders AS
SELECT 
    o.OrderID, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderDate, o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

CREATE VIEW DetailedOrderItems AS
SELECT 
    od.OrderDetailID, o.OrderDate, 
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer,
    b.Title AS BookTitle, od.Quantity, od.Price,
    (od.Quantity * od.Price) AS Total
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Books b ON od.BookID = b.BookID
JOIN Customers c ON o.CustomerID = c.CustomerID;

CREATE VIEW LowStockBooks AS
SELECT BookID, Title, StockQuantity AS Stock
FROM Books
WHERE StockQuantity <= 5;

--  ------------------------------------------------------------------------ Triggers
DELIMITER //
CREATE TRIGGER update_total_amount
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
  UPDATE Orders
  SET TotalAmount = (
    SELECT SUM(Quantity * Price)
    FROM OrderDetails
    WHERE OrderID = NEW.OrderID
  )
  WHERE OrderID = NEW.OrderID;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER reduce_book_stock
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
  UPDATE Books
  SET StockQuantity = StockQuantity - NEW.Quantity
  WHERE BookID = NEW.BookID;
END;
//
DELIMITER ;

-- ------------------------------------------------------------------------Functions
DELIMITER //
CREATE FUNCTION GetBookStock(bookId INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE stock INT;
  SELECT StockQuantity INTO stock FROM Books WHERE BookID = bookId LIMIT 1;
  RETURN stock;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetBookSales(bookId INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(Quantity * Price) INTO total
  FROM OrderDetails
  WHERE BookID = bookId;
  RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- Final checks
SHOW TABLES;

SELECT * FROM Authors;
SELECT * FROM Categories;
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;

SELECT * FROM BooksWithAuthors;
SELECT * FROM CustomerOrders;
SELECT * FROM DetailedOrderItems;

SHOW triggers;

SELECT GetBookStock(1);       -- Returns stock for book with BookID = 1
SELECT GetBookSales(1);       -- Returns total sales revenue for book with BookID = 1