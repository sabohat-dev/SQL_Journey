/*
Welcome to my learning journey :)
Sabohat Hamrokhulova 
Linkedin: sabohat-dev
Telegram: @famdev
Email: sabohat.dev@gmail.com
*/
-- Creating the database:
CREATE DATABASE [Library]
GO
USE [Library]

-- Creating the tables:
CREATE TABLE Author 
(
	AuthorID INT,
	AuthorName VARCHAR(30),
	Age TINYINT,
	NoBooksPublished BIT, 
	DOB DATE
)

CREATE TABLE Book 
(
	BookID INT,
	BookName VARCHAR(40),
	AuthorID INT,
	CopiesSold INT
)

CREATE TABLE Members 
(
	PersonID INT,
	PersonName VARCHAR(30),
	Age TINYINT,
)

CREATE TABLE Reservations 
(
	ReservationID INT,
	BookID INT,
	PersonID INT
)

-- Adding Primary and Foreign keys:
ALTER TABLE Author ALTER COLUMN AuthorID INT NOT NULL;
GO
ALTER TABLE Author ADD CONSTRAINT PK_AuthorID Primary Key(AuthorID);

ALTER TABLE Book ALTER COLUMN BookID INT NOT NULL;
GO
ALTER TABLE Book ADD CONSTRAINT PK_BookID Primary Key(BookID);
ALTER TABLE Book ADD CONSTRAINT FK_AuthorID Foreign Key (AuthorID) References Author(AuthorID);

ALTER TABLE Members ALTER COLUMN PersonID INT NOT NULL;
GO
ALTER TABLE Members ADD CONSTRAINT PK_PersonID Primary Key(PersonID);

ALTER TABLE Reservations ALTER COLUMN ReservationID INT NOT NULL;
GO
ALTER TABLE Reservations ADD CONSTRAINT PK_ReservationID Primary Key(ReservationID);
ALTER TABLE Reservations ADD CONSTRAINT FK_BookID Foreign Key (BookID) References Book(BookID);
ALTER TABLE Reservations ADD CONSTRAINT FK_PersonID Foreign Key (PersonID) References Members(PersonID);

-- Inserting the data into the tables:
INSERT INTO Author
VALUES  (1, 'J. K. Rowling', 57, 0, '1965-07-31'),
		(2, 'J. R. R. Tolkien', NULL, 0, '1892-01-03'),
		(3, 'George R. R. Martin', 74, 0, '1948-09-20'),
		(4, 'Sam Black', 32, 1, '1991-03-13'),
		(5, 'Andrzej Sapkowski', 74, 0, '1948-06-21')

INSERT INTO Book
VALUES  (1, 'Harry Potter and the Sorcerer''s Stone', 1, 215),
		(2, 'The Lord of the Rings', 2, 112),
		(3, 'The Hobbit', 2, 59),
		(4, 'A Game of Thrones', 3, 284),
		(5, 'The Last Wish', 5, 73)

INSERT INTO Members
VALUES  (1, 'Mason Mount', 24),
		(2, 'Ben Chilwell', 26),
		(3, 'Reece James', 23),
		(4, 'Conor Gallagher', 23),
		(5, 'Lewis Hall', 18)

INSERT INTO Reservations
VALUES  (1, 4, 1),
		(2, 2, 3),
		(3, 5, 4),
		(4, 1, 5),
		(5, 4, 2)

-- Select statements:
SELECT * FROM Author
SELECT * FROM Book
SELECT * FROM Members
SELECT * FROM Reservations


------------------------------------------------------------------------------------------
USE AdventureWorks2019

SELECT * FROM [Production].[Product]
SELECT * FROM [Sales].[SalesOrderDetail]

-- 1) Find the details of the product which has been sold the most:
-- Option 1:
SELECT Sub.TotalOrderQty, P.* FROM 
(SELECT TOP 1 ProductID, Sum(OrderQty) AS TotalOrderQty 
FROM [Sales].[SalesOrderDetail]
GROUP BY ProductID
ORDER BY TotalOrderQty Desc) AS Sub,
[Production].[Product] P
WHERE P.ProductID = Sub.ProductID

