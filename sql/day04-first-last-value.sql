-- 题1 用employee表，查询每个员工的工资 + 所属部门最低工资（用FIRST_VALUE，按工资升序）.
SELECT
    name,
    department,
    salary,
    FIRST_VALUE(salary) OVER (
           PARTITION BY department
           ORDER BY salary ASC
       ) AS dept_min_salary
FROM employee;

-- 题2：用employee表，查询每个员工的工资 + 所属部门最高工资
-- （用LAST_VALUE，必须加ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING）
-- 测试数据（如果之前没建过）
SELECT name, department, salary,
       LAST_VALUE(salary) OVER (
           PARTITION BY department
           ORDER BY salary ASC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS dept_max_salary
FROM employee;

-- 题3：用daily_sales表，查询每天的销售额 + 截止当天的历史最高单日销售额（用两种写法：①MAX窗口函数 ②FIRST_VALUE）
-- 测试数据（如果之前没建过）
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

select
    daily_sales.sale_date,
    daily_sales.amount,
    max(daily_sales.amount) over (
        order by daily_sales.sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) as hist_max_amount
from daily_sales;
