# Phase4.1 F4 双通 · 测试方案与用例要点（简版）

> **轨道**：研究轨 IPD · TE 裁剪  
> **范围**：R-A Atlas↔PYNQ M-lif（A2）+ R-B 分时整网（B1）  
> **依据**：`docs/plans/2026-07-28-fpga-both-routes-runthrough.md` · `docs/QA_验收记录_Phase4.1_FPGA双通.md`  
> **分支/PR**：`feature/phase4.1-fpga-both-runthrough` · PR #17

---

## 1. 测试目的

验证 Phase4.1 F4「双通」两条路线在 **功能上跑通**，且分类结果与 host Q16.16 定点参考一致：

| 路线 | 目的 |
|------|------|
| **R-A A2** | Atlas 主链（fc\*/lif2 Q16.16）经 **TCP:9530** 与 PYNQ **lif1 PL TMD** 入链；端到端 pred 与 host 一致 |
| **R-B B1** | PYNQ 板内 **分时整网**（fc\* 在 PS、lif1+lif2 在 PL 单核 TMD）跑通分类；pred 与 host 一致 |

**不替代**：G-LAT 延迟尺子、并行 256-LIF 阵列可用性、Phase8/STDP。

---

## 2. 测试拓扑

### 2.1 R-A A2（Atlas↔PYNQ M-lif）

```
Atlas (192.168.137.2)                    PYNQ (192.168.137.3:9530)
┌─────────────────────────┐              ┌─────────────────────────┐
│ fc1/fc2 + lif2 Q16.16   │  TCP RPC     │ lif1 PL TMD (单核分时)   │
│ 客户端 forward          │◄────────────►│ daemon :9530            │
└─────────────────────────┘              └─────────────────────────┘
         │                                         │
         └──────── host Q16.16 参考 pred ──────────┘
```

- **Checkpoint**：`/home/cx/neuromorphic-computing/runs/20260527T092534Z/checkpoint.pt`
- **Bitstream**：`fpga/bitstreams/lif_step_overlay.bit`
- **证据 JSON**：`docs/phase4_poc_evidence/fpga_ra_atlas_mlif_inchain_gate.json`

### 2.2 R-B B1（分时整网）

```
PYNQ Z2 (192.168.137.3)
┌──────────────────────────────────────────────┐
│ PS: fc1/fc2 Q16.16 定点 MAC                   │
│ PL: lif1 + lif2 单核 TMD 分时（time_mux）      │
│ mode: time_mux_not_parallel                   │
└──────────────────────────────────────────────┘
         │
         └── host Q16.16 参考 pred
```

- **Split**：`R-B TMD fullnet: lif1+lif2 on PL single-core; fc* on PS Q16.16`
- **证据 JSON**：`docs/phase4_poc_evidence/fpga_rb_fullnet_runthrough_gate.json`

---

## 3. 通过准则（功能）

| 维度 | 阈值 | 说明 |
|------|------|------|
| 样本数 **n** | **≥ 20** | MNIST 测试集前 N 条 |
| **pred_match_rate** | **≥ 0.98** | 板侧/Atlas 侧 pred 与 host Q16.16 pred 逐样本一致率 |
| **acc_vs_label** | **≥ 0.90** | 板侧/Atlas 侧 pred 对 MNIST 标签准确率 |
| 延迟披露 | 必填 `avg_*_ms` | 机读 JSON 须含平均延迟字段，供 QA 诚实披露 |
| 机读 verdict | `PASS_*` | A2：`PASS_ra_atlas_fpga_mlif`；B1：`PASS_rb_tmd_fullnet` |

**基线实测（2026-07-28，摘自证据 JSON，勿外推）**

| 路线 | n | pred_match / rate | acc_vs_label | avg 延迟（ms/样本） |
|------|---|-------------------|--------------|---------------------|
| R-A A2 | 20 | 20 / **1.0** | **0.95** | avg_e2e_ms=**993.333** · avg_fpga_lif1_ms=**914.047** |
| R-B B1 | 20 | 20 / **1.0** | **0.95** | avg_e2e_ms=**1450.013** · avg_lif_pl_ms=**976.41** |

---

## 4. 非目标（明确排除）

| 项 | 说明 |
|----|------|
| **G-LAT 延迟验收** | 双通路径约 **0.9–1.5 s/样本**，比 Atlas 整网 daemon G-LAT（p50≈3.5 ms）慢 **两个数量级以上**；**功能 PASS ≠ G-LAT 过** |
| **并行整网 PASS** | R-B 并行 256-LIF 阵列仍 **LUT 资源墙 FAIL**（`fpga_rb_fullnet_platform_gate.json`）；**分时整网 PASS 不得写成并行整网可用** |
| Phase8 / STDP | 不在 F4 范围 |
| 换更大 FPGA | 不在 F4 范围 |

