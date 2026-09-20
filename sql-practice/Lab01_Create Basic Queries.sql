USE Company_SD

-- Display all the employees Data.
SELECT * FROM Employee

-- Display the employee First name, last name, Salary and Department number.
SELECT Fname AS First_name , 
	   Lname AS last_name, Salary, 
	   Dno AS Department_number 
FROM Employee

-- Display all the projects names, locations and the department which is responsible about it.
SELECT Pname AS projects_names, 
	   PLocation AS locations, 
	   Dnum AS department 
FROM Project

/*If you know that the company policy is to pay an annual commission for each employee 
with specific percent equals 10% of his/her annual salary.
Display each employee full name and his annual commission in an ANNUAL COMM column (alias).*/
SELECT Fname + ' ' + Lname AS Full_name, 
	   Salary *12 * 10/100 AS ANNUAL_COMM 
FROM Employee

--Display the employees Id, name who earns more than 1000 LE monthly.
SELECT SSN AS Employees_Id,
	   Fname + ' ' + Lname AS Name
FROM Employee
WHERE Salary > 1000

--Display the employees Id, name who earns more than 10000 LE annually.
SELECT SSN AS Employees_Id,
	   Fname + ' ' + Lname AS Name
FROM Employee
WHERE Salary * 12 > 10000 ; 

--Display the names and salaries of the female employees 
SELECT Fname + ' ' + Lname AS Name,
	   Salary 
FROM Employee
WHERE Sex = 'F'

--Display each department id, name which managed by a manager with id equals 968574.
SELECT Dnum AS Department_Id,
	   Dname AS Name
FROM Departments
WHERE MGRSSN = 968574

--Display the ids, names and locations of  the pojects which controled with department 10.
SELECT Pnumber AS IDs,
	   Pname AS Names,
	   PLocation AS Locations
FROM Project
WHERE Dnum = 10
