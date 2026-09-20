USE ITI
-- Cartesian Product = Each row of the first table with each row of the second table, without a linking condition
SELECT St_Fname, 
	   Dept_Name
FROM Student, Department

SELECT St_Fname, 
	   Dept_Name
FROM Student 
CROSS JOIN Department

-- INNER JOIN -- Equi Join
-- INNER JOIN -> Matched only
SELECT St_Fname, 
	   Dept_Name
FROM Student S, Department D
WHERE D.Dept_Id = S.Dept_Id

-- Onther Method
SELECT S.St_Fname, 
	   D.Dept_Name
FROM Student S 
INNER JOIN Department D
	ON S.Dept_Id = D.Dept_Id

-- LEFT OUTER JOIN
SELECT S.St_Fname, 
	   D.Dept_Name
FROM Student S 
LEFT OUTER JOIN Department D
	ON S.Dept_Id = D.Dept_Id

-- RIGHT OUTER JOIN
SELECT S.St_Fname, 
	   D.Dept_Name
FROM Student S 
RIGHT OUTER JOIN Department D
	ON S.Dept_Id = D.Dept_Id

-- SELF JOIN
SELECT S.St_Fname AS Student, 
	   Sup.St_Fname AS Supervisor
FROM Student S 
INNER JOIN Student Sup
	ON S.St_super = Sup.St_Id

SELECT S.St_Fname, 
	   C.Crs_Name, 
	   SC.Grade
FROM Student S
INNER JOIN Stud_Course SC	
	ON S.St_Id = SC.St_Id
INNER JOIN Course C 
	ON SC.Crs_Id = C.Crs_Id

-- INNER JOIN
-- 1. Display each student's first name, last name, and the name of their department.
SELECT S.St_Fname, S.St_Lname, 
	   D.Dept_Name
FROM Student S 
INNER JOIN Department D
	ON S.Dept_Id = D.Dept_Id

-- 2. Display each instructor's name, degree, salary, and their department name.
SELECT I.Ins_Name, I.Ins_Degree, I.Salary, 
	   D.Dept_Name
FROM Instructor I 
INNER JOIN Department D
	ON I.Dept_Id = D.Dept_Id

-- 3. Display each course name along with the topic name it belongs to.
SELECT C.Crs_Name, 
	   T.Top_Name
FROM Course C 
INNER JOIN Topic T
	ON C.Top_Id = T.Top_Id

-- 4. Display the names of all courses that belong to the topic 'Database'.
SELECT C.Crs_Name, 
	   T.Top_Name
FROM Course C 
INNER JOIN Topic T
	ON C.Top_Id = T.Top_Id
WHERE Top_Name = 'DB'

-- 5. Display each instructor's name and department name, 
-- for instructors earning more than 3000, sorted by salary descending.
SELECT I.Ins_Name,	
	   D.Dept_Name
FROM Instructor I 
INNER JOIN Department D
	ON I.Dept_Id = D.Dept_Id
WHERE Salary > 3000
ORDER BY I.Salary DESC

-- OUTER JOIN
-- 6. Display all students and their department names, including students who are not assigned to any department yet.
SELECT S.St_Fname + ' ' +  S.St_Lname AS All_Students, 
	   D.Dept_Name
FROM Student S 
LEFT OUTER JOIN Department D
	ON S.Dept_Id = D.Dept_Id

-- 7. Display all departments and the students in them, including departments that currently have no students.
SELECT S.St_Fname + ' ' +  S.St_Lname AS All_Students,
	   D.Dept_Name
FROM Department D 
LEFT OUTER JOIN Student S
	ON S.Dept_Id = D.Dept_Id

-- 8. Display all courses and their topics, including any course that has no topic assigned.
SELECT C.Crs_Name, 
	   T.Top_Name
FROM Course C 
LEFT OUTER JOIN Topic T
	ON C.Top_Id = T.Top_Id

-- 9. Display all instructors and all departments, even if there is no match between them.
SELECT I.Ins_Name, 
	   D.Dept_Name
FROM Instructor I 
FULL OUTER JOIN Department D
	ON I.Dept_Id = D.Dept_Id

-- 10. Display only the students who have NOT been assigned to any department.
-- (hint: combine a LEFT JOIN with a WHERE condition on NULL)
SELECT S.St_Fname + ' ' + S.St_Lname AS Students, 
	   D.Dept_Name
