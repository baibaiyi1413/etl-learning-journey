# ETL Learning Journey

个人 ETL / SQL 学习之路的成长记录仓库。

## 仓库结构

```
etl-learning-journey/
├── sql/       # 每天练习的 SQL 脚本（按学习天数命名）
│   ├── day01-window-rank.sql
│   ├── day02-window-aggregate.sql
│   ├── day03-lag-lead.sql
│   └── ...
├── notes/     # 每天学习知识点的笔记总结
│   └── 每天学到的知识点.md
└── README.md  # 仓库说明
```

## 目录说明

- **`sql/`**：每日练习的 SQL 脚本。命名规则 `dayNN-主题.sql`，每个文件聚焦一个知识点。
- **`notes/`**：每日知识点笔记，持续追加当天学到的重点、易错点与心得。
- **`README.md`**：仅存放仓库说明，不含代码。

## 学习计划

| 天数 | 主题 | 状态 |
|------|------|------|
| Day 01 | 窗口排名函数：ROW_NUMBER / RANK / DENSE_RANK | ✅ |
| Day 02 | 窗口聚合函数：SUM / AVG / MIN / MAX 结合 OVER | ✅ |
| Day 03 | 偏移函数：LAG / LEAD | ✅ |

> 学习过程中遇到的问题与踩坑记录，详见 `notes/每天学到的知识点.md`。