**禁止假绿**：不得把「pred 一致」写成「G-LAT 过」；不得把「分时整网 PASS」写成「并行整网可用」。

---

## 5. 可复现命令

前置：仓库根目录、`.venv` 已装依赖；PYNQ/Atlas 网络可达；bitstream 已部署。

```bash
cd /home/cx/neuromorphic-computing

# R-B B1：板上分时整网（重跑 + 写 JSON + gate）
.venv/bin/python3 scripts/phase4_fpga_rb_fullnet_runthrough_gate.py --samples 20 --gate

# R-A A2：Atlas↔PYNQ M-lif 入链（重跑 + 写 JSON + gate）
.venv/bin/python3 scripts/phase4_fpga_ra_atlas_mlif_inchain_gate.py --samples 20 --gate

# F4 双通机读证据汇总（只校验已落盘 JSON + QA 披露，不重跑板上）
.venv/bin/python3 scripts/phase4_fpga_both_runthrough_evidence_gate.py --gate
```

**证据路径（gate 校验）**

- A2：`docs/phase4_poc_evidence/fpga_ra_atlas_mlif_inchain_gate.json`
- B1：`docs/phase4_poc_evidence/fpga_rb_fullnet_runthrough_gate.json`
- QA：`docs/QA_验收记录_Phase4.1_FPGA双通.md`

---

## 6. 用例表

| 用例 ID | 路线 | 前置条件 | 步骤要点 | 期望结果 | 证据 |
|---------|------|----------|----------|----------|------|
| **TC-F4-A2** | R-A Atlas↔PYNQ M-lif | PYNQ lif1 daemon `:9530` 已起；Atlas 可达 `192.168.137.2`；checkpoint/bit 就绪 | 1) host 跑 Q16.16 得参考 pred<br>2) Atlas 客户端 fc\*/lif2 + RPC lif1，N=20<br>3) 比对 pred_match 与 acc | n≥20；pred_match_rate≥0.98；acc≥0.90；verdict=`PASS_ra_atlas_fpga_mlif` | `fpga_ra_atlas_mlif_inchain_gate.json` |
| **TC-F4-B1** | R-B 分时整网 | PYNQ SSH 可达；bitstream 已加载 | 1) host 参考 pred<br>2) 板内 PS fc\* + PL lif1/lif2 TMD 整网前向 N=20<br>3) 比对 pred 与 acc | n≥20；pred_match_rate≥0.98；acc≥0.90；mode=`time_mux_not_parallel`；verdict=`PASS_rb_tmd_fullnet` | `fpga_rb_fullnet_runthrough_gate.json` |
| **TC-F4-EVID** | 双通机读门禁 | A2/B1 JSON 已落盘；QA 记录含延迟披露 | 执行 `phase4_fpga_both_runthrough_evidence_gate.py --gate` | exit 0；打印 `PASS phase4_fpga_both_runthrough_evidence_gate`；校验 n/match/acc/avg\_\*\_ms 及 QA 关键词 | 脚本 stdout + 上述 JSON |
| **TC-F4-LAT-DISCLOSE** | 延迟诚实披露 | A2/B1 已 PASS | 1) 从 JSON 读取 `avg_e2e_ms` 等<br>2) 对照 QA §0「远逊 G-LAT」表述<br>3) 确认未将双通 PASS 等同于 G-LAT | A2≈993 ms/样本、B1≈1450 ms/样本已记入 QA；文档含 MMIO/分时/远逊 G-LAT 说明；**不要求** p50≤5 ms | QA 记录 §0·§1 · JSON `avg_*_ms` |

---

## 7. 回归与关联（参考，非 F4 主验）

| ID | 说明 | 备注 |
|----|------|------|
| F4-A1 | 同板 R-A 单核分时向量入链 | 既有 `fpga_ra_mlif_vector_inchain_gate` 保持绿（回归） |
| F4-PAR | R-B 并行资源墙 | **FAIL（合法）**；外推 LUT 不拟合 Z2，不作为 F4 双通阻塞项 |

---

## 8. TE 结论（要点）

- F4 双通 **功能验收口径**：pred 与 host 一致（≥98%）+ 标签 acc（≥90%）+ n≥20 + 延迟字段落盘。
- **延迟与 G-LAT 解耦**：双通仅证明「能算对」，不证明「算得快」。
- **并行与分时解耦**：B1 证明分时整网可跑通；并行阵列仍 FAIL，不得混写。

---

*陈正齐 · TE · 2026-07-28*
