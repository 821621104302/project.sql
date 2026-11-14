CREATE DATABASE hospital_management;
USE hospital_management;

-- ==========================================
-- 1. USER LOGIN TABLE
-- ==========================================

CREATE TABLE user_login(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE,
    password VARCHAR(255)
);

INSERT INTO user_login(username,password)
VALUES
('hari01','demo_pass_01'),
('arun02','demo_pass_02'),
('priya03','demo_pass_03'),
('rahul04','demo_pass_04'),
('sneha05','demo_pass_05');

-- ==========================================
-- 2. DOCTOR DETAILS TABLE
-- ==========================================

CREATE TABLE doctor_details(
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(50),
    specialization VARCHAR(40),
    consultation_fee INT,
    doctor_area VARCHAR(30)
);

INSERT INTO doctor_details
(doctor_name,specialization,consultation_fee,doctor_area)
VALUES
('Dr.Kumar','Cardiology',800,'Chennai'),
('Dr.Ravi','Neurology',1000,'Madurai'),
('Dr.Priya','Dermatology',500,'Trichy'),
('Dr.Anand','Orthopedic',700,'Chennai'),
('Dr.Sudha','Pediatrics',600,'Madurai');

-- ==========================================
-- 3. PATIENT DETAILS TABLE
-- ==========================================

CREATE TABLE patient_details(
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(50),
    mobile_number VARCHAR(15),
    patient_address VARCHAR(50),
    email VARCHAR(50),
    user_id INT,
    doctor_id INT,
    FOREIGN KEY(user_id) REFERENCES user_login(user_id),
    FOREIGN KEY(doctor_id) REFERENCES doctor_details(doctor_id)
);

INSERT INTO patient_details
(patient_name,mobile_number,patient_address,email,user_id,doctor_id)
VALUES
('Akila','9876543210','Chennai','akila@gmail.com',1,1),
('Mathan','9876543211','Madurai','mathan@gmail.com',2,2),
('Priya','9876543212','Trichy','priya@gmail.com',3,3),
('Rahul','9876543213','Chennai','rahul@gmail.com',4,4),
('Sneha','9876543214','Madurai','sneha@gmail.com',5,5);

-- ==========================================
-- 4. APPOINTMENT DETAILS TABLE
-- ==========================================

CREATE TABLE appointment_details(
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_date DATE,
    appointment_time TIME,
    appointment_status VARCHAR(20),
    patient_id INT,
    doctor_id INT,
    FOREIGN KEY(patient_id) REFERENCES patient_details(patient_id),
    FOREIGN KEY(doctor_id) REFERENCES doctor_details(doctor_id)
);

INSERT INTO appointment_details
(appointment_date,appointment_time,appointment_status,patient_id,doctor_id)
VALUES
('2026-01-10','10:00:00','Completed',1,1),
('2026-01-12','11:00:00','Pending',2,2),
('2026-01-15','12:00:00','Completed',3,3),
('2026-01-18','14:00:00','Cancelled',4,4),
('2026-01-20','15:00:00','Completed',5,5),
('2026-02-10','10:30:00','Pending',1,1);

-- ==========================================
-- 5. BILLING DETAILS TABLE
-- ==========================================

CREATE TABLE billing_details(
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_date DATE,
    bill_amount INT,
    bill_status VARCHAR(20),
    patient_id INT,
    appointment_id INT,
    FOREIGN KEY(patient_id) REFERENCES patient_details(patient_id),
    FOREIGN KEY(appointment_id) REFERENCES appointment_details(appointment_id)
);

INSERT INTO billing_details
(bill_date,bill_amount,bill_status,patient_id,appointment_id)
VALUES
('2026-01-10',800,'Paid',1,1),
('2026-01-12',1000,'Pending',2,2),
('2026-01-15',500,'Paid',3,3),
('2026-01-18',700,'Overdue',4,4),
('2026-01-20',600,'Paid',5,5);

-- ==========================================
-- 6. PAYMENT DETAILS TABLE
-- ==========================================

CREATE TABLE payment_details(
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
    paid_amount INT,
    payment_method VARCHAR(30),
    bill_id INT,
    FOREIGN KEY(bill_id) REFERENCES billing_details(bill_id)
);

