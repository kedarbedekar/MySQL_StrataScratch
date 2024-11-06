-- MySQL
-- Problem 1
-- Difficulty - Hard

-- Identify users who started a session and placed an order on the same day. 
-- For these users, calculate the total number of orders and the total order value for that day.
-- Your output should include the user, the session date, the total number of orders, and the total order value for that day.

-- Tables: sessions, order_summary

CREATE TABLE sessions (
    session_id INT,
    user_id INT,
    session_date DATETIME
);
CREATE TABLE order_summary (
    order_id INT,
    user_id INT,
    order_value INT,
    order_date DATETIME
);

INSERT INTO sessions (session_id, user_id, session_date) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-02'),
(3, 3, '2024-01-05'),
(4, 3, '2024-01-05'),
(5, 4, '2024-01-03'),
(6, 4, '2024-01-03'),
(7, 5, '2024-01-04'),
(8, 5, '2024-01-04'),
(9, 3, '2024-01-05'),
(10, 5, '2024-01-04');

INSERT INTO order_summary (order_id, user_id, order_value, order_date) VALUES
(1, 1, 152, '2024-01-01'),
(2, 2, 485, '2024-01-02'),
(3, 3, 398, '2024-01-05'),
(4, 3, 320, '2024-01-05'),
(5, 4, 156, '2024-01-03'),
(6, 4, 121, '2024-01-03'),
(7, 5, 238, '2024-01-04'),
(8, 5, 70, '2024-01-04'),
(9, 3, 152, '2024-01-05'),
(10, 5, 171, '2024-01-04');

-- My Answer:
SELECT
    s.user_id,
    s.session_date,
    COUNT(DISTINCT o.order_id) AS total_no_of_order,
    SUM(DISTINCT o.order_value) AS total_order_value
FROM sessions s
	JOIN order_summary o ON s.user_Id = o.user_id AND s.session_date = o.order_date
GROUP BY s.user_id, s.session_date
ORDER BY s.user_id;


-- Problem 2
-- Difficulty - Medium

-- Identify the top 3 areas with the highest customer density. Customer density = (total number of unique customers in the area / area size).
-- Your output should include the area name and its calculated customer density.

-- Tables: transaction_records, stores

CREATE TABLE stores (
    store_id INT,
    store_location VARCHAR(50),
    store_open_date DATETIME,
    area_name VARCHAR(50),
    area_size INT
);

CREATE TABLE transaction_records (
    transaction_id INT,
    customer_id INT,
    transaction_amount INT,
    transaction_date DATETIME,
    store_id INT
);



INSERT INTO stores (store_id, store_location, store_open_date, area_name, area_size) VALUES
(1, 'City Center', '2018-09-11', 'Area A', 121),
(2, 'Suburbs', '2019-08-10', 'Area B', 238),
(3, 'Downtown', '2012-05-11', 'Area C', 70),
(4, 'Industrial Area', '2013-07-19', 'Area D', 152),
(5, 'Mall', '2013-02-05', 'Area E', 171);

INSERT INTO transaction_records (transaction_id, customer_id, transaction_amount, transaction_date, store_id) VALUES
(1, 3, 189, '2024-01-21', 4),
(2, 7, 495, '2024-01-29', 1),
(3, 11, 207, '2024-02-17', 5),
(4, 11, 483, '2024-01-08', 5),
(5, 8, 290, '2024-02-14', 2),
(6, 5, 209, '2024-01-09', 5),
(7, 4, 465, '2024-02-17', 2),
(8, 8, 194, '2024-02-05', 1),
(9, 8, 465, '2024-01-15', 4),
(10, 3, 70, '2024-01-18', 4),
(11, 6, 383, '2024-02-06', 4),
(12, 5, 74, '2024-02-20', 5),
(13, 2, 263, '2024-02-10', 1),
(14, 8, 339, '2024-01-05', 5),
(15, 12, 150, '2024-01-03', 5),
(16, 14, 326, '2024-01-07', 1),
(17, 6, 154, '2024-02-24', 1),
(18, 2, 40, '2024-02-12', 1),
(19, 12, 348, '2024-01-05', 1),
(20, 5, 186, '2024-02-24', 4),
(21, 1, 293, '2024-01-30', 3),
(22, 12, 407, '2024-01-19', 3),
(23, 10, 108, '2024-01-27', 1),
(24, 6, 335, '2024-02-14', 3),
(25, 13, 33, '2024-02-04', 3),
(26, 12, 261, '2024-01-11', 1),
(27, 9, 284, '2024-02-06', 3),
(28, 1, 365, '2024-01-15', 5),
(29, 11, 72, '2024-02-01', 2),
(30, 11, 405, '2024-02-18', 2);

