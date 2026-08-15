-- ============================================================================
-- Day 02：窗口聚合函数 SUM / AVG / MIN / MAX / COUNT 结合 OVER
-- 适用：PostgreSQL / MySQL 8.0+ / SQL Server / Oracle / BigQuery
-- 核心概念：聚合函数 + OVER 后，结果保留每一行，且能看到“累计/整体”视角
-- ============================================================================

-- 示例数据：每月销售明细（月份、部门、销售额）
WITH sales AS (
    SELECT '2026-01' AS month, 'A' AS dept, 100 AS amount
    UNION ALL SELECT '2026-01', 'B', 150
    UNION ALL SELECT '2026-02', 'A', 120
    UNION ALL SELECT '2026-02', 'B', 90
    UNION ALL SELECT '2026-03', 'A', 80
    UNION ALL SELECT '2026-03', 'B', 200
)
-- ----------------------------------------------------------------------------
-- 1. 不加 PARTITION BY：对整表聚合，每行都带上总数
--    应用：算占比（每行 / 总量）
-- ----------------------------------------------------------------------------
SELECT
    month,
    dept,
    amount,
    SUM(amount) OVER ()                       AS total_amount,          -- 全表合计
    ROUND(100.0 * amount / SUM(amount) OVER (), 2) AS pct_of_total       -- 占比 %
FROM sales;

-- ----------------------------------------------------------------------------
-- 2. 加 PARTITION BY dept：按部门分组聚合
--    应用：部门内平均、与部门均值对比
-- ----------------------------------------------------------------------------
SELECT
    month,
    dept,
    amount,
    AVG(amount) OVER (PARTITION BY dept)      AS dept_avg,   -- 本部门均值
    amount - AVG(amount) OVER (PARTITION BY dept) AS diff_from_avg -- 与均值差值
FROM sales;

-- ----------------------------------------------------------------------------
-- 3. PARTITION BY + ORDER BY：累计值（running total）
--    ORDER BY 让窗口从“当前行之前的行”一直累计到当前行
--    应用：累计销售额、累计打卡天数
-- ----------------------------------------------------------------------------
SELECT
    month,
    dept,
    amount,
    SUM(amount) OVER (PARTITION BY dept ORDER BY month) AS running_total,
    MAX(amount) OVER (PARTITION BY dept ORDER BY month) AS running_max, -- 截至当前的最大值
    MIN(amount) OVER (PARTITION BY dept ORDER BY month) AS running_min  -- 截至当前的最小值
FROM sales
ORDER BY dept, month;

-- ----------------------------------------------------------------------------
-- 4. 自定义窗口范围（ROWS BETWEEN ... AND ...）
--    应用：移动平均 / 近 N 月求和
-- ----------------------------------------------------------------------------
SELECT
    month,
    dept,
    amount,
    -- 当前行 + 前 1 行，共 2 行做平均（2 期移动平均）
    AVG(amount) OVER (PARTITION BY dept ORDER BY month
                      ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS ma2
FROM sales
ORDER BY dept, month;

-- 其他常用范围写法：
--   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW   -- 前 2 行到当前行
--   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- 起点到当前行（等价于累计）
--   ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING  -- 当前行到末尾

-- ============================================================================
-- 今日小结
-- 1. SUM() OVER () 不分组给总量；SUM() OVER (PARTITION BY x) 分组给小计
-- 2. 加了 ORDER BY 的聚合窗口 = 累计值（跑批数据、移动平均常用）
-- 3. ROWS BETWEEN 可以精确控制“窗口框”，移动平均必备
-- ============================================================================