-- Option 2:
SELECT * FROM [Production].[Product]
WHERE ProductID IN
(
	(SELECT TOP 1 ProductID
	FROM [Sales].[SalesOrderDetail]
	GROUP BY ProductID
	ORDER BY Sum(OrderQty) Desc)
)	

-- 2) Find the product with the highest price (ListPrice):
-- Option 1:
SELECT P.* FROM
[Production].[Product] P,
(SELECT TOP 1 *
FROM [Production].[Product]
ORDER BY ListPrice Desc) AS Sub
WHERE P.ListPrice = Sub.ListPrice

-- Option 2:
SELECT * FROM
[Production].[Product]
WHERE ListPrice IN
(
	(SELECT Max(ListPrice) AS MaxListPrice
	FROM [Production].[Product])
)

-- 3) Find the product which grossed highest revenue:
-- Option 1:
SELECT Sub.TotalRevenue, P.* FROM
	(SELECT TOP 1 ProductID, Sum(LineTotal) AS TotalRevenue
	FROM [Sales].[SalesOrderDetail]
	GROUP BY ProductID
	ORDER BY TotalRevenue Desc) AS Sub,
[Production].[Product] P
WHERE P.ProductID = Sub.ProductID

-- Option 2:
SELECT * FROM [Production].[Product]
WHERE ProductID IN 
(
	SELECT TOP 1 ProductID
	FROM [Sales].[SalesOrderDetail]
	GROUP BY ProductID
	ORDER BY Sum(LineTotal) Desc
)

-- 4) Find the average sale for each month:
SELECT Year(ModifiedDate) AS [Year], Month(ModifiedDate) AS [Month], Avg(LineTotal) AS [AvgSale] 
FROM [Sales].[SalesOrderDetail]
GROUP BY Year(ModifiedDate), Month(ModifiedDate)
ORDER BY Year(ModifiedDate), Month(ModifiedDate)

-- 5) Find the details of the second highest selling product:
-- Option 1:
SELECT Sub2.TotalOrderQty, P.* FROM 
	(SELECT TOP 1 * FROM 
		(SELECT TOP 2 ProductID, Sum(OrderQty) AS TotalOrderQty 
		FROM [Sales].[SalesOrderDetail]
		GROUP BY ProductID
		ORDER BY TotalOrderQty Desc) AS Sub
	ORDER BY TotalOrderQty Asc) AS Sub2,
[Production].[Product] P
WHERE P.ProductID = Sub2.ProductID

-- Option 2:
SELECT * FROM [Production].[Product]
WHERE ProductID IN
(
	(SELECT TOP 1 ProductID FROM
		(SELECT TOP 2 ProductID, Sum(OrderQty) AS TotalOrderQty 
		FROM [Sales].[SalesOrderDetail]
		GROUP BY ProductID
		ORDER BY Sum(OrderQty) Desc) AS Sub
	ORDER BY TotalOrderQty Asc)
)			

-- 6) Find the products that have not made any sale yet:
SELECT * FROM [Production].[Product]
WHERE ProductID NOT IN (Select ProductID FROM [Sales].[SalesOrderDetail])
--------------------------------------------------------------------------------------------

USE AdventureWorks2019

SELECT * FROM [Production].[Product]
SELECT * FROM [Sales].[SalesOrderDetail]

-- 1) Using join find the details of product and the linetotal against them from sales(saleorderdetail) table:
SELECT P.*, S.LineTotal
FROM [Production].[Product] AS P
JOIN [Sales].[SalesOrderDetail] AS S 
ON P.ProductID = S.ProductID

-- 2) Include product name in sales table along with sales details:
SELECT P.Name, S.*
FROM [Production].[Product] AS P
JOIN [Sales].[SalesOrderDetail] AS S 
ON P.ProductID = S.ProductID

-- 3) Include product name and colour of product along with sales details:
SELECT P.Name, P.Color, S.*
FROM [Production].[Product] AS P
JOIN [Sales].[SalesOrderDetail] AS S 
ON P.ProductID = S.ProductID