INSERT INTO payment_details
(payment_date,paid_amount,payment_method,bill_id)
VALUES
('2026-01-10',800,'UPI',1),
('2026-01-12',0,'Not Paid',2),
('2026-01-15',500,'Credit Card',3),
('2026-01-18',0,'Not Paid',4),
('2026-01-20',600,'Debit Card',5);

-- ==========================================
-- 7. DISPLAY ALL RECORDS
-- ==========================================

SELECT * FROM user_login;
SELECT * FROM doctor_details;
SELECT * FROM patient_details;
SELECT * FROM appointment_details;
SELECT * FROM billing_details;
SELECT * FROM payment_details;

-- ==========================================
-- 8. DESCRIBE TABLES
-- ==========================================

DESCRIBE user_login;
DESCRIBE doctor_details;
DESCRIBE patient_details;
DESCRIBE appointment_details;
DESCRIBE billing_details;
DESCRIBE payment_details;

-- ==========================================
-- 9. ALTER TABLE OPERATIONS
-- ==========================================

ALTER TABLE patient_details
ADD COLUMN gender VARCHAR(10);

ALTER TABLE patient_details
MODIFY COLUMN patient_name VARCHAR(60);

ALTER TABLE patient_details
RENAME COLUMN patient_address TO patient_location;

UPDATE patient_details
SET patient_location='Coimbatore'
WHERE patient_id=1;

UPDATE doctor_details
SET consultation_fee=900
WHERE doctor_id=1;

-- Test table
CREATE TABLE test_table(
    id INT,
    name VARCHAR(30)
);

RENAME TABLE test_table TO test_table_new;

SELECT * FROM test_table_new;

TRUNCATE TABLE test_table_new;

DROP TABLE test_table_new;

-- ==========================================
-- 10. WHERE AND OPERATORS
-- ==========================================

-- Selected columns
SELECT patient_name,mobile_number,patient_location
FROM patient_details;

-- AND
SELECT * FROM doctor_details
WHERE consultation_fee>500
AND doctor_area='Chennai';

-- OR
SELECT * FROM doctor_details
WHERE doctor_area='Madurai'
OR doctor_area='Chennai';

-- NOT
SELECT * FROM billing_details
WHERE NOT bill_status='Paid';

-- IN
SELECT * FROM doctor_details
WHERE consultation_fee IN (500,600,800);

-- BETWEEN
SELECT * FROM doctor_details
WHERE consultation_fee BETWEEN 500 AND 900;

-- LIKE
SELECT * FROM patient_details
WHERE patient_name LIKE 'A%';

-- NULL
SELECT * FROM patient_details
WHERE email IS NULL;

SELECT * FROM patient_details
WHERE email IS NOT NULL;

-- ==========================================
-- 11. AGGREGATE FUNCTIONS
-- ==========================================

SELECT COUNT(*) AS total_patients
FROM patient_details;

SELECT MAX(consultation_fee) AS highest_fee,
MIN(consultation_fee) AS lowest_fee,
AVG(consultation_fee) AS average_fee
FROM doctor_details;

SELECT SUM(bill_amount) AS total_billing
FROM billing_details;

SELECT SUM(paid_amount) AS total_collection
FROM payment_details;

-- ==========================================
-- 12. GROUP BY
-- ==========================================

SELECT doctor_id,
COUNT(patient_id) AS total_patients
FROM patient_details
GROUP BY doctor_id;

SELECT patient_id,
SUM(bill_amount) AS total_bill
FROM billing_details
GROUP BY patient_id;

-- ==========================================
-- 13. HAVING
-- ==========================================

SELECT doctor_area,
COUNT(*) AS total_doctors
FROM doctor_details
GROUP BY doctor_area
HAVING COUNT(*)>1;

SELECT patient_id,
COUNT(bill_id) AS total_bills
FROM billing_details
GROUP BY patient_id
HAVING COUNT(bill_id)>1;

-- ==========================================
-- 14. ORDER BY AND LIMIT
-- ==========================================

SELECT * FROM doctor_details
ORDER BY consultation_fee DESC;

SELECT * FROM doctor_details
ORDER BY consultation_fee DESC
LIMIT 3;

-- ==========================================
-- 15. SUBQUERIES
-- ==========================================

SELECT * FROM doctor_details
WHERE consultation_fee>
(SELECT AVG(consultation_fee)
FROM doctor_details);

SELECT * FROM billing_details
WHERE bill_amount>
(SELECT AVG(bill_amount)
FROM billing_details);