-- My Answer:
WITH cte AS (
SELECT
    s.store_id,
    s.area_name,
    COUNT(t.customer_id) AS Total_Unique_Customers,
    s.area_size,
    (COUNT(t.customer_id) / s.area_size) AS Customer_Density,
    RANK() OVER(ORDER BY (COUNT(t.customer_id) / s.area_size) DESC) AS Area_Rank
FROM stores s
	JOIN transaction_records t ON s.store_id = t.store_id
GROUP BY s.store_id, s.area_name, s.area_size
)

SELECT 
    t.area_name,
    t.Customer_Density
FROM cte t
    WHERE Area_Rank <= 3;

-- Problem 3
-- Difficulty - Medium

-- Identify the second-highest salary in each department.
-- Your output should include the department, the second highest salary, and the employee ID. 
-- Do not remove duplicate salaries when ordering salaries, and apply the rankings without a gap in the rank. 
-- For example, if multiple employees share the same highest salary, the second-highest salary will be the next salary that is lower than the highest salaries.

-- Tables: employee_data

CREATE TABLE employee_data (
    employee_id INT,
    department VARCHAR(50),
    salary INT,
    hire_date DATETIME,
    employee_rank FLOAT
);

INSERT INTO employee_data (employee_id, department, salary, hire_date, employee_rank) VALUES
(10, 'Engineering', 60000, '2019-02-09', 1),
(8, 'HR', 120000, '2016-05-26', 1),
(7, 'HR', 90000, '2017-12-19', 2),
(3, 'HR', 75000, '2017-01-18', 3),
(4, 'Marketing', 120000, '2017-05-07', 1),
(9, 'Marketing', 120000, '2019-09-03', 1),
(1, 'Marketing', 110000, '2015-01-23', 2),
(5, 'Marketing', 110000, '2019-05-05', 2),
(12, 'Marketing', 110000, '2017-09-03', 2),
(11, 'Marketing', 90000, '2016-12-01', 3),
(14, 'Marketing', 90000, '2015-07-10', 3),
(13, 'Marketing', 50000, '2019-12-13', 4),
(2, 'Sales', 90000, '2015-09-11', 1),
(6, 'Sales', 60000, '2016-04-20', 2),
(15, 'Sales', 60000, '2017-08-16', 2);

-- My Answer:

WITH salary_rank AS(
SELECT
	e.employee_id,
    e.department,
    e.salary,
    DENSE_RANK() OVER(PARTITION BY e.salary ORDER BY e.department DESC) AS salary_rank
FROM employee_data e
ORDER BY e.employee_id
)

SELECT
	s.employee_id,
    s.department,
    s.salary
FROM salary_rank s
	WHERE salary_rank = 2
ORDER BY employee_id;


-- Problem 4
-- Difficulty - Medium

-- Summarize the activity of each customer by calculating their total number of interactions and content items created.
-- Your output should include the customer's ID, the total number of interactions, and the total number of content items.

-- Tables: customer_interactions, user_content

CREATE TABLE customer_interactions (
    interaction_id INT,
    customer_id INT,
    interaction_type VARCHAR(50),
    interaction_date DATETIME
);

CREATE TABLE user_content (
    content_id INT,
    customer_id INT,
    content_type VARCHAR(50),
    content_text VARCHAR(255)
);

