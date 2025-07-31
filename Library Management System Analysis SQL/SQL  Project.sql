-- LIBRARY MANAGEMENT SYSTEM ANALYSIS

--DATABASE CREATION
--Creating Database
CREATE DATABASE LibraryDB	-- database name

-- (TABLES CREATION + INSERTING VALUES)
-- Creating Books Table

DROP TABLE IF EXISTS Books
CREATE TABLE Books	--table name
	(
		 BookID INT PRIMARY KEY,
		 Title VARCHAR(100),
		 Author VARCHAR(100),
		 Genre VARCHAR(50),
		 TotalCopies INT
	)

-- Creating Members Table

DROP TABLE IF EXISTS Members
CREATE TABLE Members 
	(
		 MemberID INT PRIMARY KEY,
		 Name VARCHAR(100),
		 JoinDate DATE
	)

-- Creating Issues Table

DROP TABLE IF EXISTS Issues
CREATE TABLE Issues 
	(
		 IssueID INT PRIMARY KEY,
		 BookID INT,
		 MemberID INT,
		 IssueDate DATE,
		 DueDate DATE,
		 FOREIGN KEY (BookID) REFERENCES Books(BookID),
		 FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
	)

-- Creating Returns Table

DROP TABLE IF EXISTS Returns
CREATE TABLE Returns 
	(
		 ReturnID INT PRIMARY KEY,
		 IssueID INT,
		 ReturnDate DATE,
		 FOREIGN KEY (IssueID) REFERENCES Issues(IssueID)
	)

--Inserting into Books Table
INSERT INTO Books VALUES
	(1, 'The Alchemist', 'Paulo Coelho', 'Fiction', 5),
	(2, 'Data Science Handbook', 'Jake VanderPlas', 'Education', 3),
	(3, 'Harry Potter', 'J.K. Rowling', 'Fantasy', 7),
	(4, 'Clean Code', 'Robert C. Martin', 'Programming', 4),
	(5, 'Think Like a Monk', 'Jay Shetty', 'Self-Help', 6)

--Inserting into Members Table
INSERT INTO Members VALUES
	(1, 'Anita Sharma', '2023-01-15'),
	(2, 'Ravi Kumar', '2023-03-22'),
	(3, 'Sneha Reddy', '2023-06-01'),
	(4, 'Mohit Verma', '2023-07-10'),
	(5, 'Divya Joshi', '2023-09-05')

--Inserting into Issues Table
INSERT INTO Issues VALUES
	(1, 1, 1, '2024-12-01', '2024-12-15'),
	(2, 2, 2, '2024-12-05', '2024-12-20'),
	(3, 3, 3, '2024-12-10', '2024-12-25'),	select*from Books select*from Members select*from Issues select*from Returns
	(4, 4, 1, '2025-01-10', '2025-01-24'),
	(5, 3, 4, '2025-01-15', '2025-01-29')

--Inserting into Returns Table
INSERT INTO Returns VALUES
	(1, 1, '2024-12-13'),
	(2, 2, '2024-12-18'),
	(3, 3, '2024-12-30'),
	(4, 4, '2025-01-25')

select * from Books
select * from Members
select * from Issues
select * from Returns

--PROJECT TASK
-- Task 1: Get all members who joined after June 2023
SELECT * FROM Members 
WHERE JoinDate > '2023-06-01'

-- Task 2: Find all books in the 'Programming' genre
SELECT * FROM Books
WHERE Genre = 'Programming'

-- Task 3: Find books with total copies between 4 and 6
SELECT * FROM Books
WHERE TotalCopies BETWEEN 4 AND 6

-- Task 4: Find members whose name contains 'a'
SELECT * FROM Members
WHERE Name LIKE '%a%'

-- Task 5: Count how many issues each book has
SELECT BookID, COUNT(*) AS IssueCount
FROM Issues
GROUP BY BookID

-- Task 6: List books by number of total copies (highest first)
SELECT * FROM Books
ORDER BY TotalCopies DESC

-- Task 7: Show all books with available copies
SELECT 
    b.Title,
    b.TotalCopies,
    (b.TotalCopies - COUNT(i.IssueID)) AS AvailableCopies
FROM Books b
LEFT JOIN Issues i ON b.BookID = i.BookID
GROUP BY b.BookID, b.Title, b.TotalCopies

-- Task 8: Most borrowed books
SELECT 
    b.Title, COUNT(i.BookID) AS TimesBorrowed
FROM Issues i
JOIN Books b ON i.BookID = b.BookID
GROUP BY b.Title, b.BookID
ORDER BY TimesBorrowed DESC

-- Task 9: Active members (who borrowed more than 1 book)
SELECT 
    m.Name,
    COUNT(i.IssueID) AS TotalBooksBorrowed
FROM Members m
JOIN Issues i ON m.MemberID = i.MemberID
GROUP BY m.Name, i.MemberID
HAVING COUNT(i.IssueID) > 1

-- Task 10: Overdue books (not returned by due date)
SELECT 
    i.IssueID,
    b.Title,
    m.Name,
    i.DueDate,
    COALESCE(CONVERT(VARCHAR, r.ReturnDate, 23), 'Not Returned') AS ReturnDate
FROM Issues i
JOIN Books b ON i.BookID = b.BookID
JOIN Members m ON i.MemberID = m.MemberID
LEFT JOIN Returns r ON i.IssueID = r.IssueID
WHERE (r.ReturnDate IS NULL AND i.DueDate < CAST(GETDATE() AS DATE))
   OR (r.ReturnDate > i.DueDate)

-- Task 11:  Monthly book issue trend
SELECT 
    FORMAT(IssueDate, 'yyyy-MM') AS Month,
    COUNT(*) AS TotalIssues
FROM Issues
GROUP BY FORMAT(IssueDate, 'yyyy-MM')
ORDER BY Month