-- Highest total bill customer
SELECT p.patient_id,p.patient_name,
SUM(b.bill_amount) AS total_bill
FROM patient_details p
JOIN billing_details b
ON p.patient_id=b.patient_id
GROUP BY p.patient_id,p.patient_name
HAVING SUM(b.bill_amount)=
(
    SELECT MAX(total_amount)
    FROM
    (
        SELECT SUM(bill_amount) AS total_amount
        FROM billing_details
        GROUP BY patient_id
    ) AS temp
);

-- ==========================================
-- 16. INNER JOIN
-- ==========================================

SELECT
p.patient_name,
d.doctor_name,
d.specialization,
a.appointment_date,
b.bill_amount,
pay.payment_method

FROM patient_details p

INNER JOIN doctor_details d
ON p.doctor_id=d.doctor_id

INNER JOIN appointment_details a
ON p.patient_id=a.patient_id

INNER JOIN billing_details b
ON a.appointment_id=b.appointment_id

LEFT JOIN payment_details pay
ON b.bill_id=pay.bill_id;

-- ==========================================
-- 17. LEFT JOIN
-- ==========================================

SELECT
p.patient_name,
a.appointment_id,
a.appointment_status

FROM patient_details p

LEFT JOIN appointment_details a
ON p.patient_id=a.patient_id;

-- ==========================================
-- 18. RIGHT JOIN
-- ==========================================

SELECT
a.appointment_id,
a.appointment_date,
p.patient_name

FROM patient_details p

RIGHT JOIN appointment_details a
ON p.patient_id=a.patient_id;

-- ==========================================
-- 19. UNION
-- ==========================================

SELECT patient_name AS name
FROM patient_details

UNION

SELECT doctor_name
FROM doctor_details;

-- ==========================================
-- 20. UNION ALL
-- ==========================================

SELECT patient_name AS name
FROM patient_details

UNION ALL

SELECT doctor_name
FROM doctor_details;

-- ==========================================
-- 21. PATIENTS WITHOUT PAYMENT RECORDS
-- ==========================================

SELECT DISTINCT
p.patient_id,
p.patient_name

FROM patient_details p

JOIN billing_details b
ON p.patient_id=b.patient_id

LEFT JOIN payment_details pay
ON b.bill_id=pay.bill_id

WHERE pay.payment_id IS NULL;

-- ==========================================
-- 22. ADDITIONAL REPORT QUERIES
-- ==========================================

-- Patient appointment report

SELECT
p.patient_name,
d.doctor_name,
d.specialization,
a.appointment_date,
a.appointment_status

FROM patient_details p

JOIN doctor_details d
ON p.doctor_id=d.doctor_id

JOIN appointment_details a
ON p.patient_id=a.patient_id;

-- Pending bills report

SELECT
p.patient_name,
b.bill_id,
b.bill_amount,
b.bill_status

FROM patient_details p

JOIN billing_details b
ON p.patient_id=b.patient_id

WHERE b.bill_status='Pending';

-- Doctor revenue report

SELECT
d.doctor_name,
SUM(b.bill_amount) AS total_billing

FROM doctor_details d

JOIN appointment_details a
ON d.doctor_id=a.doctor_id

JOIN billing_details b
ON a.appointment_id=b.appointment_id

GROUP BY d.doctor_id,d.doctor_name;

-- Payment method report

SELECT
payment_method,
SUM(paid_amount) AS total_collection

FROM payment_details

GROUP BY payment_method;

-- ==========================================
-- 23. TRANSACTION OPERATIONS
-- ==========================================

START TRANSACTION;

UPDATE patient_details
SET patient_location='Madurai'
WHERE patient_id=1;

SAVEPOINT sp1;

UPDATE billing_details
SET bill_status='Paid'
WHERE bill_id=2;

ROLLBACK TO sp1;

COMMIT;

-- ==========================================
-- 24. FINAL REPORT
-- ==========================================

SELECT
p.patient_name,
d.doctor_name,
d.specialization,
b.bill_amount,
b.bill_status,
pay.paid_amount,
pay.payment_method

FROM patient_details p

JOIN doctor_details d
ON p.doctor_id=d.doctor_id

JOIN billing_details b
ON p.patient_id=b.patient_id

LEFT JOIN payment_details pay
ON b.bill_id=pay.bill_id;

-- ==========================================
-- PROJECT COMPLETED
-- ==========================================