FROM Student S 
LEFT OUTER JOIN Department D
	ON S.Dept_Id = D.Dept_Id
WHERE Dept_Name IS NULL

-- SELF JOIN
-- 11. Display each student's full name together with the full name of their supervisor.
SELECT S.St_Fname + ' ' + S.St_Lname AS Studens , 
	   Sup.St_Fname + ' ' + Sup.St_Lname AS Supervisor
FROM Student S
INNER JOIN Student Sup 
	ON S.St_Super = Sup.St_Id

-- 12. Display all students along with their supervisor's name, including students who have no supervisor.
SELECT S.St_Fname + ' ' + S.St_Lname AS Studens , 
	   Sup.St_Fname + ' ' + Sup.St_Lname AS Supervisor
FROM Student S
LEFT OUTER JOIN Student Sup 
	ON S.St_Super = Sup.St_Id

-- 13. Display the names of students who supervise at least one other student.
SELECT DISTINCT
       Sup.St_Fname + ' ' + Sup.St_Lname AS Supervisor
FROM Student S
INNER JOIN Student Sup
    ON S.St_Super = Sup.St_Id;

-- Junction tables (many-to-many)
-- 14. Display each student's name, the course name they took, and their grade.
SELECT S.St_Fname + ' ' + S.St_Lname AS Studens , 
	   C.Crs_Name,
	   SC.Grade
FROM Stud_Course SC 
INNER JOIN Course C
	ON SC.Crs_Id = C.Crs_Id
INNER JOIN  Student S
	ON S.St_Id = SC.St_Id

-- 15. Display each instructor's name, the course name they teach, and their evaluation.
SELECT I.Ins_Name,
	   C.Crs_Name,
	   IC.Evaluation
FROM Ins_Course IC
INNER JOIN Instructor I
	ON IC.Ins_Id = I.Ins_Id
INNER JOIN Course C
	ON IC.Crs_Id = C.Crs_Id

-- 16. Display the names of students who took the course 'SQL Server' along with their grades.
SELECT S.St_Fname + ' ' + S.St_Lname AS Studens ,
	   C.Crs_Name,
	   SC.Grade
FROM Stud_Course SC
INNER JOIN Student S
	ON S.St_Id = SC.St_Id
INNER JOIN Course C
	ON C.Crs_Id = SC.Crs_Id
WHERE C.Crs_Name = 'SQL Server'

-- 17. Display all courses and the students enrolled in them, including courses that no student has taken yet.
SELECT C.Crs_Name,
       S.St_Fname + ' ' + S.St_Lname AS Students
FROM Course C
LEFT OUTER JOIN Stud_Course SC
    ON C.Crs_Id = SC.Crs_Id
LEFT OUTER JOIN Student S
    ON SC.St_Id = S.St_Id

-- Multi-table joins (3+ tables)
-- 18. Display each student's name, their department name, and the courses they are taking.
SELECT S.St_Fname + ' ' + S.St_Lname AS Students,
	   D.Dept_Name,
	   C.Crs_Name
FROM Stud_Course SC
INNER JOIN Student S
	ON S.St_Id = SC.St_Id
INNER JOIN Course C
	ON C.Crs_Id = SC.Crs_Id
INNER JOIN Department D
	ON S.Dept_Id = D.Dept_Id

-- 19. Display each course name, its topic name, and the name of the instructor teaching it.
SELECT C.Crs_Name,
	   T.Top_Name,
	   I.Ins_Name
FROM Ins_Course IC
INNER JOIN Instructor I
	ON IC.Ins_Id = I.Ins_Id
INNER JOIN Course C
	ON IC.Crs_Id = C.Crs_Id
INNER JOIN Topic T
	ON T.Top_Id =	C.Top_Id

-- 20. Display each department's name along with the name of its manager (from the Instructor table).
SELECT D.Dept_Name,
       I.Ins_Name AS Manager_Name
FROM Department D
INNER JOIN Instructor I
    ON D.Dept_Manager = I.Ins_Id

-- Use Joins with DML Queries
UPDATE SC 
SET SC.Grade += 10
FROM Stud_Course SC		
INNER JOIN Student S
	ON S.St_Id = SC.St_Id
WHERE S.St_Address = 'cairo'

DELETE SC 
FROM Course c 
INNER JOIN Stud_Course SC
	ON c.Crs_Id = SC.Crs_Id 
WHERE Crs_Name = 'SQL Server'

	 
