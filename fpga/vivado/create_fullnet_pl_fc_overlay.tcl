# F7 overlay: lif_step + linear_mac on PYNQ-Z2
# Usage:
#   source /tools/Xilinx/Vivado/2023.2/settings64.sh
#   cd fpga/vivado && vivado -mode batch -source create_fullnet_pl_fc_overlay.tcl

set PART xc7z020clg400-1
set REPO [file normalize [file join [pwd] ..]]
set RTL  [file join $REPO rtl]
set OUT  [file join $REPO bitstreams]
file mkdir $OUT

create_project f7_fullnet_overlay ./_vivado_f7_fullnet -part $PART -force
add_files [list \
  [file join $RTL lif_step.v] \
  [file join $RTL lif_step_axi_lite.v] \
  [file join $RTL linear_mac.v] \
  [file join $RTL linear_mac_axi_lite.v] \
]
set_property top lif_step_axi_lite [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1
report_utilization -file [file join $OUT f7_fullnet_utilization.rpt]

if {[catch {
  create_bd_design "design_1"
  create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
  apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
    -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable"} \
    [get_bd_cells processing_system7_0]
  set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {0} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100}] \
    [get_bd_cells processing_system7_0]

  create_bd_cell -type module -reference lif_step_axi_lite lif_step_0
  create_bd_cell -type module -reference linear_mac_axi_lite linear_mac_0

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config \
    {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto"} \
    [get_bd_intf_pins lif_step_0/s_axi]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config \
    {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto"} \
    [get_bd_intf_pins linear_mac_0/s_axi]

  assign_bd_address
  validate_bd_design
  save_bd_design
  set wrap [make_wrapper -files [get_files design_1.bd] -top -force]
  add_files -norecurse $wrap
  set_property top design_1_wrapper [current_fileset]
  update_compile_order -fileset sources_1
  reset_run synth_1
  launch_runs synth_1 -jobs 4
  wait_on_run synth_1
  launch_runs impl_1 -to_step write_bitstream -jobs 4
  wait_on_run impl_1
  set bit_glob [glob -nocomplain ./_vivado_f7_fullnet/f7_fullnet_overlay.runs/impl_1/*.bit]
  if {[llength $bit_glob] == 0} {
    error "impl finished but no .bit under impl_1"
  }
  file copy -force [lindex $bit_glob 0] [file join $OUT f7_fullnet_pl_fc_overlay.bit]
  set hwh_candidates [concat \
    [glob -nocomplain ./_vivado_f7_fullnet/f7_fullnet_overlay.gen/sources_1/bd/design_1/hw_handoff/*.hwh] \
    [glob -nocomplain ./_vivado_f7_fullnet/**/hw_handoff/*.hwh]]
  if {[llength $hwh_candidates] > 0} {
    file copy -force [lindex $hwh_candidates 0] [file join $OUT f7_fullnet_pl_fc_overlay.hwh]
    puts "HWH_OK [file join $OUT f7_fullnet_pl_fc_overlay.hwh]"
  } else {
    puts "HWH_MISSING"
  }
  puts "BIT_OK [file join $OUT f7_fullnet_pl_fc_overlay.bit]"
} err]} {
  puts "BD_BITSTREAM_FAIL: $err"
  exit 1
}
puts "DONE outputs in $OUT"
exit 0
