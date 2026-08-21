题 1:SELECT
    sale_date,
    amount,
    LAG(amount, 1) OVER (ORDER BY sale_date) AS 前一天销售额,
    ROUND(
        (amount - LAG(amount, 1) OVER (ORDER BY sale_date)) 
        / LAG(amount, 1) OVER (ORDER BY sale_date) * 100, 
        2
    ) AS 环比增长率_百分比
FROM daily_sales
ORDER BY sale_date;
题 2:SELECT
    sale_date,
    amount,
    LEAD(amount, 1) OVER (ORDER BY sale_date) AS 后一天销售额,
    amount - LAG(amount, 1) OVER (ORDER BY sale_date) AS 与前一天差额
FROM daily_sales
ORDER BY sale_date;
题 3:WITH login_with_rn AS (
    SELECT
        user_id,
        login_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) AS rn
    FROM user_logins
),
grouped AS (
    SELECT
        user_id,
        login_date,
        DATE_SUB(login_date, INTERVAL rn DAY) AS group_flag
    FROM login_with_rn
),
consecutive_counts AS (
    SELECT
        user_id,
        group_flag,
        COUNT(*) AS consecutive_days
    FROM grouped
    GROUP BY user_id, group_flag
    HAVING COUNT(*) >= 3
)
SELECT DISTINCT user_id
FROM consecutive_counts
ORDER BY user_id;
