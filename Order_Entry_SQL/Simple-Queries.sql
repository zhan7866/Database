-- Problem_01: List all columns of the Product table for 
-- products costing more than $50. Order the result by 
-- product manufacturer (ProdMfg) and product names. (6 rows)

SELECT * 
FROM Product
WHERE ProdPrice > 50
ORDER BY ProdMfg, ProdName;

-- Problem_02: List the customer number, the name (first 
-- and last), the city, and the balance of customers who 
-- reside in Denver with a balance greater than $150 or who 
-- reside in Seattle with balance greater than $300. (4 rows)

SELECT CustNo, CustFirstName, CustLastName, CustCity, CustBal
From Customer 
WHERE (CustCity = "Denver" AND CustBal > 150) 
    OR (CustCity = "Seattle" AND CustBal > 300);

-- Problem_03: List the columns of the OrderTbl table for 
-- phone orders placed in January 2030. A phone order has 
-- an associated employee. (13 rows)

SELECT *
FROM OrderTbl 
WHERE EmpNo IS NOT NULL 
    AND OrdDate LIKE "2030-01%";

-- Problem_04: List all columns of Product table that 
-- contain the words Ink Jet in the product name. (3 rows)

SELECT *
FROM Product
WHERE ProdName LIKE "%Ink Jet%";

-- Problem_05: List the order number, order date, and 
-- customer number of orders placed after January 23, 
-- 2030, shipped to Washington recipients. (4 rows)

SELECT OrdNo, OrdDate, CustNo
FROM OrderTbl 
WHERE OrdDate > "2030-01-23" 
    AND OrdState = "WA";
 
-- Problem_06: List the order number, order date, customer number, 
-- and name (first and last) of orders placed in January 2030 
-- by Colorado customers (CustState) but sent to Washington 
-- recipients (OrdState). Use INNER JOIN style. (3 rows)

SELECT OrdNo, OrdDate, Customer.CustNo, CustFirstName, CustLastName
FROM Customer INNER JOIN OrderTbl
    ON Customer.CustNo = OrderTbl.CustNo
WHERE OrdDate LIKE "2030-01%" AND CustState = "CO" AND OrdState = "WA";

-- Problem_07: List the order number, order date, customer number, 
-- customer name (first and last), employee number, and employee 
-- name (first and last) of January 2030 orders placed by 
-- Colorado customers. Use INNER JOIN style. (5 rows)

SELECT OrdNo, OrdDate, Customer.CustNo, CustFirstName, CustLastName, Employee.EmpNo, EmpFirstName, EmpLastName
FROM ((Customer INNER JOIN OrderTbl
    ON Customer.CustNo = OrderTbl.CustNo)
        INNER JOIN Employee
            ON OrderTbl.EmpNo = Employee.EmpNo)
WHERE OrdDate LIKE "2030-01%" AND CustState = "CO";

   
-- Problem_08: List the employee number, name (first and last), 
-- and phone of employees who have taken orders in January 2030 
-- from customers with balances greater than $300. Remove 
-- duplicate rows (if any) from the result. Use INNER JOIN 
-- style. (4 rows)

SELECT DISTINCT Employee.EmpNo, EmpFirstName, EmpLastName, EmpPhone
FROM ((Customer INNER JOIN OrderTbl
    ON Customer.CustNo = OrderTbl.CustNo)
        INNER JOIN Employee
            ON OrderTbl.EmpNo = Employee.EmpNo)
WHERE OrdDate LIKE "2030-01%" AND CustBal > 300;
   
-- Problem_09: List the average balance and number of customers
-- by city. Only include the customers residing in Washington 
-- state (WA). Eliminate cities in the result with less than 
-- two customers. (2 rows)

SELECT CustCity, AVG(CustBal) AS AvgCustBal, COUNT(*) AS NumCust
FROM Customer 
WHERE CustState = "WA"
GROUP BY CustCity
HAVING NumCust >= 2;

-- Problem_10: List the order number and total amount for orders 
-- placed on January 23, 2030. The total amount of an order is the 
-- sum of the quantity times the product price of each product on 
-- the order. Use INNER JOIN style. (6 rows)

SELECT OrderLine.OrdNo, SUM(Qty*ProdPrice) AS TotAmt
FROM ((OrderTbl INNER JOIN OrderLine
    ON OrderTbl.OrdNo = OrderLine.OrdNo)
        INNER JOIN Product
            ON OrderLine.ProdNo = Product.ProdNo)
WHERE OrdDate = "2030-01-23"
GROUP BY OrdNo;