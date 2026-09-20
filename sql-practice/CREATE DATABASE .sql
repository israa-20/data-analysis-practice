CREATE DATABASE CompanyDB;
USE CompanyDB;

CREATE TABLE Departments (
    Dnum INT PRIMARY KEY,
    Dname VARCHAR(50),
    MgrSSN CHAR(10)
);

CREATE TABLE Location (
    Dnum INT,
    Loc VARCHAR(50),
    PRIMARY KEY(Dnum, Loc),
    CONSTRAINT FK_Location_Dept FOREIGN KEY (Dnum) REFERENCES Departments(Dnum)
);

CREATE TABLE Employees (
    SSN INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(1),
    BD DATE,
    Dnum INT,
    SuperId INT,
    CONSTRAINT FK_Employees_Dept FOREIGN KEY (Dnum) REFERENCES Departments(Dnum)
);

CREATE TABLE Dependent (
    ESSN INT,
    Dpname VARCHAR(50),
    BD DATE,
    Gender VARCHAR(1),
    PRIMARY KEY(ESSN, Dpname),
    CONSTRAINT FK_Dependent_Employees FOREIGN KEY (ESSN) REFERENCES Employees(SSN)
);

CREATE TABLE Projects (
    Pnum INT PRIMARY KEY,
    Pname VARCHAR(50),
    City VARCHAR(50),
    Loc VARCHAR(50),
    Dnum INT,
    CONSTRAINT FK_Projects_Dept FOREIGN KEY (Dnum) REFERENCES Departments(Dnum)
);

CREATE TABLE Work (
    ESSN INT,
    Pnum INT,
    Hours INT,
    PRIMARY KEY(ESSN, Pnum),
    CONSTRAINT FK_Work_Employees FOREIGN KEY (ESSN) REFERENCES Employees(SSN),
    CONSTRAINT FK_Work_Projects FOREIGN KEY (Pnum) REFERENCES Projects(Pnum)
);
