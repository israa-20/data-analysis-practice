-- EASY
-- 1.Create a table called Book with BookId (auto-incrementing, primary key),
-- Title (variable-length text up to 50 characters), and Price (decimal with 2 digits after the point).
CREATE TABLE Book (
Book_Id INT PRIMARY KEY IDENTITY,
Title VARCHAR(50),
Price DECIMAL(5,2)
)
-- 2.Insert 3 rows into Book without specifying BookId, then select all rows.
INSERT INTO Book (Title, Price)
VALUES ('Charlotte_web',590.50), ('The Happy Prince',320.64), ('Rich Dad Poor Dad',290.60)
SELECT * FROM Book
USE ITI
-- 3.Display all jstudents whose address does NOT start with 'C'.
SELECT * 
FROM Student
WHERE St_Address NOT LIKE 'C%'

-- 4.Display all instructors, replacing any missing department name with 'Unassigned' (use ISNULL).
SELECT I.Ins_Name,
       ISNULL(D.Dept_Name, 'Unassigned') AS Department_Name
FROM Instructor I
LEFT OUTER JOIN Department D
    ON I.Dept_Id = D.Dept_Id

-- 5.Display each course name and topic name for it (INNER JOIN), sorted alphabetically by course name.
SELECT C.Crs_Name, 
       T.Top_Name
FROM Course C
INNER JOIN Topic T
    ON T.Top_Id = C.Top_Id
ORDER BY C.Crs_Name 

-- MEDIUM
-- 6. Display all students whose first name is exactly 4 characters long and starts with 'S'.
SELECT * 
FROM Student
WHERE St_Fname LIKE 'S___'

-- 7.Display all students whose first name contains the letter 'a' at least twice.
SELECT *
FROM Student
WHERE St_Fname LIKE '%a%a%'

-- 8.Display each student's name and supervisor's name, replacing a missing supervisor with 'No Supervisor'
-- (use ISNULL together with a LEFT JOIN).
SELECT S.St_Fname AS Student_Name ,
       ISNULL(Sup.St_Fname, 'No Supervisor') AS Supervisor
FROM Student S 
LEFT OUTER JOIN Student Sup
	ON S.St_super = Sup.St_Id

-- 9.Display all instructors earning between 2000 and 5000, sorted by salary descending.
SELECT *
FROM Instructor I
WHERE I.Salary BETWEEN 2000 AND 5000
ORDER BY I.Salary DESC

-- 10.Display all courses whose name starts with any letter from A to M.
SELECT *
FROM Course C
WHERE C.Crs_Name LIKE '[A-M]%'

-- 11.Create a small table called TestData (Id identity, Val varchar(10)), insert 3 rows, DELETE all rows,
-- insert 2 more, and check what Id they get. Then TRUNCATE the table, insert 2 more rows, and compare the Id this time.
CREATE TABLE TestData (
Id INT IDENTITY,
Val VARCHAR(10)
)
INSERT INTO TestData (Val) 
VALUES ('Alpha'),('Beta'), ('Gamma')

DELETE FROM TestData 

INSERT INTO TestData (Val) 
VALUES ('Delta'),('Epsilon')

SELECT *
FROM TestData -- continue count Id from 4,5

TRUNCATE TABLE TestData  -- Reset Id from 1 again

INSERT INTO TestData (Val) 
VALUES ('row 6'),('row 7')

SELECT *
FROM TestData

-- 12.Display each department's name along with the full names of all instructors in it 
-- (including departments with zero instructors).
SELECT D.Dept_Name,
       I.Ins_Name
FROM Department D
LEFT OUTER JOIN Instructor I
    ON D.Dept_Id = I.Dept_Id

-- DIFFICULT
-- 13.Write CREATE TABLE statements for Book and Loan, where Loan has a foreign key to Book with ON DELETE CASCADE. 
-- Insert one book and one loan referencing it, then delete the book — 
-- check what happened to the loan row automatically, without deleting it yourself first.

