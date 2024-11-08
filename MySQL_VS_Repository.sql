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



-- Problem 6
-- Difficulty - Easy

-- Calculate the average score for each project, but only include projects where more than one team member has provided a score.
-- Your output should include the project ID and the calculated average score for each qualifying project.

-- Tables: project_data

CREATE TABLE project_data (
    project_id INT,
    team_member_id INT,
    score INT,
    date DATE
);
INSERT INTO project_data (project_id, team_member_id, score, date) VALUES
(101, 1, 5, '2024-07-25'),
(101, 2, 8, '2024-09-22'),
(101, 2, 3, '2024-09-24'),
(101, 2, 5, '2024-10-14'),
(101, 6, 6, '2024-10-14'),
(101, 6, 5, '2024-09-13'),
(102, 6, 3, '2024-09-04'),
(102, 6, 4, '2024-08-17'),
(102, 6, 3, '2024-08-22'),
(102, 3, 3, '2024-08-26'),
(102, 1, 5, '2024-08-04'),
(102, 1, 2, '2024-10-12'),
(102, 1, 1, '2024-08-17'),
(102, 4, 2, '2024-10-07'),
(102, 4, 2, '2024-08-24'),
(102, 5, 4, '2024-07-16'),
(102, 5, 4, '2024-08-06'),
(103, 6, 4, '2024-10-14'),
(103, 6, 6, '2024-08-23'),
(103, 4, 4, '2024-08-23'),
(103, 4, 93, '2024-08-14'),
(103, 1, 90, '2024-09-02'),
(103, 1, 34, '2024-08-03'),
(103, 2, 100, '2024-10-02'),
(103, 2, 95, '2024-08-29'),
(103, 3, 72, '2024-07-30'),
(103, 3, 87, '2024-08-15'),
(103, 3, 40, '2024-07-23'),
(104, 4, 8, '2024-08-17'),
(104, 4, 8, '2024-09-17'),
(104, 6, 0, '2024-07-19'),
(104, 6, 6, '2024-10-07'),
(104, 6, 7, '2024-10-15'),
(104, 1, 10, '2024-07-27'),
(104, 1, 7, '2024-09-11'),
(104, 1, 2, '2024-09-13'),
(104, 3, 4, '2024-09-05'),
(104, 3, 6, '2024-08-04'),
(104, 3, 7, '2024-10-04'),
(104, 2, 0, '2024-08-29'),
(104, 2, 6, '2024-09-23'),
(105, 6, 1, '2024-07-09'),
(105, 6, 37, '2024-08-30'),
(105, 6, 14, '2024-10-13'),
(105, 1, 5, '2024-07-18'),
(106, 10, 7, '2024-11-01'),
(107, 11, 9, '2024-11-02');


-- My Answer:

SELECT
	project_id,
	AVG(score) AS average_score
FROM project_data
GROUP BY project_id
HAVING COUNT(team_member_id) > 1;


-- Problem 7
-- Difficulty - Easy

-- Count the unique activities for each user, ensuring users with no activities are also included.
-- The output should show each user's ID and their activity count, with zero for users who have no activities.

-- Tables: user_profiles, activity_log

CREATE TABLE user_profiles (
    user_id INT,
    name VARCHAR(255),
    email VARCHAR(255),
    signup_date DATE,
    PRIMARY KEY (user_id)
);


