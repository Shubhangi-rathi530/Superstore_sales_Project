CREATE DATABASE superstore_project;
USE superstore_project;
SELECT DATABASE();
CREATE TABLE orders(
Order_ID VARCHAR(20),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID VARCHAR(50),
Customer_Name VARCHAR(100),
Segment VARCHAR(50),
Country_Region VARCHAR(100),
City VARCHAR(100),
State_Province VARCHAR(100),
Postal_Code VARCHAR(20),
Region VARCHAR(100),
Product_ID VARCHAR(100),
Category VARCHAR(100),
Sub_Category VARCHAR(100),
Product_Name VARCHAR(225),
Sales DECIMAL(10,4),
Quantity INT,
Discount DECIMAL(5,3),
Profit DECIMAL(10,4)
);
SHOW TABLES;
DESCRIBE orders;
USE superstore_project;
SELECT DATABASE();
SHOW TABLES;
DESCRIBE orders;
SELECT * FROM orders;
SHOW VARIABLES LIKE 'Local_infile';
SET GLOBAL local_infile = 1;

TRUNCATE TABLE orders;
LOAD DATA LOCAL INFILE 'C:/Users/Asus/Downloads/sample_-_superstore.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @Row_ID,
    Order_ID,
    @Order_Date,
    @Ship_Date,
    Ship_Mode,
    Customer_ID,
    Customer_Name,
    Segment,
    Country_Region,
    City,
    State_Province,
    Postal_Code,
    Region,
    Product_ID,
    Category,
    Sub_Category,
    Product_Name,
    Sales,
    Quantity,
    Discount,
    Profit
)
SET
    Order_Date = STR_TO_DATE(@Order_Date, '%d-%m-%Y'),
    Ship_Date = STR_TO_DATE(@Ship_Date, '%d-%m-%Y');
    SELECT COUNT(*) AS Total_rows
    FROM orders;
    SELECT * FROM orders
    LIMIT 5;
    SELECT COUNT(*) AS missing_order_date
    FROM orders
    WHERE Order_Date = NULL;
SELECT
COUNT(*) AS total_rows,
SUM(Order_id IS NULL) AS missing_order_id,
SUM(Order_Date IS NULL) AS missing_order_date,
SUM(Ship_Date IS NULL ) AS missing_ship_date,
SUM(Customer_Id IS NULL) AS missing_customer_id,
SUM(Sales IS NULL ) AS missing_sales,
SUM(Quantity IS NULL) AS missing_quantity,
SUM(Profit IS NULL) AS missing_profit
FROM orders;
SELECT Order_Id, Product_Id,
COUNT(*) AS occurences
FROM orders
GROUP BY Order_Id, Product_Id
HAVING COUNT(*) > 1;
SELECT
Order_Id,
Product_Id,
Order_Date,
Ship_Date,
Customer_Id,
Sales,
Quantity,
Discount,
Profit
FROM orders
WHERE (Order_Id,Product_Id) IN(
SELECT Order_Id, Product_Id
FROM orders
GROUP BY Order_Id, Product_Id
HAVING COUNT(*) > 1
)
ORDER BY Order_Id , Product_Id;
SELECT 
Order_Id,
Order_Date,
Ship_Date,
Ship_Mode,
Customer_Id,
Customer_Name,
Product_Id,
Sales,
Quantity,
Discount,
Profit,
COUNT(*) AS duplicate_count
FROM orders
GROUP BY
Order_ID,
Order_Date,
Ship_Date,
Ship_Mode,
Customer_Id,
Customer_Name,
Product_Id,
Sales,
Quantity,
Discount,
Profit
HAVING COUNT(*) > 1;
CREATE TABLE orders_backup AS
SELECT * FROM orders;
DELETE FROM orders
WHERE Order_Id = 'US-2023-150119'
AND Product_Id = 'FUR-CH-10002965'
LIMIT 1;
SELECT COUNT(*) AS total_row 
FROM orders;
SELECT COUNT(*) AS current_count
FROM orders;
SELECT 
Order_Id, Product_Id,
COUNT(*) AS occerences
FROM orders_backup
GROUP BY Order_Id , Product_Id
HAVING COUNT(*) > 1;
SELECT *
FROM orders_backup
WHERE NOT EXISTS (
    SELECT 1
    FROM orders
    WHERE orders.Order_ID = orders_backup.Order_ID
      AND orders.Product_ID = orders_backup.Product_ID
      AND orders.Order_Date = orders_backup.Order_Date
      AND orders.Ship_Date = orders_backup.Ship_Date
      AND orders.Sales = orders_backup.Sales
      AND orders.Quantity = orders_backup.Quantity
      AND orders.Discount = orders_backup.Discount
      AND orders.Profit = orders_backup.Profit
);
SELECT
    Order_Id,
    Product_Id,
    COUNT(*) AS occurrences
FROM orders_backup
GROUP BY Order_Id, Product_Id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
SELECT
    Order_Id,
    Product_Id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY Order_Id, Product_Id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
SELECT
    b.Order_Id,
    b.Product_Id,
    b.occurrences AS backup_count,
    COALESCE(o.occurrences, 0) AS current_count,
    b.occurrences - COALESCE(o.occurrences, 0) AS difference
