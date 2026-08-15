-- ============================================================================
-- Day 01：窗口排名函数 ROW_NUMBER / RANK / DENSE_RANK / NTILE
-- 适用：PostgreSQL / MySQL 8.0+ / SQL Server / Oracle / BigQuery
-- 核心概念：窗口函数在“不改变原始行数”的前提下，为每行计算一个值
-- ============================================================================

-- 示例数据：员工表（部门、姓名、薪资）
WITH emp AS (
    SELECT 'A' AS dept, 'Alice'   AS name, 8000 AS salary
    UNION ALL SELECT 'A', 'Bob',    9000
    UNION ALL SELECT 'A', 'Charlie', 9000
    UNION ALL SELECT 'A', 'David',  7500
    UNION ALL SELECT 'B', 'Eva',   11000
    UNION ALL SELECT 'B', 'Frank', 9500
    UNION ALL SELECT 'B', 'Grace', 9500
)
-- ----------------------------------------------------------------------------
-- 1. ROW_NUMBER()：顺序编号，每条记录唯一，不并列
--    应用：取每组前 N 条、去重
-- ----------------------------------------------------------------------------
SELECT
    dept,
    name,
    salary,
    ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) AS rn
FROM emp;

-- 结果（A 部门示例）：David 是 4 号，即使有同薪也不并列

-- ----------------------------------------------------------------------------
-- 2. RANK()：排名，同薪并列，但会“跳号”（1,1,3）
--    应用：体育比赛式排名
-- ----------------------------------------------------------------------------
SELECT
    dept,
    name,
    salary,
    RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS rk
FROM emp;

-- 结果（A 部门）：Bob 和 Charlie 同为第 1 名，David 直接是第 3 名

-- ----------------------------------------------------------------------------
-- 3. DENSE_RANK()：排名，同薪并列，不跳号（1,1,2）
--    应用：按名次取 Top N（榜单类需求）
-- ----------------------------------------------------------------------------
SELECT
    dept,
    name,
    salary,
    DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dr
FROM emp;

-- 结果（A 部门）：Bob 和 Charlie 第 1，David 第 2，连续不跳号

-- ----------------------------------------------------------------------------
-- 4. 三者对比（一次查询看差异）
-- ----------------------------------------------------------------------------
SELECT
    dept,
    name,
    salary,
    ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) AS rn,
    RANK()       OVER (PARTITION BY dept ORDER BY salary DESC) AS rk,
    DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dr
FROM emp
ORDER BY dept, salary DESC;

-- ----------------------------------------------------------------------------
-- 5. NTILE(n)：将每组数据均匀分成 n 个桶（分组分桶）
--    应用：数据抽样、评分分档（如按成绩分 5 档）
-- ----------------------------------------------------------------------------
SELECT
    dept,
    name,
    salary,
    NTILE(2) OVER (PARTITION BY dept ORDER BY salary DESC) AS bucket
FROM emp;

-- 结果：A 部门 4 人 → 前 2 人桶 1，后 2 人桶 2

-- ============================================================================
-- 今日小结
-- 1. 三者核心区别：是否并列（ROW_NUMBER 永不并列）、是否跳号（RANK 跳 / DENSE_RANK 不跳）
-- 2. PARTITION BY 分组，ORDER BY 决定排名顺序（DESC 从高到低）
-- 3. 窗口函数不能直接写在 WHERE 中，需包一层子查询再过滤
-- ============================================================================
