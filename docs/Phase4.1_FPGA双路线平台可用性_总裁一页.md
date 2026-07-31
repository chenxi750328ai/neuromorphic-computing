# FPGA 双路线平台可用性 · 总裁一页（阶段结论）

> **日期**：2026-07-28 · **负责人**：陈正共  
> **裁决**：F1–F5（双通 + A2 必做）  
> **计划**：[`plans/2026-07-28-fpga-both-routes-runthrough.md`](./plans/2026-07-28-fpga-both-routes-runthrough.md)  
> **纪律**：合 PR ≠ 关口关闭；本页≠「Phase4.1 了结」。

---

## 0. Phase4.1 的意义

平台可行性 + **F4 双通**：加速与整网都要跑通。  
整网在 Z2 = **分时**（并行 LUT 墙仍成立，不再停在「墙」上交差）。

| 账 | 今日答案 |
|----|----------|
| Atlas 主链 / G-LAT | ✅ #13 |
| **R-A 加速跑通** | ✅ 同板向量入链 #16 + **Atlas↔PYNQ A2 PASS**（本枝） |
| **R-B 整网跑通** | ✅ **分时整网 PASS**（LIF 全 PL；fc 在 PS）；并行仍不可用 |

---

## 1. 双通证据（2026-07-28）

| 路线 | 结果 | 证据 | 人话 |
|------|------|------|------|
| **R-A A2** | **PASS** | `fpga_ra_atlas_mlif_inchain_gate.json` | Atlas 定点 fc*/lif2 ↔ TCP:9530 ↔ PYNQ lif1 PL；N=20 pred 一致 **100%**、标签 **95%** |
| **R-B TMD** | **PASS** | `fpga_rb_fullnet_runthrough_gate.json` | 同板分时整网；lif1+lif2 上 PL；N=20 pred **100%**、标签 **95%** |
| R-B 并行 | FAIL（保留） | `fpga_rb_fullnet_platform_gate.json` | 379×256 > Z2 LUT |

延迟均远逊 G-LAT（MMIO/分时）——**功能跑通 ≠ 延迟过尺**。

---

## 2. 建议

1. 推理产品主链仍可优先 **Atlas 整网**；FPGA 加速路径（A2）与板内整网分时路径均已证明「能跑对」。  
2. 若要逼近 G-LAT：须片上调度/批量 MMIO/更大器件——另立项。  
3. **Phase8**：F2 默认仍开；双通已齐，是否解除 → 请你书面一句。  
4. **F6 安全可控优先**（2026-07-28）：验证主链走开源（Verilator 等）；**Vivado 仅快验/对照出 bit**。策略：[`FPGA_工具链安全可控策略_V0.md`](./FPGA_工具链安全可控策略_V0.md)；计划：[`plans/2026-07-28-fpga-sovereign-toolchain.md`](./plans/2026-07-28-fpga-sovereign-toolchain.md)。S0：Verilator 门 + RTL-CR 已绿（CI `N-CI-VERILATOR`）。

---

## 3. 勾选

- [x] F4 双通批注 · A2 必做  
- [x] B1 分时整网跑通  
- [x] A2 Atlas↔FPGA 加速入链  
- [x] 双通汇总 PR **#17**（不代合）  
- [x] F6 安全可控优先 · S0 验证链可控（Verilator + RTL-CR + 策略 V0）
- [x] F6 S1 实现链降依赖（Yosys 对照 + Vivado 钉版本指纹 + batch TCL；PR 待审）  

---

*陈正共 · ChenZhengGong*