CREATE TABLE Book (
    BookID INT PRIMARY KEY IDENTITY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    ISBN VARCHAR(20) UNIQUE NOT NULL
);

-- Create the Loan table referencing the Book table
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY IDENTITY,
    BookID INT NOT NULL,
    BorrowerName VARCHAR(100) NOT NULL,
    LoanDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
    ON DELETE CASCADE  -- Automatic Deletion
)
INSERT INTO Book (Title, Author, ISBN) 
VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', '978-0743273565')

INSERT INTO Loan (BorrowerName, LoanDate, ReturnDate) 
VALUES ('Jane Doe', '2026-06-01', NULL)

DELETE FROM Book

SELECT * 
FROM Loan

-- 14.Display the names of instructors who teach at least one course whose 
-- name contains the word 'SQL' (using a JOIN through Ins_Course).
SELECT DISTINCT I.Ins_Name
FROM Instructor I
INNER JOIN Ins_Course IC 
    ON I.Ins_Id = IC.Ins_Id
INNER JOIN Course C 
    ON IC.Crs_Id = C.Crs_Id
WHERE C.Crs_Name LIKE '%SQL%';

-- 15.Display each student's name, department name, and every course they're enrolled in with its grade — 
-- but only for students whose department is 'not yet assigned' should still appear in the list.
-- (their courses shown too, if any).
SELECT S.St_Fname,
       D.Dept_Name,
       C.Crs_Name,
       SC.Grade
FROM Student S
LEFT OUTER JOIN Department D
    ON S.Dept_Id = D.Dept_Id
LEFT OUTER JOIN Stud_Course SC
    ON S.St_Id = SC.St_Id
LEFT OUTER JOIN Course C
    ON SC.Crs_Id = C.Crs_Id

-- 16.Write a single query that shows each course, how many characters are in its name
-- (hint: think of what you already know — do you need a JOIN for this at all?), and its topic name.
SELECT C.Crs_Name,
       LEN(C.Crs_Name) AS Course_Name_Length,
       T.Top_Name
FROM Course C
LEFT OUTER JOIN Topic T
    ON C.Top_Id = T.Top_Id

-- VERY HARD
-- 17.Explain in your own words: if a column is both PRIMARY KEY and IDENTITY, and you TRUNCATE that table,
-- then insert a new row — will the new row's ID continue from where the old data left off, or restart?
-- Why does this differ from DELETE?
The identity value restarts 
With TRUNCATE:
Behavior: The IDENTITY seed restarts from its initial value (e.g., restarts from 1).
Reason: TRUNCATE operates at the data page level by deallocating the data pages that store the table.
This resets the table to its initial state, which automatically resets the IDENTITY counter.

With DELETE:
Behavior: The IDENTITY sequence continues from where it left off (preserves the identity seed).
--Reason: DELETE operates on a row-by-row basis, logging each row removal in the Transaction Log,but it does not modify or reset the table's IDENTITY counter.    

-- 18.Explain: why would setting ON DELETE CASCADE carelessly on a real production database (like a banking system)
-- be dangerous? Give a concrete scenario where it could cause unwanted data loss.
Why it is dangerous:
ON DELETE CASCADE creates a domino effect. Accidentally deleting one parent row automatically wipes out all related child data across multiple tables without warning,
destroying historical records and audit logs.

Concrete Scenario (Banking):
Structure: Customers -> Accounts -> Transactions (all set to CASCADE).
What Happens: If an admin deletes 1 Customer, SQL Server automatically deletes all their Accounts and all their transaction history 
(deposits and withdrawals). This causes permanent financial data loss and violates compliance laws.

Best Practice Alternative:
Use ON DELETE NO ACTION (to block the delete if records exist) or Soft Deletes (using an IsDeleted flag instead of removing rows).