CREATE TABLE activity_log (
    user_id INT,
    activity_type VARCHAR(50),
    activity_timestamp DATE
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

INSERT INTO activity_log (user_id, activity_type, activity_timestamp) VALUES
(1, 'like', '2024-09-22'),
(1, 'comment', '2024-07-27'),
(2, 'purchase', '2024-07-16'),
(2, 'comment', '2024-07-24'),
(2, 'like', '2024-09-13'),
(3, 'like', '2024-10-05'),
(3, 'logout', '2024-09-07'),
(3, 'share', '2024-10-05'),
(6, 'share', '2024-07-10'),
(6, 'login', '2024-07-08'),
(7, 'purchase', '2024-07-07'),
(7, 'logout', '2024-07-19'),
(7, 'share', '2024-08-06'),
(8, 'comment', '2024-08-13'),
(8, 'logout', '2024-08-04'),
(8, 'login', '2024-10-04'),
(9, 'like', '2024-07-26'),
(9, 'purchase', '2024-10-03'),
(9, 'login', '2024-08-08'),
(9, 'share', '2024-09-28'),
(9, 'purchase', '2024-08-15'),
(10, 'logout', '2024-08-08'),
(10, 'logout', '2024-09-29'),
(1, 'comment', '2024-07-27'),
(3, 'like', '2024-10-05');


-- My Answer:

SELECT 
	u.user_id,
    COUNT(DISTINCT activity_type) AS activity_count
FROM user_profiles u
	LEFT JOIN activity_log a ON u.user_id = a.user_id
GROUP BY u.user_id;


-- Problem 8
-- Difficulty - Medium

-- Identify the top 3 posts with the highest like counts for each channel. 
-- Assign a rank to each post based on its like count, allowing for gaps in ranking when posts have the same number of likes.
-- For example, if two posts tie for 1st place, the next post should be ranked 3rd, not 2nd. Exclude any posts with zero likes.
-- The output should display the channel name, post ID, post creation date, and the like count for each post.


-- Tables: posts, channels

CREATE TABLE posts (
    post_id INT,
    channel_id INT,
    created_at DATE,
    likes INT,
    shares INT,
    comments INT,
    PRIMARY KEY (post_id),
    FOREIGN KEY (channel_id) REFERENCES channels(channel_id)
);

CREATE TABLE channels (
    channel_id INT,
    channel_name VARCHAR(255),
    channel_type VARCHAR(50),
    PRIMARY KEY (channel_id)
);

INSERT INTO posts (post_id, channel_id, created_at, likes, shares, comments) VALUES
(101, 1, '2024-08-16', 0, 10, 7),
(102, 1, '2024-08-07', 0, 18, 6),
(103, 1, '2024-07-24', 11, 3, 7),
(104, 1, '2024-09-13', 3, 1, 7),
(105, 1, '2024-09-07', 38, 0, 11),
(106, 1, '2024-08-10', 0, 11, 8),
(107, 1, '2024-08-19', 0, 9, 11),
(108, 1, '2024-08-08', 0, 14, 13),
(109, 1, '2024-08-17', 0, 19, 8),
(110, 1, '2024-10-04', 0, 6, 4),
(111, 2, '2024-07-26', 39, 3, 8),
(112, 2, '2024-08-08', 14, 8, 9),
(113, 2, '2024-08-15', 2, 14, 11),
(114, 2, '2024-07-28', 0, 7, 14),
(115, 2, '2024-09-02', 0, 3, 1),
(116, 2, '2024-10-03', 2, 5, 5),
(117, 2, '2024-10-03', 0, 17, 9),
(118, 2, '2024-08-24', 34, 3, 13),
(119, 2, '2024-07-04', 0, 7, 13),
(120, 2, '2024-07-12', 0, 15, 12),
(121, 3, '2024-07-17', 0, 12, 8),
(122, 3, '2024-09-08', 0, 0, 8),
(123, 3, '2024-07-28', 9, 0, 11),
(124, 3, '2024-09-29', 0, 10, 2),
(125, 3, '2024-07-18', 0, 2, 0),
(126, 3, '2024-10-02', 0, 8, 11),
(127, 3, '2024-09-30', 9, 11, 1),
(128, 3, '2024-09-04', 0, 4, 2),
(129, 3, '2024-08-24', 40, 2, 0),
(130, 3, '2024-06-30', 0, 13, 2),
(131, 4, '2024-10-06', 5, 13, 6),
(132, 4, '2024-09-10', 0, 14, 9),
(133, 4, '2024-08-26', 0, 6, 0),
(134, 4, '2024-08-16', 32, 4, 6),
(135, 4, '2024-09-22', 0, 3, 12),
(136, 4, '2024-09-05', 0, 18, 5),
(137, 4, '2024-09-09', 2, 12, 13),
(138, 4, '2024-08-11', 6, 11, 11),
(139, 4, '2024-07-15', 30, 10, 9),
(140, 4, '2024-07-07', 0, 0, 0),
(141, 5, '2024-09-10', 0, 2, 6),
(142, 5, '2024-07-29', 0, 8, 13),
(143, 5, '2024-08-31', 0, 9, 11),
(144, 5, '2024-09-13', 0, 8, 3),
(145, 5, '2024-08-06', 49, 19, 11),
(146, 5, '2024-08-29', 0, 16, 4),
(147, 5, '2024-08-12', 0, 16, 1),
(148, 5, '2024-10-05', 28, 4, 0),
(149, 5, '2024-10-06', 19, 1, 4),
(150, 5, '2024-08-24', 26, 5, 6);

INSERT INTO channels (channel_id, channel_name, channel_type) VALUES
(1, 'TechNews', 'news'),
(2, 'GameStream', 'gaming'),
(3, 'SocialBuzz', 'social_media'),
(4, 'DailyUpdates', 'news'),
(5, 'ProGamer', 'gaming');


-- My Answer:


WITH highest_likes AS (
SELECT
    p.post_id,
    c.channel_id,
    c.channel_name,
    p.created_at,
    p.likes,
    RANK() OVER(PARTITION BY c.channel_id ORDER BY p.likes DESC) AS Highest_Likes_Ranking
FROM channels c
	JOIN posts p ON c.channel_id = p.channel_id
GROUP BY c.channel_id, c.channel_name, p.post_id, p.created_at
)

SELECT
	hl.channel_name,
	hl.post_id,
    hl.created_at,
    hl.likes
FROM highest_likes hl
	WHERE Highest_Likes_Ranking <= 3;



