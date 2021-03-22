source params.tcl

open_project ${project_path}/${project_name}.xpr
# Open Core
set_property  ip_repo_paths  $project_path/axi_lite_1.0 [current_project]
update_ip_catalog -rebuild
ipx::edit_ip_in_project -upgrade true -name edit_axi_lite_v1_0 -directory $project_path $project_path/axi_lite_1.0/component.xml
update_compile_order -fileset sources_1

# Rebuild the AXI IP
ipx::merge_project_changes files [ipx::current_core]
set_property core_revision 2 [ipx::current_core]
ipx::update_source_project_archive -component [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project -delete
update_ip_catalog -rebuild -repo_path $project_path/axi_lite_1.0

# Build Block Diagram
create_bd_design "design_1"
update_compile_order -fileset sources_1
## Add ZYNQ Core
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
endgroup
## Set Link to Use Full Power Domain
set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {1} CONFIG.PSU__MAXIGP1__DATA_WIDTH {32} CONFIG.PSU__USE__M_AXI_GP2 {0}] [get_bd_cells zynq_ultra_ps_e_0]
## Add the AXI Lite IP created
startgroup
create_bd_cell -type ip -vlnv user.org:user:axi_lite:1.0 axi_lite_0
endgroup
## Run Connection Automation
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} Slave {/axi_lite_0/S00_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_lite_0/S00_AXI]
## Create HDL Wrapper
make_wrapper -files [get_files $project_path/${project_name}.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $project_path/${project_name}.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v

# Synthesis & Implementation & Generate Bit-stream
launch_runs impl_1 -to_step write_bitstream -jobs $num_threads
wait_on_runs impl_1

# Copy Bitstream
file copy -force ${project_path}/${project_name}.runs/impl_1/design_1_wrapper.bit ./${project_name}.bit
file copy -force ${project_path}/${project_name}.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh ./${project_name}.hwh
exit
