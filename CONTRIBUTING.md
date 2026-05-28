# 贡献与 Git 约定

## 仓库定位

本仓 **`chenxi750328ai/neuromorphic-computing`** 与 **`chenxi750328ai/agent-jianghu`** 并列，专责类脑计算工程与文档，不依赖父目录 `/home/cx` 的 git 状态。

## 分支

- 禁止在本地 **`main`** 上堆叠未评审的日常提交；开发在 **`feature/*`**、**`fix/*`**、**`docs/*`** 完成。
- 合并进 **`main`** 经 Pull Request（或总裁授权的 hotfix）。

## 提交说明（必须）

每条 commit message **须包含负责人 AG 署名**之一：

- **陈正共**
- **ChenZhengGong**

示例：

```text
feat(phase1): MNIST SNN 训练脚本 [陈正共 · ChenZhengGong]
```

## 推送凭证

- 使用 **`/home/cx/agentfuture/.env`** 中的 **`CHENXI750328AI_GITHUB_USER`**、**`CHENXI750328AI_GITHUB_PAT`**。
- 勿将 `.env`、PAT、Webhook 写入本仓。

## 推送脚本（可选）

```bash
./scripts/push_github.sh
```

从仓库根目录读取上述环境变量并 `git push origin`。
