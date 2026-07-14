# Build PYNQ-Z2 overlay with lif_step RTL (run on machine WITH Vivado)
# Usage:
#   vivado -mode batch -source create_lif_overlay.tcl
# Expect: outputs/lif_step_overlay/{lif_step_overlay.bit,.hwh} + util report

set PART xc7z020clg400-1
set OUTDIR [file normalize "./outputs/lif_step_overlay"]
file mkdir $OUTDIR

create_project lif_overlay ./vivado_lif_overlay -part $PART -force
add_files [file normalize "../rtl/lif_step.v"]
update_compile_order -fileset sources_1

create_bd_design "design_1"
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1"} [get_bd_cells processing_system7_0]

# Package lif_step as RTL module + AXI-Lite GPIO bridge (manual wiring next):
# For minimal flow: expose via axi_gpio style wrapper — extend with axi_lite wrapper IP.
# Placeholder: synth RTL alone for utilization numbers first.

set_property top lif_step [current_fileset]
launch_runs synth_1 -jobs 4
wait_on_run synth_1

open_run synth_1
report_utilization -file [file join $OUTDIR lif_step_utilization.rpt]
report_timing_summary -file [file join $OUTDIR lif_step_timing.rpt]

puts "SYNTH_UTIL_OK wrote $OUTDIR"
# Full bitstream (PS+PL AXI) requires axi_lite wrapper — see docs/phase4_fpga_toolchain_V0.md
exit 0
