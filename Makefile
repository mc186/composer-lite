include ./env

all: clean
	${MAKE} proj_setup
	# ${MAKE} apply_mod
	${MAKE} syn

proj_setup:
	vivado -mode tcl -source proj_setup.tcl

apply_mod:
	cp ./axi_lite_v1_0_S00_AXI.v ./composer-lite-helloworld/axi_lite_1.0/hdl/axi_lite_v1_0_S00_AXI.v 

syn:
	vivado -mode tcl -source syn_script.tcl

upload:
	scp ./${PROJECT_NAME}.bit ${FPGA_USER}@${FPGA_HOST}:${FPGA_PATH}
	scp ./${PROJECT_NAME}.hwh ${FPGA_USER}@${FPGA_HOST}:${FPGA_PATH}

clean:
	rm -rf ${PROJECT_NAME} 
	rm -rf *.jou
	rm -rf *.log
	# rm -rf *.bit
	# rm -rf *.hwh