-- 4) Include UnitPrice and LinePrice along with productname, product colour and sales details, find the difference in 
-- unit price(sales table) and list price(product table):
SELECT P.Name, P.Color, S.*, ABS((S.UnitPrice - P.ListPrice)) AS DiffOfUPandLP -- Adding ABS function to prevent negative result (optional)
FROM [Production].[Product] AS P
JOIN [Sales].[SalesOrderDetail] AS S 
ON P.ProductID = S.ProductID
-------------------------------------------------------------------------------------------


USE AdventureWorks2019

SELECT * FROM [Production].[Product]
SELECT * FROM [Sales].[SalesOrderDetail]

--1) Find distinct productIDs that have made sales(select distinct productid after joining with sales).
SELECT Distinct P.ProductID
FROM [Production].[Product] P
JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID

--2) Find distinct ProductIds, and color that have made sales (select distinct productid, color after joining with sales).
SELECT Distinct P.ProductID, P.Color
FROM [Production].[Product] P
JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID

--3) Find productid, productname(ProductTable), Qty(sales table) and date of sale.
SELECT P.ProductID, P.Name, S.OrderQty, S.ModifiedDate
FROM [Production].[Product] P
JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID

--4) Find Products that belong exclusively to product table and have not made any sales, and the color is Silver.
SELECT P.*
FROM [Production].[Product] P
LEFT JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL AND P.Color = 'Silver'

--5) Find Products that belong exclusively to product table and have not made any sales and color is (red or black).
-- (hint put the or condition in brackets like => where (color = ‘Silver’ or color = ‘black’) and sales.productid is null). Try experimenting with these conditions.
SELECT P.*
FROM [Production].[Product] P
LEFT JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL AND (P.Color = 'Red' OR P.Color = 'Black')

--6) Find sum of prices of products from product table which have not made any sale sum(listPrice) after joining with sale.
SELECT Sum(listPrice) AS Sum_of_Prod_Prices
FROM [Production].[Product] P
LEFT JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL

--7) Find sum of prices of products from product table which have not made any sale sum(listPrice) after joining with sale and color is silver.
SELECT Sum(listPrice) AS Sum_of_Silver_Prod_Prices
FROM [Production].[Product] P
LEFT JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL AND P.Color = 'Silver'

--8) Find sum of prices of products from product table which have not made any sale sum(listPrice) after joining with sale and (color is silver or black).
SELECT Sum(listPrice) AS [Sum_of_Silver&Black_Prod_Prices]
FROM [Production].[Product] P
LEFT JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL AND (P.Color = 'Silver' OR P.Color = 'Black')

--9) Find sum of prices of products from product table which have made sale sum(listPrice) after joining with sale and color is silver.
SELECT Sum(listPrice) AS Sum_of_Silver_Prod_Prices
FROM [Production].[Product] P
JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
WHERE P.Color = 'Silver'
-----------------------------------------------------------------------------------------------------------

USE AdventureWorks2019

SELECT * FROM [Production].[Product]
SELECT * FROM [Sales].[SalesOrderDetail]

/* 1) Find the total sales each product have made (select productId, product Name, sum(linetotal)) 
Hint
a.	hint join with sales table
b.	group by productid, productname */
SELECT P.ProductID, P.Name, Sum(S.LineTotal) AS TotalProductSales
FROM [Production].[Product] P
JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
GROUP BY P.ProductID, P.Name
ORDER BY P.ProductID;

/* 2) Find the total sales made by product of a particular colour ( Select ProductId, ProductName, Color (Product Table), sum(lineTotal)(sales)
Hint : 
a.	Join with sales table
b.	Group by  produtcId, productname, color */
SELECT P.ProductID, P.Name, P.Color, Sum(S.LineTotal) AS TotalProductSales
FROM [Production].[Product] P
JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
GROUP BY P.ProductID, P.Name, P.Color
ORDER BY P.ProductID;

-- 3) Find Total Sales and number of items sold of a particular colour.
SELECT P.Color, Sum(S.LineTotal) AS TotalProductSales, Sum(S.OrderQty) AS TotalNumberSold
FROM [Production].[Product] P
JOIN [Sales].[SalesOrderDetail] S
ON P.ProductID = S.ProductID
GROUP BY P.Color;

