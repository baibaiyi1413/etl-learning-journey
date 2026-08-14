# etl-learning-journey
这是我日常练习的仓库
-- 1
CREATE TABLE IF NOT EXISTS employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

INSERT INTO employee (name, department, salary) VALUES
('张三', '技术部', 8000),
('李四', '技术部', 9500),
('王五', '技术部', 9000),
('赵六', '技术部', 9500),
('钱七', '市场部', 7000),
('孙八', '市场部', 8500),
('周九', '市场部', 7800),
('吴十', '市场部', 6500),
('郑十一', '人事部', 6000),
('冯十二', '人事部', 6200);
SELECT
    department,
    name,
    salary,
    salary_rank
FROM (
    SELECT
        department,
        name,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employee
) t
WHERE salary_rank <= 3
ORDER BY department, salary_rank;
-- 2
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    create_time DATETIME,
    amount DECIMAL(10,2)
);

INSERT INTO orders (user_id, create_time, amount) VALUES
(1, '2026-08-01 10:30:00', 99.00),
(1, '2026-08-10 15:45:00', 199.00),
(1, '2026-08-13 09:20:00', 59.00),
(2, '2026-07-25 18:00:00', 299.00),
(2, '2026-08-12 21:35:00', 159.00),
(3, '2026-06-01 12:00:00', 399.00);

SELECT
    user_id,
    order_id,
    create_time,
    amount
FROM (
    SELECT
        user_id,
        order_id,
        create_time,
        amount,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY create_time DESC) AS rn
    FROM orders
) t
WHERE rn = 1
ORDER BY user_id;
-- 3
CREATE TABLE IF NOT EXISTS scores (
    student_id INT,
    subject VARCHAR(50),
    score DECIMAL(5,2)
);

INSERT INTO scores (student_id, subject, score) VALUES
(1, '语文', 90),
(2, '语文', 85),
(3, '语文', 90),
(4, '语文', 70),
(1, '数学', 75),
(2, '数学', 68),
(3, '数学', 72),
(4, '数学', 55),
(1, '英语', 93),
(2, '英语', 89),
(3, '英语', 94),
(4, '英语', 83);

SELECT
    subject,
    student_id,
    score
FROM (
    SELECT
        student_id,
        subject,
        score,
        DENSE_RANK() OVER (PARTITION BY subject ORDER BY score DESC) AS score_rank
    FROM scores
) t
WHERE score_rank = 2
ORDER BY subject, student_id;
