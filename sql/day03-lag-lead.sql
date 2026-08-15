-- ============================================================================
-- Day 03：偏移函数 LAG / LEAD
-- 适用：PostgreSQL / MySQL 8.0+ / SQL Server / Oracle / BigQuery
-- 核心概念：访问“当前行之前/之后”的行数据，做环比、差值、标志位等分析
-- ============================================================================

-- 示例数据：每日订单数（日期、订单量）
WITH daily_orders AS (
    SELECT DATE '2026-08-10' AS day, 120 AS orders
    UNION ALL SELECT DATE '2026-08-11', 155
    UNION ALL SELECT DATE '2026-08-12', 90
    UNION ALL SELECT DATE '2026-08-13', 210
    UNION ALL SELECT DATE '2026-08-14', 178
)
-- ----------------------------------------------------------------------------
-- 1. LAG(列, 偏移量, 默认值)：取“上一行”的值
--    应用：环比（与前一天比较）
-- ----------------------------------------------------------------------------
SELECT
    day,
    orders,
    LAG(orders) OVER (ORDER BY day)             AS prev_day_orders,  -- 前一天订单数
    orders - LAG(orders) OVER (ORDER BY day)    AS day_over_day_diff -- 较前日增减
FROM daily_orders;

-- 第一行 prev_day_orders 为 NULL，因为没有前一行

-- ----------------------------------------------------------------------------
-- 2. LEAD(列, 偏移量, 默认值)：取“下一行”的值
--    应用：判断趋势（比明天高还是低）、提前看后续值
-- ----------------------------------------------------------------------------
SELECT
    day,
    orders,
    LEAD(orders) OVER (ORDER BY day)                AS next_day_orders,
    CASE
        WHEN orders > LEAD(orders) OVER (ORDER BY day) THEN '下降'
        WHEN orders < LEAD(orders) OVER (ORDER BY day) THEN '上升'
        ELSE '持平'
    END                                             AS trend_vs_next
FROM daily_orders;

-- ----------------------------------------------------------------------------
-- 3. 自定义偏移量与默认值
--    LAG(orders, 2)：取前 2 天；LAG(orders, 1, 0)：前一天，没有则填 0
-- ----------------------------------------------------------------------------
SELECT
    day,
    orders,
    LAG(orders, 2, 0) OVER (ORDER BY day) AS two_days_ago,   -- 前 2 天，缺失填 0
    LAG(orders, 1, 0) OVER (ORDER BY day) AS prev_or_zero    -- 前一天，缺失填 0
FROM daily_orders;

-- ----------------------------------------------------------------------------
-- 4. 实战：计算“周同比”（与 7 天前比较），常用于 ETL 报表
-- ----------------------------------------------------------------------------
SELECT
    day,
    orders,
    LAG(orders, 7) OVER (ORDER BY day)          AS same_day_last_week,
    orders - LAG(orders, 7) OVER (ORDER BY day) AS wow_diff
FROM daily_orders;

-- ----------------------------------------------------------------------------
-- 5. 配合窗口条件使用：按部门分组，部门内与上一员工比
-- ----------------------------------------------------------------------------
WITH emp AS (
    SELECT 'A' AS dept, 'Alice' AS name, 8000 AS salary
    UNION ALL SELECT 'A', 'Bob',    9000
    UNION ALL SELECT 'A', 'Charlie', 9500
    UNION ALL SELECT 'B', 'Eva',   11000
    UNION ALL SELECT 'B', 'Frank', 9500
)
SELECT
    dept,
    name,
    salary,
    LAG(salary) OVER (PARTITION BY dept ORDER BY salary) AS prev_salary,
    salary - LAG(salary) OVER (PARTITION BY dept ORDER BY salary) AS gap
FROM emp
ORDER BY dept, salary;

-- ============================================================================
-- 今日小结
-- 1. LAG 看过去，LEAD 看未来，偏移量默认 1 行，可自定义
-- 2. 没有对应行时返回 NULL，可用第三个参数给默认值（如 0）
-- 3. 常用于：日环比 / 周同比 / 差值计算 / 相邻记录比较
-- ============================================================================
