# Composer-Lite Example Script
# Works only for ZYNQ Ultrascale+ MPSoc
# Requires Xilinx Vivado 2021.2
# Please ensure "vivado" is in $PATH

# User Defined Specifications
source params.tcl

# Project Specifications
set board_part xilinx.com:kv260_som:part0:1.2
create_project $project_name $project_path -part $part_sku
set_property board_part $board_part [current_project]

# Create AXI Lite IP Block
create_peripheral user.org user axi_lite 1.0 -dir $project_path
add_peripheral_interface S00_AXI -interface_mode slave -axi_type lite [ipx::find_open_core user.org:user:axi_lite:1.0]
## Set Number of AXI Lite Registers
set_property VALUE $num_regs [ipx::get_bus_parameters WIZ_NUM_REG -of_objects [ipx::get_bus_interfaces S00_AXI -of_objects [ipx::find_open_core user.org:user:axi_lite:1.0]]]
generate_peripheral -driver -bfm_example_design -debug_hw_example_design [ipx::find_open_core user.org:user:axi_lite:1.0]
write_peripheral [ipx::find_open_core user.org:user:axi_lite:1.0]
exit
