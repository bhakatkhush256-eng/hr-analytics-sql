-- ============================================
-- PROJECT: HR Analytics
-- Database: hr_analytics_db
-- ============================================

CREATE DATABASE hr_analytics_db;
USE hr_analytics_db;

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(50),
    location        VARCHAR(50)
);

CREATE TABLE employees (
    employee_id   INT PRIMARY KEY,
    full_name     VARCHAR(50),
    gender        VARCHAR(10),
    age           INT,
    hire_date     DATE,
    job_title     VARCHAR(50),
    department_id INT,
    salary        DECIMAL(10,2),
    status        VARCHAR(20),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE performance (
    performance_id INT PRIMARY KEY,
    employee_id    INT,
    review_year    INT,
    rating         INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- ============================================
-- DATA
-- ============================================

INSERT INTO departments VALUES
(1, 'Engineering',     'Lahore'),
(2, 'Marketing',       'Karachi'),
(3, 'Human Resources', 'Islamabad'),
(4, 'Finance',         'Lahore'),
(5, 'Sales',           'Faisalabad');

INSERT INTO employees VALUES
(101, 'Ayesha Khan',    'Female', 28, '2020-03-15', 'Data Analyst',        1, 75000,  'Active'),
(102, 'Bilal Ahmed',    'Male',   35, '2018-07-01', 'Senior Engineer',     1, 120000, 'Active'),
(103, 'Sana Malik',     'Female', 26, '2021-01-10', 'Marketing Executive', 2, 55000,  'Active'),
(104, 'Usman Ali',      'Male',   40, '2015-05-20', 'Finance Manager',     4, 150000, 'Active'),
(105, 'Hira Baig',      'Female', 30, '2019-09-12', 'HR Specialist',       3, 65000,  'Active'),
(106, 'Zain Raza',      'Male',   27, '2022-04-01', 'Sales Executive',     5, 50000,  'Active'),
(107, 'Fatima Noor',    'Female', 32, '2017-11-30', 'Senior Analyst',      1, 95000,  'Active'),
(108, 'Hamza Sheikh',   'Male',   29, '2021-06-15', 'Marketing Manager',   2, 80000,  'Resigned'),
(109, 'Maira Javed',    'Female', 24, '2023-02-01', 'Junior Engineer',     1, 45000,  'Active'),
(110, 'Tariq Hussain',  'Male',   45, '2012-08-19', 'Finance Director',    4, 200000, 'Active'),
(111, 'Nadia Chaudhry', 'Female', 33, '2016-03-25', 'HR Manager',          3, 90000,  'Active'),
(112, 'Faisal Mehmood', 'Male',   31, '2020-10-05', 'Sales Manager',       5, 85000,  'Resigned'),
(113, 'Zara Qureshi',   'Female', 25, '2023-07-01', 'Data Analyst',        1, 60000,  'Active'),
(114, 'Danish Iqbal',   'Male',   38, '2014-12-10', 'Senior Engineer',     1, 130000, 'Active'),
(115, 'Amna Farooq',    'Female', 29, '2022-09-20', 'Sales Executive',     5, 52000,  'Active');

INSERT INTO performance VALUES
(1,  101, 2023, 5),
(2,  102, 2023, 4),
(3,  103, 2023, 3),
(4,  104, 2023, 5),
(5,  105, 2023, 4),
(6,  106, 2023, 2),
(7,  107, 2023, 5),
(8,  108, 2023, 3),
(9,  109, 2023, 4),
(10, 110, 2023, 5),
(11, 111, 2023, 4),
(12, 112, 2023, 2),
(13, 113, 2023, 3),
(14, 114, 2023, 4),
(15, 115, 2023, 3);

-- ============================================
-- ANALYSIS
-- ============================================

-- Total employees per department
SELECT d.department_name, COUNT(*) AS total_employees
FROM employees e JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name ORDER BY total_employees DESC;

-- Average salary by department
SELECT d.department_name, ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name ORDER BY avg_salary DESC;

-- Gender distribution
SELECT gender, COUNT(*) AS total,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) AS percentage
FROM employees GROUP BY gender;

-- Attrition rate
SELECT status, COUNT(*) AS total,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) AS percentage
FROM employees GROUP BY status;

-- Top 5 highest paid employees
SELECT full_name, job_title, salary
FROM employees ORDER BY salary DESC LIMIT 5;

-- Top performing employees
SELECT e.full_name, e.job_title, d.department_name, p.rating
FROM employees e
JOIN performance p ON e.employee_id = p.employee_id
JOIN departments d ON e.department_id = d.department_id
WHERE p.rating = 5;

-- Employees earning above company average
SELECT full_name, job_title, salary
FROM employees WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- Salary rank within each department
SELECT full_name, job_title, salary,
RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Years of experience per employee
SELECT full_name, job_title,
TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_experience
FROM employees ORDER BY years_experience DESC;

-- Full employee summary report
SELECT e.full_name, e.gender, e.job_title, d.department_name,
e.salary, p.rating, e.status,
TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_experience
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN performance p ON e.employee_id = p.employee_id
ORDER BY e.salary DESC;