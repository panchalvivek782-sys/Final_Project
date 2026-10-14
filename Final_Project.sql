CREATE DATABASE UniversityCourseManage;
USE UniversityCourseManage;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Instructors;
SELECT * FROM Enrollments;
SELECT * FROM Departments;

INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) 
VALUES (3, 'Alex', 'Jones', 'alex.j@email.com', '2001-03-12', '2023-09-01');

UPDATE Students 
SET Email = 'john.doe.new@email.com' 
WHERE StudentID = 1;

DELETE FROM Students 
WHERE StudentID = 3;

SELECT * FROM Students 
WHERE EnrollmentDate > '2022-12-31';

SELECT c.* 
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

SELECT CourseID, COUNT(StudentID) AS StudentCount
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

SELECT StudentID, FirstName, LastName 
FROM Students 
WHERE StudentID IN (
    SELECT StudentID FROM Enrollments WHERE CourseID = 101
) AND StudentID IN (
    SELECT StudentID FROM Enrollments WHERE CourseID = 102
);

SELECT DISTINCT s.StudentID, s.FirstName, s.LastName 
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

SELECT AVG(Credits) AS AverageCredits 
FROM Courses;

SELECT MAX(Email) 
FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

SELECT DepartmentID, COUNT(StudentID) AS StudentCount
FROM Students
GROUP BY DepartmentID;

SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

SELECT * FROM Students 
WHERE StudentID IN (
    SELECT StudentID 
    FROM Enrollments 
    GROUP BY CourseID 
    HAVING COUNT(StudentID) > 10
);

SELECT EXTRACT(YEAR FROM EnrollmentDate) AS EnrollmentYear 
FROM Students;

SELECT CONCAT(FirstName, ' ', LastName) AS InstructorFullName 
FROM Instructors;

SELECT EnrollmentID, StudentID, CourseID, 
       SUM(COUNT(StudentID)) OVER (ORDER BY EnrollmentDate, EnrollmentID) AS RunningTotal
FROM Enrollments
GROUP BY EnrollmentID, StudentID, CourseID, EnrollmentDate;

SELECT StudentID, FirstName, LastName, EnrollmentDate,
       CASE 
           WHEN TIMESTAMPDIFF(YEAR, EnrollmentDate, CURDATE()) > 4 THEN 'Senior'
           ELSE 'Junior'
       END AS StudentLabel
FROM Students;