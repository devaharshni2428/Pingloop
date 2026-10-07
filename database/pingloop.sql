
USE pingloop;
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('STAFF', 'HOD', 'VICE_PRINCIPAL', 'PRINCIPAL') NOT NULL,
    department VARCHAR(100) NOT NULL
);
DESCRIBE users;
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    register_number VARCHAR(30) NOT NULL UNIQUE,
    student_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    section VARCHAR(10) NOT NULL
);
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    staff_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('PRESENT', 'ABSENT') NOT NULL,

    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (staff_id) REFERENCES users(user_id),

    UNIQUE (student_id, date)
);
SHOW TABLES;
DESCRIBE attendance;

ALTER TABLE users
MODIFY department VARCHAR(50) NULL;

SELECT * FROM users;

SELECT COUNT(*) AS total_students
FROM students;

SELECT section, COUNT(*) AS student_count
FROM students
GROUP BY section
ORDER BY section;

SELECT *
FROM students
WHERE department = 'CSE'
  AND year = 3
  AND section = 'A';

SELECT student_id, register_number, student_name
FROM students
LIMIT 1;

INSERT INTO attendance
(student_id, staff_id, date, status)
VALUES
(1, 1, '2026-09-14', 'PRESENT');

SELECT * FROM attendance;

SELECT student_id, register_number, student_name
FROM students
LIMIT 2;
INSERT INTO attendance
(student_id, staff_id, date, status)
VALUES
(2, 1, '2026-09-14', 'ABSENT');

SELECT 
    s.register_number,
    s.student_name,
    s.department,
    s.year,
    s.section,
    a.date
FROM attendance a
JOIN students s 
    ON a.student_id = s.student_id
WHERE a.status = 'ABSENT'
  AND a.date = '2026-09-14';


INSERT INTO attendance
(student_id, staff_id, date, status)
VALUES
(2, 1, '2026-09-14', 'PRESENT');

SELECT * FROM attendance;
DELETE FROM attendance;
SELECT * FROM attendance;