# start by reading in all the IP blocks generated by vivado

set partNumber xcvu9p-flga2104-2L-e
set boardName  xilinx.com:vcu118:part0:2.4

set ipName WallyFPGA

create_project $ipName . -force -part $partNumber
set_property board_part $boardName [current_project]

read_ip IP/xlnx_proc_sys_reset.srcs/sources_1/ip/xlnx_proc_sys_reset/xlnx_proc_sys_reset.xci
read_ip IP/xlnx_ahblite_axi_bridge.srcs/sources_1/ip/xlnx_ahblite_axi_bridge/xlnx_ahblite_axi_bridge.xci
read_ip IP/xlnx_axi_clock_converter.srcs/sources_1/ip/xlnx_axi_clock_converter/xlnx_axi_clock_converter.xci
read_ip IP/xlnx_ddr4.srcs/sources_1/ip/xlnx_ddr4/xlnx_ddr4.xci


read_verilog -sv [glob -type f ../../wally-pipelined/src/*/*.sv ../../wally-pipelined/src/*/*/*.sv]
read_verilog  {../src/fpgaTop.v}

set_property include_dirs {../../wally-pipelined/config/fpga ../../wally-pipelined/config/shared} [current_fileset]

add_files -fileset constrs_1 -norecurse ../constraints/constraints.xdc
set_property PROCESSING_ORDER NORMAL [get_files  ../constraints/constraints.xdc]

# define top level
set_property top fpgaTop [current_fileset]


update_compile_order -fileset sources_1
# This is important as the ddr4 IP contains the generate clock constraint which the user constraints depend on.
exec mkdir -p reports/
exec rm -rf reports/*

report_compile_order -constraints > reports/compile_order.rpt

# this is elaboration not synthesis.
synth_design -rtl -name rtl_1

report_clocks -file reports/clocks.rpt

# this does synthesis? wtf?
launch_runs synth_1 -jobs 4

wait_on_run synth_1
open_run synth_1


check_timing -verbose                                                   -file reports/check_timing.rpt
report_timing -max_paths 10 -nworst 10 -delay_type max -sort_by slack   -file reports/timing_WORST_10.rpt
report_timing -nworst 1 -delay_type max -sort_by group                  -file reports/timing.rpt
report_utilization -hierarchical                                        -file reports/utilization.rpt
report_cdc                                                              -file reports/cdc.rpt
report_clock_interaction                                                -file reports/clock_interaction.rpt

source ../constraints/debug2.xdc


# set for RuntimeOptimized implementation
#set_property "steps.place_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
#set_property "steps.route_design.args.directive" "RuntimeOptimized" [get_runs impl_1]

launch_runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1

# output Verilog netlist + SDC for timing simulation
exec mkdir -p sim/
exec rm -rf sim/*

write_verilog -force -mode funcsim sim/imp-funcsim.v
write_verilog -force -mode timesim sim/imp-timesim.v
write_sdf     -force sim/imp-timesim.sdf

# reports
check_timing                                                              -file reports/imp_check_timing.rpt
report_timing -max_paths 10 -nworst 10 -delay_type max -sort_by slack     -file reports/imp_timing_WORST_10.rpt
report_timing -nworst 1 -delay_type max -sort_by group                    -file reports/imp_timing.rpt
report_utilization -hierarchical                                          -file reports/imp_utilization.rpt
