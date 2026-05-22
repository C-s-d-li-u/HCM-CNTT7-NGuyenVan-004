CREATE DATABASE library_db;
USE library_db;

-- TABLE: Readers
CREATE TABLE Readers (
    reader_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: Membership_Details
CREATE TABLE Membership_Details (
    card_id VARCHAR(20) PRIMARY KEY,
    reader_id INT UNIQUE,
    card_rank ENUM('Standard','VIP'),
    expiry_date DATE NOT NULL,
    citizen_id VARCHAR(20) NOT NULL UNIQUE,
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id)
);

-- TABLE: Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NOT NULL
);

-- TABLE: Books
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL UNIQUE,
    author VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- TABLE: Loan_Records
CREATE TABLE Loan_Records (
    loan_id INT PRIMARY KEY,
    reader_id INT,
    book_id INT,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    CHECK (due_date > borrow_date)
);

-- INSERT INTO Readers
INSERT INTO Readers VALUES
(1,'Nguyen Van A','anv@gmail.com','901234567','2022-01-15'),
(2,'Tran Thi B','btt@gmail.com','912345678','2022-05-20'),
(3,'Le Van C','cle@yahoo.com','922334455','2023-02-10'),
(4,'Pham Minh D','dpham@hotmail.com','933445566','2023-11-05'),
(5,'Hoang Anh E','ehoang@gmail.com','944556677','2023-01-12');

-- INSERT INTO Membership_Details
INSERT INTO Membership_Details VALUES
('CARD-001',1,'Standard','2025-01-15','123456789'),
('CARD-002',2,'VIP','2025-05-20','234567890'),
('CARD-003',3,'Standard','2024-02-10','345678901'),
('CARD-004',4,'VIP','2025-11-05','456789012'),
('CARD-005',5,'Standard','2026-01-12','567890123');

-- INSERT INTO Categories
INSERT INTO Categories VALUES
(1,'IT','Sách về công nghệ thông tin và lập trình'),
(2,'Kinh Te','Sách kinh doanh, tài chính, khởi nghiệp'),
(3,'Van Hoc','Tiểu thuyết, truyện ngắn, thơ'),
(4,'Ngoai Ngu','Sách học tiếng Anh, Nhật, Hàn'),
(5,'Lich Su','Sách nghiên cứu lịch sử, văn hóa');

-- INSERT INTO Books
INSERT INTO Books VALUES
(1,'Clean Code','Robert C. Martin',1,450000,10),
(2,'Dac Nhan Tam','Dale Carnegie',2,150000,50),
(3,'Harry Potter 1','J.K. Rowling',3,250000,5),
(4,'IELTS Reading','Cambridge',4,180000,0),
(5,'Dai Viet Su Ky','Le Van Huu',5,300000,20);

-- INSERT INTO Loan_Records
INSERT INTO Loan_Records VALUES
(101,1,1,'2023-11-15','2023-11-22','2023-11-20'),
(102,2,2,'2023-12-01','2023-12-08','2023-12-05'),
(103,1,3,'2024-01-10','2024-01-17',NULL),
(104,3,4,'2023-05-20','2023-05-27',NULL),
(105,4,1,'2023-01-18','2024-01-25',NULL);

-- UPDATE
UPDATE Loan_Records lr
JOIN Books b ON lr.book_id = b.book_id
JOIN Categories c ON b.category_id = c.category_id
SET lr.due_date = DATE_ADD(lr.due_date, INTERVAL 7 DAY)
WHERE c.category_name = 'Van Hoc'
AND lr.return_date IS NULL;

-- DELETE
DELETE FROM Loan_Records
WHERE return_date IS NOT NULL
AND borrow_date < '2023-10-01';

-- QUERY 1
SELECT book_id, title, price
FROM Books b
JOIN Categories c ON b.category_id = c.category_id
WHERE c.category_name = 'IT'
AND price > 200000;

-- QUERY 2
SELECT reader_id, full_name, email
FROM Readers
WHERE YEAR(created_at) = 2022
AND email LIKE '%@gmail.com';

-- QUERY 3
SELECT book_id, title, price
FROM Books
ORDER BY price DESC
LIMIT 5 OFFSET 2;

-- ADVANCED QUERY 1
SELECT lr.loan_id,
       r.full_name,
       b.title,
       lr.borrow_date,
       lr.return_date
FROM Loan_Records lr
JOIN Readers r ON lr.reader_id = r.reader_id
JOIN Books b ON lr.book_id = b.book_id
WHERE lr.return_date IS NULL;

-- ADVANCED QUERY 2
SELECT c.category_name,
       SUM(b.stock_quantity) AS total_stock
FROM Books b
JOIN Categories c ON b.category_id = c.category_id
GROUP BY c.category_name
HAVING total_stock > 10;

-- ADVANCED QUERY 3
SELECT r.full_name
FROM Readers r
JOIN Membership_Details m ON r.reader_id = m.reader_id
WHERE m.card_rank = 'VIP'
AND NOT EXISTS (
    SELECT 1
    FROM Loan_Records lr
    JOIN Books b ON lr.book_id = b.book_id
    WHERE lr.reader_id = r.reader_id
    AND b.price > 300000
);
