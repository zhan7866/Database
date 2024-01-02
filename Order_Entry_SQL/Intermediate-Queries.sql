-- ***********************************************************************************
-- Problems 01 - 03 use the OrdEntry database
-- ***********************************************************************************

-- Problem_01: List all employees that have not taken any orders. Include the employee 
-- number, first and last name, and the number of his or her supervisor. (1 row) 

SELECT EmpNo, EmpFirstName, EmpLastName, SupEmpNo
FROM Employee 
WHERE EmpNo NOT IN
    (SELECT EmpNo
    FROM OrderTbl 
    WHERE EmpNo IS NOT NULL);

-- Problem_02: List all customer orders that were ordered by and are going to the same 
-- person, and were taken by employees with the commission rate of 4% or greater using 
-- Type I subquery. Include customer number, first and last name, order number, date 
-- and the name of the person the order is going to. (4 rows)

SELECT Customer.CustNo, CustFirstName, CustLastName, OrdNo, OrdDate, OrdName
FROM Customer INNER JOIN OrderTbl
  ON Customer.CustNo = OrderTbl.CustNo
WHERE OrdName = CONCAT(CustFirstName, " ", CustLastName) AND EmpNo IN 
  (SELECT EmpNo
  FROM Employee 
  WHERE EmpCommRate >= 0.04);

-- Problem_03: List all the customers that have only shopped online using a Type II 
-- subquery. Include customer number, first and last name. (3 rows)

SELECT CustNo, CustFirstName, CustLastName
FROM Customer 
WHERE CustNo NOT IN 
  (SELECT CustNo 
  FROM OrderTbl 
  WHERE EmpNo IS NOT NULL);

SELECT CustNo, CustFirstName, CustLastName
FROM Customer 
WHERE NOT EXISTS
	(SELECT * 
  FROM OrderTbl
  WHERE Customer.CustNo = OrderTbl.CustNo AND EmpNo IS NOT NULL);

-- ***********************************************************************************
-- Problems 04 - 07 use the Internet Movie Database (IMDB)
-- ***********************************************************************************

-- Problem_04: You are a fan of James Bond 007 movies. You wonder how many movies out 
-- there have a similar title in the sense that they end with a space and three digits. 
-- Write a SQL statement that uses a regular expression to search the movies_sample 
-- table for all movies that end with the described pattern. Show all columns. (901 rows)

SELECT *
FROM movies_sample
WHERE moviename REGEXP '[:space:][:digit:]{3}$';

-- Problem_05: In the query from the previous problem, which 3-digit combination 
-- was most the popular in movie titles? Show the top-10 (use LIMIT 10 at the end of
-- your query) 3-digit combinations (must be exactly 3-digits) based on the number of 
-- movie titles that end with a space and those 3 digits. Show the 3-digit number, 
-- named Last3, and the number of times it is used in the movie title, named NumLast3,
-- and order the results by the number of times from high to low. (366 rows before
-- using LIMIT 10)

SELECT RIGHT(moviename, 3) AS Last3, COUNT(*)
FROM movies_sample
WHERE moviename REGEXP '[:space:][:digit:]{3}$'
GROUP BY Last3
ORDER BY Last3 DESC
LIMIT 10;

-- Problem_06: We want to find out how many movies are about wars (in the literal sense)
-- by creating a regular expression to find all movies that have a word "wars" in the 
-- title. Notice that wars must appear alone as a stand-alone word, it cannot be  
-- embedded in other words such as "Warsaw". Show all columns and sort by title in the 
-- result. (440 rows)

SELECT *
FROM movies_sample
WHERE moviename REGEXP '\\bwars\\b';
ORDER BY moviename


-- Problem_07: Use RegEx to find all movie names that contain the pattern "the" and 
-- "wars" starting with "the". Notice again that wars must appear as a stand-alone
-- word, it cannot be embedded in other words such as "Motowars". Show all the columns
-- and sort by title in the result. (43 rows)

SELECT * FROM movies_sample 
WHERE moviename REGEXP "^the.+\\bwars\\b"
ORDER BY moviename

-- ***********************************************************************************
-- Problem 08 uses the OrdEntry database
-- ***********************************************************************************

-- Problem_08: Create a Cust_Sales CTE with total sales by customer. The CTE must 
-- include the customer number, full name (CONCAT first and last), named CustFull, as
-- well as the total sales, named CustSales. Use the CTE to find the customer with the 
-- highest sales, showing the customer full name and his/her total sales. (1 row)
-- Hint: This problem is very similar to Ex. 06 in the demo file. 

WITH Cust_Sales AS (
  SELECT Customer.CustNo, CONCAT(CustFirstName, ' ', CustLastName) AS CustFull, 
    SUM(ProdPrice * Qty) AS CustSales
  FROM Customer INNER JOIN OrderTbl 
    ON Customer.CustNo = OrderTbl.CustNo
    INNER JOIN OrderLine 
    ON OrderTbl.OrdNo = OrderLine.OrdNo
    INNER JOIN Product
    ON OrderLine.ProdNo = Product.ProdNo
  GROUP BY Customer.CustNo
) SELECT CustFull, CustSales FROM Cust_Sales 
  WHERE CustSales = (SELECT MAX(CustSales) FROM Cust_Sales)

-- ***********************************************************************************
-- Problems 09 - 10 use the Sakila sample database
-- ***********************************************************************************

-- Problem_09: Create a query that will serve as a basis for Customer_Rentals CTE. The
-- query must return the number of rentals, named NumRentals by store_id, named StoreID,
-- followed by customer_id, named CustID, as well as first and last name, named CustFirst 
-- and CustLast. Remember to show only customers with 20 or more rentals and to sort
-- by store and number of rentals (descending). (62 rows)

SELECT inventory.store_id AS StoreID, customer.customer_id AS CustID, 
	customer.first_name AS CustFirst, customer.last_name AS CustLast, COUNT(*) AS NumRentals
FROM Inventory 
  INNER JOIN Rental 
  ON Inventory.inventory_id = Rental.inventory_id
  INNER JOIN Customer 
  ON Rental.customer_id = Customer.customer_id
GROUP BY Inventory.store_id, Customer.customer_id
HAVING NumRentals >= 20
ORDER BY StoreID, NumRentals DESC

-- Problem_10: Use the Customer_Rentals CTE to rank the customers by store. You must
-- select the store, customer ID, first and last name, and the number of rentals from 
-- the CTE and then add the two ranking columns named CustRank and DenseCustRank using  
-- the store partitions. (62 rows)

WITH Customer_Rentals AS (
  SELECT inventory.store_id AS StoreID, customer.customer_id AS CustID, 
	customer.first_name AS CustFirst, customer.last_name AS CustLast, COUNT(*) AS NumRentals
  FROM Inventory 
    INNER JOIN Rental 
    ON Inventory.inventory_id = Rental.inventory_id
    INNER JOIN Customer 
    ON Rental.customer_id = Customer.customer_id
  GROUP BY Inventory.store_id, Customer.customer_id
  HAVING NumRentals >= 20
  ORDER BY StoreID, NumRentals DESC
)
SELECT *, RANK() OVER (PARTITION BY StoreID
    ORDER BY NumRentals DESC) AS CustRank,
    DENSE_RANK() OVER (PARTITION BY StoreID
    ORDER BY NumRentals DESC) AS DenseCustRank
 FROM Customer_Rentals