create database library_management;
use library_management;

create table readers(
	reader_id int primary key  ,
    full_name varchar(50) not null,
    email varchar(50) not null unique,
    phone_number varchar(10) not null unique,
    created_at date 
);

create table membership_details(
	card_id varchar(10) primary key ,
    reader_id int ,
    card_rank varchar(50),
    expiry_date date not null,
    citizen_id varchar(10) not null unique,
    foreign key (reader_id) references readers(reader_id)
);

create table categories (
	category_id int primary key,
    category_name varchar(50) not null unique,
    description text not null
);

create table books (
	book_id int primary	key ,
    title varchar(50) not null unique,
    author varchar(50) not null,
    category_id int ,
    price varchar(100) not null default 0 check (price>0), 
    stock_quantity varchar(50) not null default 0 check(stock_quantity>=0),
    foreign key (category_id) references categories(category_id)

);

create table loan_records (
	loan_id int primary key ,
    reader_id int ,
    book_id int,
    brorrow_date date not null ,
    due_date date not null ,
    return_date date,
    foreign key (reader_id) references readers(reader_id),
    foreign key (book_id) references books(book_id)
);

insert into readers
values
(1,'Nguyen Van A','anv@gmail.com','901234567','2022-01-15'),
(2,'Tran Thi B','btt@gmail.com','91234567','2022-05-20'),
(3,'Le van C','cle@gmail.com','922334455','2023-02-10'),
(4,'Phan Minh D','dpham@gmail.com','93445566','2023-11-05'),
(5,'Hoang Anh E','ehoang@gmail.com','944556677','2023-01-12');

insert into membership_details
values
('CARD-001',1,'Standard','2025-01-15','123456789'),
('CARD-002',2,'VIP'     ,'2025-05-20','234567890'),
('CARD-003',3,'Standard','2024-02-10','345678901'),
('CARD-004',4,'VIP'     ,'2025-11-05','456789012'),
('CARD-005',5,'Standard','2026-01-12','567890123');

insert into categories
values
(1,'IT','Sách về công nghệ thông tin và lập trình'),
(2,'Kinh Te','Sach kinh doanh, tai chinh khoi nghiep'),
(3,'Van Hoc','Tieu thuyet ,truyen ngan,tho'),
(4,'Ngoai ngu','sach hoc tieng anh,nhat ,han'),
(5,'lich su','sach nghien cuu lich su ,van hoa' );

insert into books 
values
(1, 'clean code' , 'robertc.martin',1,45000,10),
(2, 'Dac nhan tam' , 'Dale camrnegie',2,15000,50),
(3, 'Harry potter' , 'j.k.rowling',3,25000,5),
(4, 'IELTS reading' , 'cambridge',4,18000,0),
(5, 'Dai viet ky su' , 'Le Van Huu',5,30000,20);

insert into loan_records
values
(101,1,1,2023-11-15,2023-11-22,2023-11-20),
(102,2,2,2023-12-01,2023-12-08,2023-12-05),
(103,1,3,2024-01-10,2024-01-17,null),
(104,3,4,2023-05-20,2023-05-27,null),
(105,4,1,2023-01-18,2024-01-25,null);

-- câu 2 


-- câu 3

delete loan_records 
where 



-- phần 2 

-- câu 1 	
select book_id, title,price from books
 category_name = 'IT' and price > 200000;
 
 -- câu 2 
 
 select reader_id, full_name,email 
 from readers 
 where created_at = 2022 and email= '@gmail.com';
 
 -- câu 3
 
