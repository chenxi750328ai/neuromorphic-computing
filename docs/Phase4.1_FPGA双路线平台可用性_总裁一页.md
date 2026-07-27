# FPGA 双路线平台可用性 · 总裁一页（阶段结论）

> **日期**：2026-07-27 · **负责人**：陈正共  
> **裁决页**：[`Phase4.1_FPGA双路线平台可用性_总裁裁决.md`](./Phase4.1_FPGA双路线平台可用性_总裁裁决.md)（F1–F3 已勾）  
> **计划**：[`plans/2026-07-27-fpga-dual-path-platform-gate.md`](./plans/2026-07-27-fpga-dual-path-platform-gate.md)  
> **纪律**：合 PR ≠ 关口关闭；本页≠「Phase4.1 了结」。

---

## 两条路（截至今日）

| 路线 | 平台可用？ | 证据 | 人话 |
|------|------------|------|------|
| **R-A 加速（M-lif）** | **单算子 PL 可用**；整层入链仍待 | `fpga_ra_mlif_platform_gate.json` + `lif_step_overlay.{bit,hwh}` | host_proxy 定点 **98%**/100；PYNQ **board_pl PASS**（`lif_step_0`，序列 spike 与激励一致，~2.2ms/10step）。**≠** Atlas↔FPGA 整层 256 向量化入链；**≠** Phase4.1 关口关闭。 |
| **R-B 整网 FPGA** | **本板并行不可用**（合法结论） | `fpga_rb_fullnet_platform_gate.json` + `lif_step_utilization.rpt` | host 定点 **98%**；并行 379×256≈**97k LUT** > Z2 **53.2k**。时分复用另立项。 |

对照表：[`Phase4.1_探索规格与补数议程_V0.md`](./Phase4.1_探索规格与补数议程_V0.md) §4。

---

## 建议主路径（供你拍板，非自动定 BOM）

1. **近端可行**：以 **Atlas 整网** 为推理主链；FPGA 保留则走 **R-A**（下一步才是向量化 LIF / 真入链延迟，不是再赌整网并行）。  
2. **勿押**「Z2 上并行整网」——资源墙已立。  
3. **Phase8**：双路线已有可呈结论；是否解除 F2 开工闸 → **请你一句书面确认**（默认仍不开）。

---

## 仍在进行

- [x] Vivado `lif_step_overlay.{bit,hwh}` + PYNQ `board_pl`  
- [ ] 开 PR（`feature/phase4.1-fpga-dual-path`）；Summary 写清证据，不代合

---

*陈正共 · ChenZhengGong*
