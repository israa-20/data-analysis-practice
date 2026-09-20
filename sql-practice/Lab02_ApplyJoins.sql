-- Try to create the following Queries:
USE Company_SD
-- 1.Display the Department id, name and id and the name of its manager.
SELECT D.Dnum AS Department_Id,
	   D.Dname AS Department_Name,
	   D.MGRSSN AS Manager_Id,
	   E.Fname AS Manager_Name
FROM Departments D
LEFT OUTER JOIN Employee E
	ON E.SSN = D.MGRSSN

-- 2.Display the name of the departments and the name of the projects under its control.
SELECT D.Dname,
	   P.Pname
FROM Departments D
INNER JOIN Project P
	ON P.Dnum = D.Dnum

-- 3.Display the full data about all the dependence associated with the name of the employee they depend on him/her.
SELECT D.*,
       E.Fname AS Employee_Name
FROM Dependent D
INNER JOIN Employee E
    ON D.ESSN = E.SSN
	
-- 4. Display the Id, name and location of the projects in Cairo or Alex city.
SELECT P.Pnumber AS Id,
       P.Pname,
       P.Plocation
FROM Project P
WHERE P.City IN ('Cairo', 'Alex');

-- 5.Display the Projects full data of the projects with a name starts with "a" letter.
SELECT * 
FROM Project 
WHERE Pname LIKE 'a%'

-- 6. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
SELECT E.Fname + ' ' + E.Lname AS Employee_Name,
       E.Salary,
       E.Dno
FROM Employee E
WHERE E.Dno = 30 
  AND E.Salary BETWEEN 1000 AND 2000;

-- 7.Retrieve the names of all employees in department 10 who works more than or equal10 hours per week
-- on "AL Rabwah" project.
SELECT E.Fname + ' ' + E.Lname AS Employee_Name,
	   P.Pname AS Project_Name,
	   E.Dno AS Department_Id,
	   Wf.Hours
FROM Employee E
LEFT OUTER JOIN Departments D
	ON E.Dno = D.Dnum
INNER JOIN Works_for Wf
	ON E.SSN = Wf.ESSn   -- Link the employee to his working hours
INNER JOIN Project P
	ON Wf.Pno = p.Pnumber   -- Link work to the project
WHERE E.Dno = 10
	AND P.Pname = 'AL Rabwah'
	AND Wf.Hours >= 10

-- 8.Find the names of the employees who directly supervised with Kamel Mohamed.
SELECT E.Fname + ' ' + E.Lname AS Employee_Name,
	   Sup.Fname + ' ' + Sup.Lname AS supervisor_Name
FROM Employee E
INNER JOIN Employee Sup
	ON E.Superssn = Sup.SSN
WHERE Sup.Fname + ' ' + Sup.Lname = 'Kamel Mohamed'

-- 9. Retrieve the names of all employees and the names of the projects they are working on,
-- sorted by the project name.
SELECT E.Fname + ' ' + E.Lname AS Employee_Name,
       P.Pname AS Project_Name
FROM Employee E
INNER JOIN Works_for WF
    ON E.SSN = WF.ESSN
INNER JOIN Project P
    ON WF.Pno = P.Pnumber
ORDER BY P.Pname;

-- 10.For each project located in Cairo City , find the project number, the controlling department name,
-- the department manager last name ,address and birthdate.
SELECT P.Pnumber,
       D.Dname AS Department_Name,
       E.Lname AS Manager_Last_Name,
       E.Address,
       E.Bdate
FROM Project P
INNER JOIN Departments D
    ON P.Dnum = D.Dnum
INNER JOIN Employee E
    ON D.MGRSSN = E.SSN
WHERE P.City = 'Cairo'; 

-- 11.Display All Data of the managers
SELECT E.*
FROM Employee E
INNER JOIN Departments D
    ON E.SSN = D.MGRSSN;

-- 12.Display All Employees data and the data of their dependents even if they have no dependents
SELECT E.*,
	   D.*
FROM Employee E
LEFT OUTER JOIN Dependent D
	ON D.ESSN = E.SSN

-- 13.Insert your personal data to the employee table as a new employee in department number 30,
-- SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee (Dno, SSN, Superssn, Salary)
VALUES (30, 102672, 112233, 3000)

-- 14.Insert another employee with personal data your friend as new employee in department number 30,
-- SSN = 102660, but don’t enter any value for salary or supervisor number to him.
INSERT INTO Employee (Dno, SSN)
VALUES (30, 102660)

-- 15.Upgrade your salary by 20 % of its last value.
UPDATE Employee
SET Salary = Salary * 1.20
WHERE SSN = 102672
