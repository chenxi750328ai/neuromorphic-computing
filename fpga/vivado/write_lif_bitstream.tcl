# Fresh project: BD + PS7 + lif_step_axi_lite → bitstream for PYNQ-Z2
# Usage:
#   source /tools/Xilinx/Vivado/*/settings64.sh
#   cd fpga/vivado && vivado -mode batch -source write_lif_bitstream.tcl
#
# Outputs → ../bitstreams/lif_step_overlay.{bit,hwh}

set PART xc7z020clg400-1
set REPO [file normalize [file join [pwd] ..]]
set RTL  [file join $REPO rtl]
set OUT  [file join $REPO bitstreams]
file mkdir $OUT

set PROJ ./_vivado_lif_bit
file delete -force $PROJ
create_project lif_bit $PROJ -part $PART -force

add_files [list \
  [file join $RTL lif_step.v] \
  [file join $RTL lif_step_axi_lite.v] \
]
update_compile_order -fileset sources_1

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

set wrapper_files [make_wrapper -files [get_files design_1.bd] -top]
add_files -norecurse $wrapper_files
set_property top design_1_wrapper [current_fileset]
update_compile_order -fileset sources_1

# Ensure BD outputs are generated before synth/impl
generate_target all [get_files design_1.bd]
export_ip_user_files -of_objects [get_files design_1.bd] -no_script -sync -force -quiet

launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
  error "synth_1 failed"
}

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
  error "impl_1 failed: [get_property STATUS [get_runs impl_1]]"
}

set bit_src [lindex [glob -nocomplain $PROJ/lif_bit.runs/impl_1/*.bit] 0]
if {$bit_src eq ""} {
  # project name may nest differently
  set bit_src [lindex [glob -nocomplain $PROJ/*.runs/impl_1/*.bit $PROJ/*/*.runs/impl_1/*.bit] 0]
}
if {$bit_src eq ""} {
  set bit_src [lindex [glob -nocomplain **/*.bit] 0]
}
if {$bit_src eq ""} {
  error "no .bit produced under $PROJ"
}
file copy -force $bit_src [file join $OUT lif_step_overlay.bit]
puts "BIT_OK [file join $OUT lif_step_overlay.bit]"

set hwh_src [lindex [glob -nocomplain \
  $PROJ/lif_bit.gen/sources_1/bd/design_1/hw_handoff/*.hwh \
  $PROJ/*/sources_1/bd/design_1/hw_handoff/*.hwh \
  $PROJ/**/hw_handoff/*.hwh] 0]
if {$hwh_src ne ""} {
  file copy -force $hwh_src [file join $OUT lif_step_overlay.hwh]
  puts "HWH_OK [file join $OUT lif_step_overlay.hwh]"
} else {
  puts "HWH_MISSING"
}

puts "DONE"
exit 0
