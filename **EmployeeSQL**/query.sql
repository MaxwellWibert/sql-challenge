/*Drops tables in order from DEPENDENT to INDEPENDENT*/
DROP TABLE department_managers;
DROP TABLE dept_employees;
DROP TABLE salaries;
DROP TABLE titles;
DROP TABLE departments;
DROP TABLE employees;

/*Creates tables in order from INDEPENDENT to DEPENDENT*/
CREATE TABLE departments (
   dept_no  VARCHAR(15) PRIMARY KEY,
   name  VARCHAR(20)   NOT NULL
);
CREATE TABLE employees (
    emp_no INTEGER NOT NULL PRIMARY KEY,
    birthday_date DATE NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL
);

CREATE TABLE department_managers (
    dept_no VARCHAR(15) NOT NULL REFERENCES departments(dept_no),
    emp_no INTEGER NOT NULL REFERENCES employees(emp_no),
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);
CREATE TABLE dept_employees (
    emp_no INTEGER NOT NULL REFERENCES employees(emp_no),
    dept_no VARCHAR(15) NOT NULL REFERENCES departments(dept_no),
    to_date DATE NOT NULL,
    from_date DATE NOT NULL
);
CREATE TABLE salaries (
    emp_no INTEGER NOT NULL REFERENCES employees(emp_no),
    salary INTEGER NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);
CREATE TABLE titles (
    emp_no INTEGER NOT NULL REFERENCES employees(emp_no),
    title VARCHAR(20) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL
);

/*populate tables with data from csv files. 
Here absolute path is given simply because query file is being passed between various locations, making relative path difficult to maintain*/
COPY departments(dept_no,name)
FROM '/Users/maxwelltwibert/Desktop/Boots/Data Science/NU-CHI-DATA-PT-11-2019-U-C/09-SQL/SQL-HW/Instructions/data/departments.csv' DELIMITER ',' CSV HEADER;

COPY employees(emp_no, birthday_date, first_name, last_name, gender, hire_date)
FROM '/Users/maxwelltwibert/Desktop/Boots/Data Science/NU-CHI-DATA-PT-11-2019-U-C/09-SQL/SQL-HW/Instructions/data/employees.csv' DELIMITER ',' CSV HEADER;

COPY department_managers(dept_no, emp_no, from_date, to_date)
FROM '/Users/maxwelltwibert/Desktop/Boots/Data Science/NU-CHI-DATA-PT-11-2019-U-C/09-SQL/SQL-HW/Instructions/data/dept_manager.csv' DELIMITER ',' CSV HEADER;

COPY dept_employees(emp_no, dept_no, from_date, to_date)
FROM '/Users/maxwelltwibert/Desktop/Boots/Data Science/NU-CHI-DATA-PT-11-2019-U-C/09-SQL/SQL-HW/Instructions/data/dept_emp.csv' DELIMITER ',' CSV HEADER;

COPY salaries(emp_no, salary, from_date, to_date)
FROM '/Users/maxwelltwibert/Desktop/Boots/Data Science/NU-CHI-DATA-PT-11-2019-U-C/09-SQL/SQL-HW/Instructions/data/salaries.csv' DELIMITER ',' CSV HEADER;

COPY titles(emp_no, title, from_date, to_date)
FROM '/Users/maxwelltwibert/Desktop/Boots/Data Science/NU-CHI-DATA-PT-11-2019-U-C/09-SQL/SQL-HW/Instructions/data/titles.csv' DELIMITER ',' CSV HEADER;

/*drops all data from tables. used during testing to check data was loading in correctly
TRUNCATE TABLE departments;
TRUNCATE TABLE employees;
TRUNCATE TABLE department_managers;
TRUNCATE TABLE dept_employees;
TRUNCATE TABLE salaries;
TRUNCATE TABLE titles;
*/

/*show all employees' numbers, last and first names, gender and salaries*/
SELECT (emp_no, last_name, first_name, gender, salary) FROM employees INNER JOIN salaries 
ON employees.emp_no = salaries.emp_no

/*show all employees hired in 1986*/
SELECT * FROM employees
WHERE DATE_PART('year', hire_date) = 1986;

/*for each department manager shows department number, department name, the manager's employee number, 
last name, first name, and start and end employment dates.*/

SELECT departments.dept_no AS dept_no, name AS dept_name, emp_no, last_name, first_name, from_date, to_date
FROM departments 
INNER JOIN department_managers ON departments.dept_no = department_managers.dept_no
INNER JOIN employees ON department_managers.emp_no = employees.emp_no

/*List the department of each employee with the following information: employee number, last name, first name, and department name.*/
SELECT name AS dept_name, employees.emp_no AS emp_no, last_name, first_name 
FROM departments
INNER JOIN dept_employees ON departments.dept_no = dept_employees.dept_no
INNER JOIN employees ON dept_employees.emp_no = employees.emp_no

/*lists employees whose first name is "Hercules" and last name starts with "B"*/
SELECT * FROM employees
WHERE first_name = 'Hercules' 
AND last_name LIKE 'B%'

/*list employees in the sales department
including employee number, last name, first name, department name*/
SELECT employees.emp_no AS emp_no, last_name, first_name, dept_name
FROM employees
INNER JOIN dept_employees ON employees.emp_no = dept_employees.emp_no
INNER JOIN (SELECT * FROM departments WHERE dept_name = 'Sales') AS derived 
ON dept_employees.dept_no = derived.dept_no;

/*list all employees in sales and developments departments 
including employee number, last name, first name, and department name*/
SELECT employees.emp_no AS emp_no, last_name, first_name, dept_name
FROM employees
INNER JOIN dept_employees ON employees.emp_no = dept_employees.emp_no
INNER JOIN (SELECT * FROM departments 
            WHERE dept_name in ('Sales', 'Development')) AS derived 
ON dept_employees.dept_no = derived.dept_no;

/*in descending order list the frequency count of employee last names*/
SELECT last_name, count(last_name) 
FROM employees GROUP BY last_name
ORDER BY count(last_name) DESC;