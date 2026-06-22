# Minimal Vitis HLS flow for lif_step.cpp (edit VIVADO_PART if needed)
set PART "xc7z020clg400-1"

open_project -reset lif_step
set_top lif_step
add_files lif_step.cpp
open_solution "solution1" -flow_target vivado
set_part $PART
create_clock -period 10 -name default
csim_design
csynth_design
export_design -format ip_catalog