INSERT INTO customer_interactions (interaction_id, customer_id, interaction_type, interaction_date) VALUES
(1, 7, 'click', '2024-02-13'),
(2, 4, 'view', '2024-01-25'),
(3, 8, 'like', '2024-02-18'),
(4, 5, 'like', '2024-01-27'),
(5, 7, 'view', '2024-02-28'),
(6, 10, 'view', '2024-02-11'),
(7, 3, 'view', '2024-01-28'),
(8, 7, 'like', '2024-02-29'),
(9, 8, 'like', '2024-01-16'),
(10, 5, 'click', '2024-01-15'),
(11, 4, 'click', '2024-02-16'),
(12, 8, 'like', '2024-02-20'),
(13, 8, 'view', '2024-02-13'),
(14, 3, 'view', '2024-02-24'),
(15, 6, 'click', '2024-02-21');

INSERT INTO user_content (content_id, customer_id, content_type, content_text) VALUES
(1, 2, 'comment', 'hello world! this is a TEST.'),
(2, 8, 'comment', 'what a great day'),
(3, 4, 'comment', 'WELCOME to the event.'),
(4, 2, 'comment', 'e-commerce is booming.'),
(5, 6, 'comment', 'Python is fun!!'),
(6, 6, 'review', '123 numbers in text.'),
(7, 10, 'review', 'special chars: @#$$%^&*()'),
(8, 4, 'comment', 'multiple CAPITALS here.'),
(9, 6, 'review', 'sentence. and ANOTHER sentence!'),
(10, 2, 'post', 'goodBYE!');


-- My Answer:

SELECT
	c.customer_id,
    COUNT(c.interaction_id) AS total_interactions,
    COUNT(u.content_id) AS total_content_created
FROM customer_interactions c
	JOIN user_content u ON c.customer_id = u.customer_id
GROUP BY c.customer_id;


-- Problem 5
-- Difficulty - Hard

-- Identify users who have logged at least one activity within 30 days of their registration date.
-- Your output should include the user’s ID, registration date, and a count of the number of activities logged within that 30-day period.
-- Do not include users who did not perform any activity within this 30-day period.

-- Tables: user_profiles, user_activities

CREATE TABLE user_profiles (
    user_id INT,
    name VARCHAR(50),
    email VARCHAR(100),
    signup_date DATETIME
);

CREATE TABLE user_activities (
    user_id INT,
    activity_type VARCHAR(50),
    activity_date DATETIME
);

INSERT INTO user_profiles (user_id, name, email, signup_date) VALUES
(1, 'Alice', 'alice@example.com', '2024-06-26'),
(2, 'Bob', 'bob@example.com', '2023-07-29'),
(3, 'Charlie', 'charlie@example.com', '2022-05-30'),
(4, 'David', 'david@example.com', '2024-01-10'),
(5, 'Eva', 'eva@example.com', '2024-06-22'),
(6, 'Frank', 'frank@example.com', '2024-07-27'),
(7, 'Grace', 'grace@example.com', '2022-11-06'),
(8, 'Hank', 'hank@example.com', '2024-09-16'),
(9, 'Ivy', 'ivy@example.com', '2023-01-31'),
(10, 'Jack', 'jack@example.com', '2024-06-07');

INSERT INTO user_activities (user_id, activity_type, activity_date) VALUES
(1, 'share', '2024-01-18'),
(1, 'purchase', '2024-02-13'),
(2, 'logout', '2024-01-14'),
(2, 'logout', '2024-02-26'),
(2, 'share', '2024-01-16'),
(2, 'share', '2024-01-18'),
(2, 'share', '2024-01-24'),
(3, 'logout', '2024-02-29'),
(4, 'login', '2024-01-29'),
(4, 'share', '2024-01-01'),
(6, 'login', '2024-02-13'),
(7, 'comment', '2024-02-20'),
(8, 'comment', '2024-02-04'),
(8, 'login', '2024-02-28'),
(10, 'login', '2024-01-28');


-- My Answer:

SELECT 
    up.user_id, 
    up.signup_date, 
    COUNT(ua.activity_type) AS activity_count
FROM 
    user_profiles up
    JOIN user_activities ua ON up.user_id = ua.user_id
    WHERE ua.activity_date BETWEEN up.signup_date AND DATE_ADD(up.signup_date, INTERVAL 30 DAY)
GROUP BY 
    up.user_id, up.signup_date
HAVING 
    activity_count > 0;