-- 4) Find the product in a specific color which was sold the most.
WITH CTE1 AS
(
	SELECT P.ProductID, P.Color, Sum(S.OrderQty) AS TotalQtySold
	FROM [Production].[Product] P
	JOIN [Sales].[SalesOrderDetail] S
	ON P.ProductID = S.ProductID
	GROUP BY P.Color, P.ProductID
), CTE2 AS
(
	SELECT Color, Max(TotalQtySold) AS MaxQtySold
	FROM CTE1
	GROUP BY Color
)
SELECT C1.ProductID, C1.Color, MaxQtySold 
FROM CTE1 C1
JOIN CTE2 C2 ON C1.Color = C2.Color OR C1.Color IS NULL
WHERE TotalQtySold = MaxQtySold
ORDER BY MaxQtySold DESC;
----------------------------------------------------------------------------------

USE AdventureWorks2019

SELECT * FROM [Production].[Product]
/*
1. Create an Empty Product_copy table.(select * into product_copy from product; 
	then truncate table product_copy)
	a.	Write a stored procedure that would only insert data into product_copy table.
	given the data is not already present in the product_copy table.
	Hint: Use left join to and check for nulls to find if data already present.
	Use product Id in on condition. */

DROP TABLE IF EXISTS Product_copy
SELECT * INTO Product_copy FROM Production.Product
TRUNCATE TABLE Product_copy

DROP PROCEDURE IF EXISTS Insert_Product_Data; 
GO
CREATE PROCEDURE Insert_Product_Data
AS
BEGIN
	SET Identity_Insert Product_copy	 ON
	INSERT INTO Product_copy	 ([ProductID], [Name], [ProductNumber], [MakeFlag], [FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint], [StandardCost], [ListPrice], [Size], [SizeUnitMeasureCode], [WeightUnitMeasureCode], [Weight], [DaysToManufacture], [ProductLine], [Class], [Style], [ProductSubcategoryID], [ProductModelID], [SellStartDate], [SellEndDate], [DiscontinuedDate], [rowguid], [ModifiedDate])
	SELECT P.[ProductID], P.[Name], P.[ProductNumber], P.[MakeFlag], P.[FinishedGoodsFlag], P.[Color], P.[SafetyStockLevel], P.[ReorderPoint], P.[StandardCost], P.[ListPrice], P.[Size], P.[SizeUnitMeasureCode], P.[WeightUnitMeasureCode], P.[Weight], P.[DaysToManufacture], P.[ProductLine], P.[Class], P.[Style], P.[ProductSubcategoryID], P.[ProductModelID], P.[SellStartDate], P.[SellEndDate], P.[DiscontinuedDate], P.[rowguid], P.[ModifiedDate] 
	FROM Production.Product P
	Left Join Product_copy PC
		ON P.ProductID = PC.ProductID
	WHERE PC.ProductID IS NULL
	SET Identity_Insert Product_copy	 OFF
END;
GO

Execute Insert_Product_Data;
GO
SELECT * FROM Product_copy;

/*
2. Write a Stored procedure that updates ListPrice into product_copy from product given product Id 
	already present in product table (Hint use update with Join). */

DROP PROCEDURE IF EXISTS Update_Product_ListPrice; 
GO
CREATE PROCEDURE Update_Product_ListPrice
AS
BEGIN
	UPDATE PC SET PC.ListPrice = P.ListPrice
	FROM Product_copy PC
	JOIN Production.Product P
	ON P.ProductID = PC.ProductID
END;

Execute Update_Product_ListPrice;
GO
SELECT * FROM Product_copy;

/*
3. Write a stored procedure that upserts(updates + inserts) data from product table into 
	product copy table using merge statement. Any new value should be reflected in product_copy 
	and any update in listprice should also get updated. */

