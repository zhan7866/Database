-- Problem_01: List the order number, the order date, the 
-- customer number, the customer name (first and last), 
-- the customer state, and the shipping state (OrdState) in
-- which the customer state differs from shipping state. (3 rows)

SELECT OrdNo, OrdDate, Customer.CustNo, CustFirstName, CustLastName, CustState, OrdState
FROM Customer INNER JOIN OrderTbl
    ON Customer.CustNo = OrderTbl.CustNo
WHERE CustState <> OrdState;

-- Problem_02: List the product name and the price of all products 
-- ordered by Beth Taylor in January 2030. (4 rows)

SELECT ProdName, ProdPrice
FROM Customer INNER JOIN OrderTbl
    ON Customer.CustNo = OrderTbl.CustNo
    INNER JOIN OrderLine
    ON OrderTbl.OrdNo = OrderLine.OrdNo
    INNER JOIN Product
    ON OrderLine.ProdNo = Product.ProdNo
WHERE CustFirstName = "Beth" AND CustLastName = "Taylor" AND OrdDate LIKE "2030-01%";

SELECT ProdName, ProdPrice
FROM OrderTbl INNER JOIN OrderLine
    ON OrderTbl.OrdNo = OrderLine.OrdNo
    INNER JOIN Product
    ON OrderLine.ProdNo = Product.ProdNo
WHERE CustNo IN (SELECT CustNo FROM Customer Where CustFirstName = "Beth" AND CustLastName = "Taylor") AND OrdDate LIKE "2030-01%";

-- Problem_03: List the employee number, the employee name 
-- (first and last), and total amount of commissions on orders 
-- taken in January 2030. The amount of a commission is the 
-- sum of the dollar amount of products ordered times the 
-- commission rate of the employee. (6 rows)

SELECT Employee.EmpNo, EmpFirstName, EmpLastName, SUM(ProdPrice*Qty*EmpCommRate) AS "TotComm"
FROM Employee INNER JOIN OrderTbl
    ON Employee.EmpNo = OrderTbl.EmpNo
    INNER JOIN OrderLine
    ON OrderTbl.OrdNo = OrderLine.OrdNo
    INNER JOIN Product
    ON OrderLine.ProdNo = Product.ProdNo
WHERE OrdDate LIKE "2030-01%"
GROUP BY EmpNo;

-- Problem_04: For January 2030 orders by Colorado customers, 
-- find the number of Connex products placed by order. The 
-- result should include the order number, customer last name 
-- and the number of Connex products ordered. (3 rows)

SELECT OrderTbl.OrdNo, CustLastName, CustFirstName, COUNT(Product.ProdNo) AS "NumProds"
FROM Customer INNER JOIN OrderTbl
    ON Customer.CustNo = OrderTbl.CustNo
    INNER JOIN OrderLine
    ON OrderTbl.OrdNo = OrderLine.OrdNo
    INNER JOIN Product
    ON OrderLine.ProdNo = Product.ProdNo
WHERE OrdDate LIKE "2030-01%" AND CustState = "CO" AND ProdMfg = "Connex"
GROUP BY OrdNo;

-- Problem_05: For each employee with a commission rate of less 
-- than 0.04, compute the number of orders taken in January 2030. 
-- The result should include the employee number, employee last 
-- name, and number of orders taken. (3 rows)

SELECT Employee.EmpNo, EmpLastName, COUNT(OrdNo) AS "NumOrd"
FROM OrderTbl INNER JOIN Employee
  ON OrderTbl.EmpNo = Employee.EmpNo
WHERE OrdDate LIKE "2030-01%" AND EmpCommRate < 0.04
GROUP BY EmpNo;

-- Problem_06: List the product number, product name, sum of 
-- the quantity of products ordered, and the total order amount 
-- (sum of the product price times the quantity) for orders 
-- placed in January 2030. Only include products that have 
-- more than five products ordered in January 2030. Sort the 
-- result in descending order of the total amount. (3 rows)

