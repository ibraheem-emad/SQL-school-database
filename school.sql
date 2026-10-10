CREATE DATABASE IF NOT EXISTS school;
USE school;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ;

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  code VARCHAR(20) NOT NULL UNIQUE
) ;

CREATE TABLE enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  grade DECIMAL(5,2),
  enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_enr_student FOREIGN KEY (student_id) REFERENCES students(id),
  CONSTRAINT fk_enr_course  FOREIGN KEY (course_id)  REFERENCES courses(id)
) ;

INSERT INTO students (name, email) VALUES
('Omar Haddad',    'omar.haddad@example.com'),
('Layla Mansour',  'layla.mansour@example.com'),
('Youssef Khalil', 'youssef.khalil@example.com'),
('Fatima Nasser',  'fatima.nasser@example.com'),
('Karim Saleh',    'karim.saleh@example.com');

INSERT INTO courses (title, code) VALUES
('Databases',       'CS201'),
('Algorithms',      'CS202'),
('Web Development', 'CS203');

INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 88), (1, 2, 92),
(2, 1, 65), (2, 3, 70),
(3, 2, 78), (3, 3, 85), (3, 1, 90),
(4, 1, 55), (4, 2, 72),
(5, 2, 81), (5, 3, 77);

SELECT * FROM students;
SELECT * FROM courses;

SELECT e.id, s.name, c.title, e.grade, e.enrolled_at
FROM enrollments e
INNER JOIN students s ON s.id = e.student_id
INNER JOIN courses  c ON c.id = e.course_id
ORDER BY s.name, c.title;

INSERT INTO students (name, email) VALUES ('Mariam Aziz', 'mariam.aziz@example.com');

SELECT s.id, s.name
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.id
WHERE e.id IS NULL;

SELECT c.title, ROUND(AVG(e.grade), 2) AS avg_grade
FROM courses c
JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id, c.title;

SELECT s.name, ROUND(AVG(e.grade), 2) AS avg_grade
FROM students s
JOIN enrollments e ON e.student_id = s.id
GROUP BY s.id, s.name
HAVING AVG(e.grade) > 75;

UPDATE enrollments SET grade = 75 WHERE student_id = 2 AND course_id = 1;

SELECT s.name, c.title, e.grade
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses  c ON c.id = e.course_id
WHERE e.student_id = 2 AND e.course_id = 1;

DELETE FROM enrollments WHERE student_id = 4 AND course_id = 1;

SELECT * FROM enrollments WHERE student_id = 4 AND course_id = 1;
SELECT * FROM students WHERE id = 4;
SELECT * FROM courses  WHERE id = 1;

DELETE FROM students WHERE id = 4;

ALTER TABLE enrollments DROP FOREIGN KEY fk_enr_student;
ALTER TABLE enrollments DROP INDEX fk_enr_student;

EXPLAIN SELECT * FROM enrollments WHERE student_id = 3;

CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);

EXPLAIN SELECT * FROM enrollments WHERE student_id = 3;

ALTER TABLE enrollments
  ADD CONSTRAINT fk_enr_student FOREIGN KEY (student_id) REFERENCES students(id);