-- 19.Without running it — predict what happens if you try to TRUNCATE a table 
-- that has a foreign key pointing to it from another table with existing matching rows. Then test your prediction.
1. Predict outcome: The TRUNCATE command will FAIL and throw an error. No data will be deleted.
2. Error Message: "Cannot truncate table 'ParentTable' because it is being referenced by a FOREIGN KEY constraint."
3. Why it fails:
Row-by-Row vs. Page-Level: 
DELETE checks foreign keys row-by-row, while 
TRUNCATE wipes entire data pages without checking individual rows or cascades.
Data Integrity: 
To prevent Orphan Records (child rows without a parent), 
SQL Server strictly blocks TRUNCATE on any table referenced by a FOREIGN KEY—even if the child table is empty.

-- 20.A table has a column defined as Salary DECIMAL(5,2). Explain why inserting the value 1234.5 would fail, 
-- but 999.99 would succeed — refer back to what precision and scale mean.
Precision (5) represents the total number of digits allowed (both left and right of the decimal point).
Scale (2) represents the number of digits allowed to the right of the decimal point.
DECIMAL(5,2) allows a maximum of 3 digits before the decimal point (5-2=3)
DECIMAL(P, S) -> (precision, scale) 
Integer Digits Allowed: Calculated as precision - scale = digits before the decimal point).
1234.5 It has 4 digits before the decimal and 1 after -> False
999.99 It has 3 digits before the decimal and 2 after, fitting the total precision of 5 -> True

-- Data Types
-- 1.You need a column to store a percentage value like 99.99 (never more than 100.00). 
-- Which data type and size would you choose, and why?
DECIMAL(5,2) 
Precision (5): Allows a total of 5 digits.
Since Precision - Scale = 3, it permits up to 3 integer digits before the decimal point,
accommodating the maximum required value of 100.00 while preventing Arithmetic Overflow.

-- 2. Why would you choose varchar(100) over char(100) for a column storing people's addresses 
-- (which vary a lot in length)?
Use VARCHAR(100) because:
VARCHAR (Variable length): Saves space It only uses the space for the actual letters you type. 
If the address is 20 characters, it takes only 20 bytes.

CHAR (Fixed length): Wastes space It always takes the full 100 bytes,
even if the address is short, by filling the rest with empty spaces.

-- 3.Predict: if a column is DECIMAL(4,1), can it store the value 123.45? Why or why not?
"Theoretically, 123.45 has two decimal places, but DECIMAL(4,1) allows only one. 
However, SQL Server doesn't reject the value immediately—it first rounds it to match the scale, 
so 123.45 becomes 123.5. After rounding, it checks if the result fits the total precision of 4 digits:
123.5 has 3 integer digits + 1 decimal digit = exactly 4 digits.
Therefore, it is expected to succeed, rounding 123.45 to 123.5."

CREATE TABLE TestPrecision (Val DECIMAL(4,1))
INSERT INTO TestPrecision VALUES (123.45)
SELECT * FROM TestPrecision