DROP PROCEDURE IF EXISTS Upsert_Product_Data; 
GO
CREATE PROCEDURE Upsert_Product_Data
AS
BEGIN
	SET Identity_Insert Product_copy	 ON

	MERGE Product_copy AS TARGET
	USING Production.Product AS SOURCE
	ON SOURCE.ProductID = TARGET.ProductID

	WHEN NOT MATCHED BY TARGET
	THEN
	INSERT ([ProductID], [Name], [ProductNumber], [MakeFlag], [FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint], [StandardCost], [ListPrice], [Size], [SizeUnitMeasureCode], [WeightUnitMeasureCode], [Weight], [DaysToManufacture], [ProductLine], [Class], [Style], [ProductSubcategoryID], [ProductModelID], [SellStartDate], [SellEndDate], [DiscontinuedDate], [rowguid], [ModifiedDate])
	VALUES (SOURCE.[ProductID], SOURCE.[Name], SOURCE.[ProductNumber], SOURCE.[MakeFlag], SOURCE.[FinishedGoodsFlag], SOURCE.[Color], SOURCE.[SafetyStockLevel], SOURCE.[ReorderPoint], SOURCE.[StandardCost], SOURCE.[ListPrice], SOURCE.[Size], SOURCE.[SizeUnitMeasureCode], SOURCE.[WeightUnitMeasureCode], SOURCE.[Weight], SOURCE.[DaysToManufacture], SOURCE.[ProductLine], SOURCE.[Class], SOURCE.[Style], SOURCE.[ProductSubcategoryID], SOURCE.[ProductModelID], SOURCE.[SellStartDate], SOURCE.[SellEndDate], SOURCE.[DiscontinuedDate], SOURCE.[rowguid], SOURCE.[ModifiedDate])

	WHEN MATCHED 
	THEN UPDATE SET 
	TARGET.ListPrice = SOURCE.ListPrice;

	SET Identity_Insert Product_copy	 OFF
END;

Execute Upsert_Product_Data;
GO
SELECT * FROM Product_copy;
-------------------------------------------------------------------------------------------------


USE AdventureWorks2019

SELECT * FROM [Production].[Product]
SELECT * FROM [Sales].[SalesOrderDetail]

/*
1. ------SP-------------
	Create a copy of Product table
	add a column DiscountedListPrice (float)
	
	Write a stored Procedure that accepts discount percent: 
	calculates the discounted price of List Price 
	and update the discounted price in the newly added column DiscountedListPrice */

DROP TABLE IF EXISTS Product_copy
SELECT * INTO Product_copy FROM Production.Product

ALTER TABLE Product_copy
ADD DiscountedListPrice FLOAT

DROP PROCEDURE IF EXISTS SP_Discount_Percent; 
GO
CREATE PROCEDURE SP_Discount_Percent 
(
	@Percent INT
)
AS
BEGIN
	UPDATE Product_copy 
	SET DiscountedListPrice = (ListPrice - ListPrice * @Percent/100)
END;
GO

Execute SP_Discount_Percent @Percent = 50;
GO
SELECT * FROM Product_copy;

/*
2.--------FUNCTION--------
Create a (inline) function to which when name of product passed returns total sale(sum(linetotal)) made by that product. returns(productId, name, totalsale(sum(linetotal))) */

DROP FUNCTION IF EXISTS udf_ProdTotalSale
GO
CREATE FUNCTION udf_ProdTotalSale
(
	@ProdName NVARCHAR(50)
)
RETURNS TABLE AS
RETURN 
SELECT P.ProductID, P.Name, Sum(S.LineTotal) AS TotalSale
FROM Production.Product P
JOIN Sales.SalesOrderDetail S ON P.ProductID = S.ProductID
WHERE P.Name = @ProdName
GROUP BY P.ProductID, P.Name;
GO

SELECT * FROM udf_ProdTotalSale('Front Brakes')

/*
3--------write an inline function to Find LineTotal Of productid (passed as a parameter) from sales table, where qty > n (parameter)
-------------return sum(linetotal), nameofProduct and ProductId */

DROP FUNCTION IF EXISTS udf_SpecificProdTotalSale
GO
CREATE FUNCTION udf_SpecificProdTotalSale
(
	@ProdID INT,
	@ProdQty INT
)
RETURNS TABLE AS
RETURN 
SELECT P.ProductID, P.Name, Sum(S.LineTotal) AS TotalSale
FROM Production.Product P
JOIN Sales.SalesOrderDetail S ON P.ProductID = S.ProductID
WHERE P.ProductID = @ProdID AND S.OrderQty > @ProdQty
GROUP BY P.ProductID, P.Name;
GO

SELECT * FROM udf_SpecificProdTotalSale(776, 1)