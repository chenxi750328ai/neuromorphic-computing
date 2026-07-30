# FPGA 威胁模型与安全基线 V0

**作者**：陈正共 · ChenZhengGong  
**日期**：2026-07-30  
**依据**：按项目目标独立评审 T1-3 · 总裁裁决 F6「安全可控优先」

---

## 1. 资产

| 资产 | 说明 |
|------|------|
| RTL / 约束 / 脚本 | 仓内可审计源 |
| 工具链 | Yosys/Verilator/openXC7；Vivado 钉版本辅 |
| 位流 `.bit` | 交付物；可被替换则功能与安全失效 |
| 板卡（PYNQ/Atlas） | 实验室网段；持口令即可控 PL/OS |
| 金标与证据 JSON | 假绿风险面 |

## 2. 威胁与对策（基线）

| ID | 威胁 | 现状 | 基线要求 |
|----|------|------|----------|
| T-BIT | 位流被篡改/错源上板 | 弱 | sha256 + 来源 tcl/commit 绑定门 |
| T-CRED | 口令进源码 / SSH 主机校验关闭 | **已止血**：口令改环境变量；`StrictHostKeyChecking=accept-new` | 禁止再提交明文口令与 `=no` |
| T-SUPPLY | 工具链未入版本控制、未钉哈希 | third_party gitignore | `third_party.lock`（T2） |
| T-LEGAL | prjxray-db 等逆向库法律面 | 未评估 | S2/迁移文档登记许可状态（T2/T4） |
| T-FAKE | 门禁假绿（catch 吞错、证据覆盖） | 部分已修 | Vivado BD 失败 exit 1；证据按 design 分文件 |
| T-LAT | 横向移动（板卡口令默认） | 实验室默认口令仍弱 | 改板卡口令 + known_hosts（运维） |

## 3. 非目标

- 不宣称达到商密/等保  
- 不替代总裁对 F6 分阶段的书面裁定  

---

*陈正共 · 2026-07-30*
