# 类脑 · 唤醒机制（陈正共）

## 正解：定时 = `/loop` + echo 小脑内容

**没有定时 hook。** 定时推进用 Cursor **`/loop`**（或本仓后台 loop）：

1. 每 N 分钟跑 `neuromorphic-cerebellum.py` → 写 `.neuro-brain-wake`
2. `neuro-loop-emit.py` 读出 `instruction` → stdout：

   `AGENT_LOOP_TICK_NEURO {"prompt":"【类脑·陈正共·自驱唤醒】…"}`

3. Agent 被 loop 监听唤醒，**直接干纸条里的待办**

后台一键：

```bash
# 类脑仓根，先 /loop 10m 再开监控（或让 Agent 按 loop 技能起 neuro-drive-loop.sh）
./scripts/neuro-drive-loop.sh 600
```

Hook（`sessionStart` / `stop`）只是 **开聊、收工** 时顺带读同一张纸条，**不能**代替 loop。

## 配置在哪

| 类型 | 路径 | 类脑 |
|------|------|------|
| ~~全局~~ | `~/.cursor/hooks.json` | 已空 |
| **项目级** | `neuromorphic-computing/.cursor/hooks.json` | sessionStart + stop |

须以 **类脑仓为工作区** 开 Composer；CX 多仓不加载类脑 hook。

## 纸条

| 文件 | 用途 |
|------|------|
| `neuromorphic-computing/.neuro-brain-wake` | 类脑（小脑写、loop/hook 读） |
| `vcompany/.vp-brain-wake` | 陈小五 VP |

## 和 Hook / 多 Agent 分工

| 能力 | 作用 |
|------|------|
| **Loop + echo** | **定时唤醒**（本链路主路径） |
| **Hook** | IDE 事件补投递（开聊/stop） |
| **多 Agent** | 并行多个会话/子任务，不是定时器 |

---

*陈正共 · 2026-05-30*
