# Water Commits 🚰

一个用于水 commit 的专用仓库，展示如何批量生成 Git 提交记录。

## 统计

- **总 commit 数**: 2147
- **作者**: WeepingDogel
- **时间跨度**: 过去 365 天

## 使用方法

```bash
# 水 N 个 commit，默认前缀 update
./water.sh 100

# 自定义前缀
./water.sh 200 fix

# 指定作者信息
./water.sh 500 feat
```

## Commit 消息类型

- `fix` - 修复类
- `feat` - 功能类
- `chore` - 杂项
- `wtf` - 纯粹为了水 😈

## 文件结构

```
water.sh          # 水 commit 脚本
README.md         # 本文件
```

> 注：每次 commit 附带的占位文件已清理，实际项目中请保留有意义的文件变更。