--LIKE Patterns
-- 4.Write a pattern that matches any name ending in exactly two vowels
-- (hint: you'll need _ combined with a set of letters).
LIKE '%[aeiou][aeiou]'
-- 5.Write a pattern that matches names NOT starting with a vowel.
LIKE '[^aeiou]%'
-- 6.Predict: what would LIKE '%' alone (with nothing else) match? Explain why.
matches all text values (any string of any length, including empty strings ''), EXCEPT NULL values.
Reason: % Wildcard: Matches zero or more characters of any type.

-- IDENTITY
-- 7.True or False: if you DELETE all rows from a table with IDENTITY(1,1) and then insert a new row,
-- that row will get Id = 1 again. Explain your answer.
False.
Reason:DELETE preserves the identity seed: It deletes rows row-by-row and does NOT reset the identity counter.

-- 8.Create a table with Id INT IDENTITY(10,5) PRIMARY KEY, insert 3 rows, and predict the three Id values before
-- running the SELECT.
CREATE TABLE GIRLS (
    Id INT IDENTITY(10,5) PRIMARY KEY
)
INSERT INTO GIRLS DEFAULT VALUES;
INSERT INTO GIRLS DEFAULT VALUES;
INSERT INTO GIRLS DEFAULT VALUES;

SELECT * FROM GIRLS

Predicted ID Values: 10, 15, 20
Reasoning:
Seed (10): The first row gets the starting value of 10.
Increment (5): Each new row adds 5 to the previous value.
1st Row: 10
2nd Row: 10 + 5 = 15
3rd Row: 15 + 5 = 20

-- 9.Can a table have two IDENTITY columns at the same time? Why or why not (think about what IDENTITY is actually for)?
No. A table can have only one IDENTITY column.
Reason: Purpose of IDENTITY: It is designed to generate a single,
unique surrogate key (like an Auto-Increment ID) to uniquely identify each row in a table.

-- DROP vs DELETE vs TRUNCATE
-- 10.You have a table with 10 million rows and want to empty it completely and quickly,
-- keeping the table structure for future use. Which command fits best, and why not the other two?
Best Command: TRUNCATE TABLE
Why TRUNCATE fits best:
Fast & Minimal Logging: It deletes all 10 million rows instantly by deallocating data pages.
Keeps Structure: It empties the table but preserves the table structure for future use.
Resets Identity: It resets the IDENTITY seed back to its original starting value.

Why NOT the other two?
DELETE (Too Slow): Operates row-by-row and logs every single row deletion, 
which takes a very long time for 10 million rows and fills up the transaction log.
DROP (Destroys Structure): Deletes the entire table structure along with the data, requiring you to recreate the table from scratch.

-- 11.If you DROP a table by mistake, what's the only way to get it back? 
Restore from Backup

-- Foreign Key Update/Delete Rules
-- 12.Create a Department and an Employee table where Employee has a foreign key to Department with ON DELETE SET NULL.
-- Insert a department and an employee in it, then delete the department — 
-- what happens to the employee's department column?

CREATE TABLE Department (
    DeptId INT PRIMARY KEY
)

CREATE TABLE Employee (
    EmpId INT PRIMARY KEY,
    Dnum INT,
    CONSTRAINT FK_Employee_Dept FOREIGN KEY (Dnum) REFERENCES Department(DeptId)
    ON DELETE SET NULL
)
--When you delete the department, the employee's DeptId column is automatically set to NULL.
The employee record stays in the table, but it becomes unassigned.

-- 13.In your own words: what's the practical difference between ON DELETE CASCADE and ON DELETE SET NULL? 
-- Give a real-world example where SET NULL makes more sense than CASCADE.

ON DELETE CASCADE: Deletes child rows automatically when the parent row is deleted.
Example: Deleting an Order deletes all its Order Items.

ON DELETE SET NULL: Keeps child rows, but sets their Foreign Key to NULL.
Example: Deleting a Department sets the Employee's department to NULL (the employee shouldn't be deleted just
because their department was removed).

-- 14.Predict: with the default NO ACTION rule (no CASCADE/SET NULL specified), 
-- what happens if you try to delete a parent row that still has matching child rows?
NO ACTION (Default):
Result: SQL Server blocks the delete and throws a Foreign Key Constraint Error.
You cannot delete a parent row while matching child rows exist.

-- ISNULL
-- 15.Write a query showing each instructor's name and salary, but if the salary is NULL, show 0 instead.
SELECT InstructorName, ISNULL(Salary, 0) AS Salary
FROM Instructors;

-- 16.What's the difference between WHERE Salary IS NULL and SELECT ISNULL(Salary, 0)?
-- Why can't you swap one for the other?
WHERE Salary IS NULL: A filter that finds/returns only the rows where Salary has no value.
ISNULL(Salary, 0): A function that converts NULL values to 0 for display purposes.

Why not swap: One filters rows, while the other modifies how the value is displayed.

-- 17.Predict: does ISNULL(Salary, 0) > 1000 work correctly as a filter condition, 
-- or is there a problem with using it that way?
Does it work? Yes, it works correctly, but it is NOT recommended.
Problem: Wrapping a column in a function inside WHERE prevents SQL Server from using indexes 
(causes performance issues / Index Scan instead of Index Seek). Better practice: WHERE Salary > 1000.