FROM
(
    SELECT Order_Id, Product_Id, COUNT(*) AS occurrences
    FROM orders_backup
    GROUP BY Order_Id, Product_Id
) b
LEFT JOIN
(
    SELECT Order_Id, Product_Id, COUNT(*) AS occurrences
    FROM orders
    GROUP BY Order_Id, Product_Id
) o
ON b.Order_Id = o.Order_Id
AND b.Product_Id = o.Product_Id
WHERE b.occurrences <> COALESCE(o.occurrences, 0);
SELECT 
(SELECT COUNT(*) FROM 
orders_backup) AS backup_total,
(SELECT COUNT(*) FROM orders) AS
current_total;
SELECT *
FROM orders_backup
WHERE Order_Id = 'US-2023-150119'
AND Product_Id = 'FUR-CH-1002965';
SELECT * FROM Orders
WHERE Order_Id = 'US-2023-150119'
AND Product_Id = 'FUR-CH-1002965';
SELECT * FROM orders_backup b WHERE NOT EXISTS (
SELECT 1
FROM orders o 
WHERE o.Order_Id = b.Order_Id
AND o.Order_Date = b.Order_Date
AND o.Ship_Date = b.Ship_Date
AND o.Ship_Mode = b. Ship_Mode
AND o.Customer_Id = b.Customer_Id
AND o.Product_Id = b.Product_Id
AND o.Sales = b.Sales
AND o.Quantity = b.Quantity
AND o.Discount = b.Discount
AND o.Profit = b.Profit
);
SELECT 
    b.Order_Id,
    b.Product_Id,
    COUNT(*) AS backup_count,
    COALESCE(o.current_count, 0) AS current_count
FROM orders_backup b
LEFT JOIN (
    SELECT 
        Order_Id,
        Product_Id,
        COUNT(*) AS current_count
    FROM orders
    GROUP BY Order_Id, Product_Id
) o
ON b.Order_Id = o.Order_Id
AND b.Product_Id = o.Product_Id
GROUP BY b.Order_Id, b.Product_Id, o.current_count
HAVING COUNT(*) <> COALESCE(o.current_count, 0);
 SELECT * 
 FROM orders_backup
 WHERE Order_Id = 'US-2023-150119';
 SELECT *
 FROM Orders
 WHERE Order_Id = 'US-2023-150119';
 SELECT * 
 FROM orders
 LIMIT 10;
 SELECT
 ROUND(SUM(Sales),2) AS Total_sales,
 ROUND(SUM(Profit),2) AS Total_profit,
 SUM(Quantity) AS Total_Quantity
 FROM orders;
 SELECT  Category,
 ROUND(SUM(Sales),2) AS Total_Sales,
 ROUND(SUM(Profit),2) AS Total_Profit,
 Sum(Quantity) AS Total_Quantity
 FROM orders
 GROUP BY Category
 ORDER BY Total_Sales DESC;
 SELECT Region,
 ROUND(SUM(Sales),2) AS Total_Sales,
 ROUND(SUM(Profit),2) AS Total_Profit,
 SUM(Quantity) AS Total_Quantity
 FROM orders
 GROUP BY Region
 ORDER BY Total_Sales DESC;
 SELECT Sub_Category,
 ROUND(SUM(Sales),2) AS Total_Sales,
 ROUND(SUM(Profit),2) AS Total_Profit,
 SUM(Quantity) AS Total_Quantity
 FROM orders
 GROUP BY Sub_Category
 ORDER BY Total_Sales DESC;
 SELECT Sub_Category,
 ROUND(SUM(Sales),2) AS Total_Sales,
 ROUND(SUM(Profit),2) AS Total_Profit,
 SUM(Quantity) AS Total_Quantity
 FROM orders
 GROUP BY Sub_Category
 HAVING SUM(Profit)< 0
 ORDER BY Total_Profit ASC;
 SELECT Sub_Category,
 ROUND(AVG(Discount),2) AS Discount_Avg,
 ROUND(SUM(Sales),2) AS Total_Sales,
 ROUND(SUM(Profit),2) AS Total_profit
 FROM orders
 GROUP BY Sub_Category
 ORDER BY Discount_Avg DESC;
  SELECT Customer_Id, Customer_Name,
  ROUND(SUM(Sales),2) AS Total_Sales,
  ROUND(SUM(Profit),2) AS Total_Profit,
  SUM(Quantity) AS Total_Quantity
  FROM orders
  GROUP BY Customer_Id , Customer_Name
  ORDER BY Total_Sales DESC
  LIMIT 10;
  SELECT YEAR(Order_Date) AS Year,
  ROUND(SUM(Sales),2) AS Total_Sales,
  ROUND(SUM(Profit),2) AS Total_profit,
  SUM(Quantity) AS Total_Quantity
  FROM orders
  GROUP BY YEAR(Order_Date)
  ORDER BY YEAR;
SELECT YEAR(Order_Date) AS YEAR,
MONTH(Order_Date) AS MONTH,
ROUND(SUM(Sales),2) AS Total_Sales,
ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY YEAR(Order_Date),
MONTH(Order_Date)
ORDER BY YEAR,MONTH;
SELECT State_Province,
ROUND(SUM(Sales),2) AS Total_Sales,
ROUND(SUM(Profit),2) AS Total_Profit,
SUM(Quantity) AS Total_Quantity
FROM orders
GROUP BY State_Province
ORDER BY Total_Sales DESC
LIMIT 10;
SELECT Segment,
ROUND(SUM(Sales),2) AS Total_Sales,
ROUND(SUM(Profit),2) AS Total_Profit,
SUM(Quantity) AS Total_Quantity
FROM orders
GROUP BY Segment
ORDER BY Total_Sales DESC;
SELECT Ship_Mode,
ROUND(SUM(Sales),2) AS Total_Sales,
ROUND(SUM(Profit),2) AS Total_Profit,
SUM(Quantity) AS Total_Quantity
FROM orders
GROUP BY Ship_Mode
ORDER BY Total_Sales DESC;

