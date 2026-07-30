# One-shot: synth utilization + (best-effort) Zynq BD bitstream for PYNQ-Z2
# Usage (after Vivado installed):
#   source /tools/Xilinx/Vivado/*/settings64.sh
#   cd fpga/vivado && vivado -mode batch -source create_lif_overlay.tcl
#
# Outputs → ../bitstreams/

set PART xc7z020clg400-1
set REPO [file normalize [file join [pwd] ..]]
set RTL  [file join $REPO rtl]
set OUT  [file join $REPO bitstreams]
file mkdir $OUT

create_project lif_overlay ./_vivado_lif_overlay -part $PART -force
add_files [list \
  [file join $RTL lif_step.v] \
  [file join $RTL lif_step_axi_lite.v] \
]
set_property top lif_step_axi_lite [current_fileset]
update_compile_order -fileset sources_1

# --- A) Synth-only utilization (always) ---
launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1
report_utilization -file [file join $OUT lif_step_utilization.rpt]
report_timing_summary -file [file join $OUT lif_step_timing.rpt]
puts "UTIL_OK [file join $OUT lif_step_utilization.rpt]"

# --- B) Best-effort BD + bitstream (may need board files / more glue) ---
if {[catch {
  create_bd_design "design_1"
  create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
  apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
    -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable"} \
    [get_bd_cells processing_system7_0]
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {0} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100}] \
    [get_bd_cells processing_system7_0]

  create_bd_cell -type module -reference lif_step_axi_lite lif_step_0
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config \
    {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto"} \
    [get_bd_intf_pins lif_step_0/s_axi]

  assign_bd_address
  validate_bd_design
  save_bd_design
  # make_wrapper 返回值才是工程内可识别的 wrapper 句柄（勿手拼 .gen 路径）
  set wrap [make_wrapper -files [get_files design_1.bd] -top -force]
  add_files -norecurse $wrap
  set_property top design_1_wrapper [current_fileset]
  update_compile_order -fileset sources_1
  # BD wrapper 需重新综合再实现
  reset_run synth_1
  launch_runs synth_1 -jobs 4
  wait_on_run synth_1
  launch_runs impl_1 -to_step write_bitstream -jobs 4
  wait_on_run impl_1
  set bit_glob [glob -nocomplain ./_vivado_lif_overlay/lif_overlay.runs/impl_1/*.bit]
  if {[llength $bit_glob] == 0} {
    error "impl finished but no .bit under impl_1"
  }
  file copy -force [lindex $bit_glob 0] [file join $OUT lif_step_overlay.bit]
  catch {
    set hwh [lindex [glob -nocomplain ./_vivado_lif_overlay/**/hw_handoff/*.hwh] 0]
    if {$hwh ne ""} {
      file copy -force $hwh [file join $OUT lif_step_overlay.hwh]
    }
  }
  puts "BIT_OK [file join $OUT lif_step_overlay.bit]"
} err]} {
  puts "BD_BITSTREAM_FAIL: $err"
  puts "NOTE: utilization.rpt 可能仍可用；BD/bitstream 失败必须非零退出（禁假绿）"
  puts "DONE outputs in $OUT"
  exit 1
}

puts "DONE outputs in $OUT"
exit 0
