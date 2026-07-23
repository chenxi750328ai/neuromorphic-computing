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
  # make_wrapper writes under .gen/.../hdl/; return value is the file set to add
  set wrapper_files [make_wrapper -files [get_files design_1.bd] -top]
  add_files -norecurse $wrapper_files
  set_property top design_1_wrapper [current_fileset]
  update_compile_order -fileset sources_1

  launch_runs impl_1 -to_step write_bitstream -jobs 4
  wait_on_run impl_1
  set bit_src [lindex [glob -nocomplain ./_vivado_lif_overlay/lif_overlay.runs/impl_1/*.bit] 0]
  if {$bit_src eq ""} {
    error "impl_1 produced no .bit"
  }
  file copy -force $bit_src [file join $OUT lif_step_overlay.bit]
  # hwh from BD export / hw_handoff
  set hwh_src [lindex [glob -nocomplain \
    ./_vivado_lif_overlay/lif_overlay.gen/sources_1/bd/design_1/hw_handoff/*.hwh \
    ./_vivado_lif_overlay/lif_overlay.srcs/sources_1/bd/design_1/hw_handoff/*.hwh] 0]
  if {$hwh_src ne ""} {
    file copy -force $hwh_src [file join $OUT lif_step_overlay.hwh]
  }
  puts "BIT_OK [file join $OUT lif_step_overlay.bit]"
} err]} {
  puts "BD_BITSTREAM_SKIP: $err"
  puts "NOTE: utilization.rpt 仍可用；BD 失败时手工在 GUI 挂 AXI 即可"
}

puts "DONE outputs in $OUT"
exit 0
