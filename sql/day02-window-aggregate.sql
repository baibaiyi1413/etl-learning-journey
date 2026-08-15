-- 你今天的3道题
-- 题1：用employee表，查询每个员工的工资 + 所属部门的平均工资，结果按部门、工资降序排列
SELECT
    name,
    department,
    salary,
    dept_avg_salary
FROM (
    SELECT
        name,
        department,
        salary,
        AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
    FROM employee
) t
ORDER BY department, salary DESC;

-- 题2：假设有一张日销售表daily_sales(sale_date, amount)，查询每天的销售额 + 从年初到当天的累计销售额

-- 测试数据
CREATE TABLE IF NOT EXISTS daily_sales (
    sale_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO daily_sales (sale_date, amount) VALUES
('2026-01-01', 1000.00),
('2026-01-02', 1500.00),
('2026-01-03', 800.00),
('2026-01-04', 2000.00),
('2026-01-05', 1200.00);

SELECT
    sale_date,
    amount,
    yearly_cumulative
FROM (
    SELECT
        sale_date,
        amount,
        SUM(amount) OVER (
            ORDER BY sale_date 
            ROWS BETWEEN INTERVAL 0 YEAR PRECEDING AND CURRENT ROW
        ) AS yearly_cumulative
    FROM daily_sales
) t
ORDER BY sale_date;
-- 题3：用daily_sales表，查询每天的销售额 + 最近3天的移动平均销售额（包括当天）
SELECT
    sale_date,
    amount,
    moving_avg_3
FROM (
    SELECT
        sale_date,
        amount,
        AVG(amount) OVER (
            ORDER BY sale_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS moving_avg_3
    FROM daily_sales
) t
ORDER BY sale_date;
