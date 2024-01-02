-- Customer Table

CREATE TABLE Customer
(
    CustNo CHAR(8), -- primary key: will have implied NOT NULL
    CustFirstName VARCHAR(50) NOT NULL,
    CustLastName VARCHAR(50) NOT NULL,
    CustStreet VARCHAR(50),
    CustCity VARCHAR(50),
    CustState CHAR(2),
    CustZip CHAR(10),
    CustBal DECIMAL(14, 2), -- what should the precision be to maximize memory efficency ???

    CONSTRAINT PKCustomer PRIMARY KEY (CustNo)
);

-- Employee Table

CREATE TABLE Employee
(
    EmpNo CHAR(8),
    EmpFirstName VARCHAR(50) NOT NULL,
    EmpLastName VARCHAR(50) NOT NULL,
    EmpPhone CHAR(14),
    SupEmpNo CHAR(8),
    EmpCommRate DECIMAL(3,2),
    EmpEmail VARCHAR(50) UNIQUE,

    CONSTRAINT PKEmployee PRIMARY KEY (EmpNo)
);

-- Order Table

CREATE TABLE OrderTbl
(
    OrdNo CHAR(8),
    OrdDate DATE NOT NULL,
    CustNo CHAR(8),
    EmpNo CHAR(8),
    OrdName VARCHAR(50),
    OrdStreet VARCHAR(50),
    OrdState CHAR(2),
    OrdZip CHAR(10),

    CONSTRAINT PKOrderTbl PRIMARY KEY (OrdNo),
    CONSTRAINT FKCustomer FOREIGN KEY (CustNo) REFERENCES Customer(CustNo),
    CONSTRAINT FKEmployee FOREIGN KEY (EmpNo) REFERENCES Employee(EmpNo)
);

-- Product Table

CREATE TABLE Product
(
    ProdNo CHAR(8),
    ProdName VARCHAR(50),
    ProdMfg VARCHAR(50),
    ProdQOH INT, 
    ProdPrice DECIMAL(6, 2),
    ProdNextShipDate DATE,

    CONSTRAINT PKProduct PRIMARY KEY (ProdNo)
);

-- Order Line Table

CREATE TABLE OrderLine
(
    OrdNo CHAR(8),
    ProdNo CHAR(8),
    Qty INT

    CONSTRAINT PKOrderLine PRIMARY KEY (OrdNo, ProdNo),
    CONSTRAINT FKProduct FOREIGN KEY (ProdNo) REFERENCES Product(ProdNo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FKOrder FOREIGN KEY (OrdNo) REFERENCES Order(OrdNo)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

ALTER TABLE Employee ADD CONSTRAINT FKSupEmpNo FOREIGN KEY (SupEmpNo) REFERENCES Employee(EmpNo);