SELECT Product.ProdNo, ProdName, SUM(Qty) AS "Qty", SUM(ProdPrice*Qty) AS "Tot"
FROM OrderTbl INNER JOIN OrderLine
	ON OrderTbl.OrdNo = OrderLine.OrdNo
	INNER JOIN Product 
	ON OrderLine.ProdNo = Product.ProdNo
WHERE OrdDate LIKE "2030-01%"
GROUP BY ProdNo
HAVING Qty > 5
ORDER BY Tot DESC;

-- Problem_07: For each employee with commission rate greater 
-- than 0.03, compute the total commission earned from orders 
-- taken in January 2030. The total commission earned is the 
-- total order amount times the commission rate. The result 
-- should include the employee number, employee last name, and 
-- the total commission earned. (3 rows)

SELECT Employee.EmpNo, EmpLastName, SUM(Qty*ProdPrice*EmpCommRate) AS "TotComm"
FROM OrderTbl INNER JOIN Employee
	ON OrderTbl.EmpNo = Employee.EmpNo
	INNER JOIN OrderLine
    ON OrderTbl.OrdNo = OrderLine.OrdNo
	INNER JOIN Product
	ON OrderLine.ProdNo = Product.ProdNo
WHERE OrdDate LIKE "2030-01%" AND EmpCommRate > 0.03
GROUP BY EmpNo;

-- Problem_08: List the customer number, customer name (first 
-- and last), the sum of the quantity of products ordered, 
-- and the total order amount (sum of the product price times 
-- the quantity) for orders placed in January 2030. Only include 
-- products in which the product name contains "Ink Jet" or "Laser". 
-- Only include the customers who have ordered two or more of 
-- these products, sorted descending on total quantity. (5 rows)

SELECT Customer.CustNo, CustFirstName, CustLastName, SUM(Qty) AS "Qty", SUM(ProdPrice*Qty) AS "Tot"
FROM Customer INNER JOIN OrderTbl
    ON Customer.CustNo = OrderTbl.CustNo
    INNER JOIN OrderLine
    ON OrderTbl.OrdNo = OrderLine.OrdNo
    INNER JOIN Product 
    ON OrderLine.ProdNo = Product.ProdNo
WHERE OrdDate LIKE "2030-01%" AND (ProdName LIKE "%Ink Jet%" OR ProdName LIKE "%Laser%")
GROUP BY CustNo
HAVING Qty >= 2
ORDER BY Qty DESC;

-- Problem_09: Complete a multiple table view, named Comm_Emp_Cust_Ord,
-- showing customer name, balance, order dates, and employee names
-- for employees with commission of 0.04 or higher. (6 rows)

CREATE VIEW Comm_Emp_Cust_Ord AS
    SELECT CustFirstName, CustLastName, CustBal, OrdDate, EmpFirstName, EmpLastName
    FROM Customer INNER JOIN OrderTbl
        ON Customer.CustNo = OrderTbl.OrdNo
        INNER JOIN Employee
        ON OrderTbl.EmpNo = Employee.EmpNo
    WHERE EmpCommRate >= 0.04;

-- Problem_09 (cont.): Create a query using this view to show customer 
-- names, balance and order dates for orders taken by Johnson. (2 rows)

SELECT CustFirstName, CustLastName, CustBal, OrdDate
FROM Comm_Emp_Cust_Ord
WHERE EmpLastName = "Johnson";

-- Problem_10: Examine a grouping view, named Product_Summary,  
-- summarizing the total sales by product, and note the use of the
-- following names: ProductName, ManufName, and TotalSales. (10 rows)

CREATE VIEW Product_Summary (ProductName, ManufName, TotalSales) AS
   SELECT ProdName, ProdMfg, SUM(Qty * ProdPrice)
   FROM OrderLine INNER JOIN Product
		 ON OrderLine.ProdNo = Product.ProdNo
   GROUP BY ProdName, ProdMfg;

-- Problem_10 (cont.): Create a grouping query on this view to summarize 
-- the number of products and sales by manufacturer, sorted descending 
-- on total sales. (6 rows)

SELECT ManufName, COUNT(ProductName) AS "ProductName", SUM(TotalSales) AS "TotalSales"
FROM Product_Summary
GROUP BY ManufName
ORDER BY TotalSales DESC;
