# F7 overlay v2 草案：fullnet_tick_scheduler + AXI HP DMA
# Phase4.2 · WO-DEV-NEURO-F7-PERF · 离线工程（板 DOWN 时仅 lint/synth 草案）
#
# 用法（需 Vivado 2023.2+）:
#   source /tools/Xilinx/Vivado/2023.2/settings64.sh
#   cd fpga/vivado && vivado -mode batch -source create_fullnet_pl_fc_overlay_v2.tcl
#
# v1 参考: create_fullnet_pl_fc_overlay.tcl（MMIO time-mux · 已上板 Phase4.1）
# v2 目标: 单 tick_start MMIO + DMA 权值流 → 266 神经元步/ tick 在 PL 内完成

set PART xc7z020clg400-1
set REPO [file normalize [file join [pwd] ..]]
set RTL  [file join $REPO rtl]
set OUT  [file join $REPO bitstreams]
file mkdir $OUT

set proj_name f7_fullnet_overlay_v2
set proj_dir ./_vivado_f7_fullnet_v2

create_project $proj_name $proj_dir -part $PART -force

# v1 IP + v2 调度器
add_files [list \
  [file join $RTL lif_step.v] \
  [file join $RTL lif_step_axi_lite.v] \
  [file join $RTL linear_mac.v] \
  [file join $RTL linear_mac_axi_lite.v] \
  [file join $RTL fullnet_tick_scheduler.v] \
]

update_compile_order -fileset sources_1

# --- BD 草案（未完整连线 · 待板可达后迭代）---
if {[catch {
  create_bd_design "design_v2"
  create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
  apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
    -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable"} \
    [get_bd_cells processing_system7_0]

  # 启用 HP0 供 DMA 权值流（v1 关闭）
  set_property -dict [list \
    CONFIG.PCW_USE_S_AXI_HP0 {1} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
  ] [get_bd_cells processing_system7_0]

  create_bd_cell -type module -reference lif_step_axi_lite lif_step_0
  create_bd_cell -type module -reference linear_mac_axi_lite linear_mac_0
  create_bd_cell -type module -reference fullnet_tick_scheduler tick_sched_0

  # AXI-Lite：PS GP0 → MAC/LIF/tick 控制（单 kick 替代 6650 次）
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config \
    {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto"} \
    [get_bd_intf_pins lif_step_0/s_axi]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config \
    {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto"} \
    [get_bd_intf_pins linear_mac_0/s_axi]

  # TODO(v2): AXI DMA + axis interconnect → tick_sched_0 dma_w/x
  # TODO(v2): tick_sched FSM 驱动 mac/lif start 信号（替代 PS 循环）
  # TODO(v2): BRAM 双缓冲权重 · 784×256 + 256×10 Q16.16

  assign_bd_address
  validate_bd_design
  save_bd_design

  set wrap [make_wrapper -files [get_files design_v2.bd] -top -force]
  add_files -norecurse $wrap
  set_property top design_v2_wrapper [current_fileset]
  update_compile_order -fileset sources_1

  puts "INFO: overlay v2 BD draft saved — DMA/tick wiring TODO before bitstream"
} err]} {
  puts "WARN: BD draft skipped or partial: $err"
}

# 仅 synth 探针（不要求 impl/bitstream 在本 WO 离线轮闭环）
launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1
report_utilization -file [file join $OUT f7_fullnet_v2_utilization.rpt]

puts "DONE: create_fullnet_pl_fc_overlay_v2.tcl — draft only; board unreachable 2026-08-05"
