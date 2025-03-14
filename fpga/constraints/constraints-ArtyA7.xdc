# The main clocks are all autogenerated by the Xilinx IP
# clk_out3_xlnx_mmcm is the 20Mhz clock from the mmcm used to drive wally and the AHB Bus.
# mmcm_clkout0 is the clock output of the DDR3 memory interface / 4.
# This clock is not used by wally or the AHB Bus. However it is used by the AXI BUS on the DD3 IP.

#create_generated_clock -name CLKDiv64_Gen -source [get_pins wallypipelinedsoc/uncore.uncore/sdc.SDC/sd_top/slow_clk_divider/clkMux/I0] -multiply_by 1 -divide_by 1 [get_pins wallypipelinedsoc/uncore.uncore/sdc.SDC/sd_top/slow_clk_divider/clkMux/O]
create_generated_clock -name SPISDCClock -source [get_pins mmcm/clk_out3] -multiply_by 1 -divide_by 1 [get_pins wallypipelinedsoc/uncoregen.uncore/sdc.sdc/SPICLK]

##### clock #####
set_property PACKAGE_PIN E3 [get_ports default_100mhz_clk]
set_property IOSTANDARD LVCMOS33 [get_ports default_100mhz_clk]

##### RVVI Ethernet ####
# taken from https://github.com/alexforencich/verilog-ethernet/blob/master/example/Arty/fpga/fpga.xdc
set_property -dict {LOC F15 IOSTANDARD LVCMOS33} [get_ports phy_rx_clk]
set_property -dict {LOC D18 IOSTANDARD LVCMOS33} [get_ports {phy_rxd[0]}]
set_property -dict {LOC E17 IOSTANDARD LVCMOS33} [get_ports {phy_rxd[1]}]
set_property -dict {LOC E18 IOSTANDARD LVCMOS33} [get_ports {phy_rxd[2]}]
set_property -dict {LOC G17 IOSTANDARD LVCMOS33} [get_ports {phy_rxd[3]}]
set_property -dict {LOC G16 IOSTANDARD LVCMOS33} [get_ports phy_rx_dv]
set_property -dict {LOC C17 IOSTANDARD LVCMOS33} [get_ports phy_rx_er]
set_property -dict {LOC H16 IOSTANDARD LVCMOS33} [get_ports phy_tx_clk]
set_property -dict {LOC H14 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[0]}]
set_property -dict {LOC J14 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[1]}]
set_property -dict {LOC J13 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[2]}]
set_property -dict {LOC H17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[3]}]
set_property -dict {LOC H15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports phy_tx_en]
set_property -dict {LOC D17 IOSTANDARD LVCMOS33} [get_ports phy_col]
set_property -dict {LOC G14 IOSTANDARD LVCMOS33} [get_ports phy_crs]
set_property -dict {LOC G18 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports phy_ref_clk]
set_property -dict {LOC C16 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports phy_reset_n]

create_clock -period 40.000 -name phy_rx_clk [get_ports phy_rx_clk]
create_clock -period 40.000 -name phy_tx_clk [get_ports phy_tx_clk]

set_false_path -to [get_ports {phy_ref_clk phy_reset_n}]
set_output_delay 0.000 [get_ports {phy_ref_clk phy_reset_n}]

##### GPI ####
set_property PACKAGE_PIN A8 [get_ports {GPI[0]}]
set_property PACKAGE_PIN C9 [get_ports {GPI[1]}]
set_property PACKAGE_PIN B9 [get_ports {GPI[2]}]
set_property PACKAGE_PIN B8 [get_ports {GPI[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPI[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPI[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPI[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPI[0]}]
set_input_delay -clock [get_clocks clk_out3_mmcm] -min -add_delay 0.000 [get_ports {GPI[*]}]
set_input_delay -clock [get_clocks clk_out3_mmcm] -max -add_delay 0.000 [get_ports {GPI[*]}]
set_max_delay -from [get_ports {GPI[*]}] 20.000

##### GPO ####
set_property PACKAGE_PIN G6 [get_ports {GPO[0]}]
set_property PACKAGE_PIN F6 [get_ports {GPO[1]}]
set_property PACKAGE_PIN E1 [get_ports {GPO[2]}]
set_property PACKAGE_PIN G3 [get_ports {GPO[4]}]
set_property PACKAGE_PIN J4 [get_ports {GPO[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPO[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPO[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPO[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPO[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPO[0]}]
set_max_delay -to [get_ports {GPO[*]}] 20.000

set_output_delay -clock [get_clocks clk_out3_mmcm] -min -add_delay 0.000 [get_ports {GPO[*]}]
set_output_delay -clock [get_clocks clk_out3_mmcm] -max -add_delay 0.000 [get_ports {GPO[*]}]


##### UART #####
# *** IOSTANDARD is probably wrong
set_property PACKAGE_PIN A9 [get_ports UARTSin]
set_property PACKAGE_PIN D10 [get_ports UARTSout]
set_max_delay -from [get_ports UARTSin] 20.000
set_max_delay -to [get_ports UARTSout] 20.000
set_property IOSTANDARD LVCMOS33 [get_ports UARTSin]
set_property IOSTANDARD LVCMOS33 [get_ports UARTSout]
set_property DRIVE 4 [get_ports UARTSout]
set_input_delay -clock [get_clocks clk_out3_mmcm] -min -add_delay 0.000 [get_ports UARTSin]
set_input_delay -clock [get_clocks clk_out3_mmcm] -max -add_delay 0.000 [get_ports UARTSin]
set_output_delay -clock [get_clocks clk_out3_mmcm] -min -add_delay 0.000 [get_ports UARTSout]
set_output_delay -clock [get_clocks clk_out3_mmcm] -max -add_delay 0.000 [get_ports UARTSout]


##### reset #####
#************** reset is inverted
set_input_delay -clock [get_clocks clk_out3_mmcm] -min -add_delay 2.000 [get_ports resetn]
set_input_delay -clock [get_clocks clk_out3_mmcm] -max -add_delay 2.000 [get_ports resetn]
set_max_delay -from [get_ports resetn] 20.000
set_false_path -from [get_ports resetn]
set_property PACKAGE_PIN C2 [get_ports resetn]
set_property IOSTANDARD LVCMOS33 [get_ports resetn]


set_input_delay -clock [get_clocks clk_out3_mmcm] -min -add_delay 2.000 [get_ports south_reset]
set_input_delay -clock [get_clocks clk_out3_mmcm] -max -add_delay 2.000 [get_ports south_reset]
set_max_delay -from [get_ports south_reset] 20.000
set_false_path -from [get_ports south_reset]
set_property PACKAGE_PIN D9 [get_ports south_reset]
set_property IOSTANDARD LVCMOS33 [get_ports south_reset]

###### Video Controller Mapped to PMOD JB ######
#set_property PACKAGE_PIN E15 [get_ports ch2_p] #Arranged right to left and top to bottom
#set_property PACKAGE_PIN E16 [get_ports ch1_p]
#set_property PACKAGE_PIN D15 [get_ports ch0_p]
#set_property PACKAGE_PIN C15 [get_ports chc_p]
#set_property PACKAGE_PIN J17 [get_ports ch2_n]
#set_property PACKAGE_PIN J18 [get_ports ch1_n]
#set_property PACKAGE_PIN K15 [get_ports ch0_n]
#set_property PACKAGE_PIN J15 [get_ports chc_n]

#set_property IOSTANDARD TMDS_33 [get_ports ch2_p]
#set_property IOSTANDARD TMDS+33 [get_ports ch1_p]
#set_property IOSTANDARD TMDS_33 [get_ports ch0_p]
#set_property IOSTANDARD TMDS_33 [get_ports chc_p]
#set_property IOSTANDARD TMDS_33 [get_ports ch2_n]
#set_property IOSTANDARD TMDS_33 [get_ports ch1_n]
#set_property IOSTANDARD TMDS_33 [get_ports ch0_n]
#set_property IOSTANDARD TMDS_33 [get_ports chc_n]


##### SD Card I/O #####
#***** may have to switch to Pmod JB or JC.
#set_property PACKAGE_PIN D4 [get_ports {SDCDat[3]}]
#set_property PACKAGE_PIN D2 [get_ports {SDCDat[2]}]
#set_property PACKAGE_PIN E2 [get_ports {SDCDat[1]}]
#set_property PACKAGE_PIN F4 [get_ports {SDCDat[0]}]
#set_property PACKAGE_PIN F3 [get_ports SDCCLK]
#set_property PACKAGE_PIN D3 [get_ports {SDCCmd}]
#set_property PACKAGE_PIN H2 [get_ports {SDCCD}]

#set_property IOSTANDARD LVCMOS33 [get_ports {SDCDat[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SDCDat[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SDCDat[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SDCDat[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports SDCCLK]
#set_property IOSTANDARD LVCMOS33 [get_ports {SDCCmd}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SDCCD}]
#set_property PULLUP true [get_ports {SDCDat[3]}]
#set_property PULLUP true [get_ports {SDCDat[2]}]
#set_property PULLUP true [get_ports {SDCDat[1]}]
#set_property PULLUP true [get_ports {SDCDat[0]}]
#set_property PULLUP true [get_ports {SDCCmd}]
#set_property PULLUP true [get_ports {SDCCD}]

# SDCDat[3]
set_property PACKAGE_PIN D4 [get_ports SDCCS]
set_property IOSTANDARD LVCMOS33 [get_ports SDCCS]
set_property PULLTYPE PULLUP [get_ports SDCCS]
# set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {SDCDat[2]}]
# set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {SDCDat[1]}]
# SDCDat[0]
set_property PACKAGE_PIN F4 [get_ports SDCIn]
set_property IOSTANDARD LVCMOS33 [get_ports SDCIn]
set_property PULLTYPE PULLUP [get_ports SDCIn]
set_property PACKAGE_PIN F3 [get_ports SDCCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SDCCLK]
set_property PULLTYPE PULLUP [get_ports SDCCLK]
set_property PACKAGE_PIN D3 [get_ports SDCCmd]
set_property IOSTANDARD LVCMOS33 [get_ports SDCCmd]
set_property PULLTYPE PULLUP [get_ports SDCCmd]
set_property PACKAGE_PIN H2 [get_ports SDCCD]
set_property IOSTANDARD LVCMOS33 [get_ports SDCCD]
set_property PULLTYPE PULLUP [get_ports SDCCD]
set_property PACKAGE_PIN G2 [get_ports SDCWP]
set_property IOSTANDARD LVCMOS33 [get_ports SDCWP]
set_property PULLTYPE PULLUP [get_ports SDCWP]


set_output_delay -clock [get_clocks SPISDCClock] -min -add_delay 2.500 [get_ports {SDCCS}]
set_output_delay -clock [get_clocks SPISDCClock] -max -add_delay 10.000 [get_ports {SDCCS}]

set_input_delay -clock [get_clocks SPISDCClock] -min -add_delay 2.500 [get_ports {SDCIn}]
set_input_delay -clock [get_clocks SPISDCClock] -max -add_delay 10.000 [get_ports {SDCIn}]

set_output_delay -clock [get_clocks SPISDCClock] -min -add_delay 2.000 [get_ports {SDCCmd}]
set_output_delay -clock [get_clocks SPISDCClock] -max -add_delay 6.000 [get_ports {SDCCmd}]

set_output_delay -clock [get_clocks SPISDCClock] 0.000 [get_ports SDCCLK]


#set_multicycle_path -from [get_pins xlnx_ddr3_c0/u_xlnx_ddr3_mig/u_memc_ui_top_axi/mem_intfc0/ddr_phy_top0/u_ddr_calib_top/init_calib_complete_reg/C] -to [get_pins xlnx_proc_sys_reset_0/U0/EXT_LPF/lpf_int_reg/D] 10

set_max_delay -datapath_only -from [get_pins xlnx_ddr3_c0/u_xlnx_ddr3_mig/u_memc_ui_top_axi/mem_intfc0/ddr_phy_top0/u_ddr_calib_top/init_calib_complete_reg/C] -to [get_pins xlnx_proc_sys_reset_0/U0/EXT_LPF/lpf_int_reg/D] 20.000

# *********************************
#set_property DCI_CASCADE {64} [get_iobanks 65]
#set_property INTERNAL_VREF 0.9 [get_iobanks 65]

# ddr3

set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[1]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[2]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[3]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[4]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[5]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[6]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[7]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[8]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[9]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[10]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[11]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[12]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[13]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[14]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[15]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dm[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dm[1]}]
set_property IOSTANDARD DIFF [get_ports ddr3_dqs_p[0]]
set_property IOSTANDARD DIFF [get_ports ddr3_dqs_n[0]]
set_property IOSTANDARD DIFF [get_ports ddr3_dqs_p[1]]
set_property IOSTANDARD DIFF [get_ports ddr3_dqs_n[1]]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[13]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[12]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[11]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[10]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[9]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[8]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[7]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[6]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[5]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[4]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[3]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[2]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[1]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_ba[2]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_ba[1]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_ba[0]}]
set_property IOSTANDARD DIFF [get_ports ddr3_ck_p[0]]
set_property IOSTANDARD DIFF [get_ports ddr3_ck_n[0]]
set_property IOSTANDARD SSTL135 [get_ports ddr3_ras_n]
set_property IOSTANDARD SSTL135 [get_ports ddr3_cas_n]
set_property IOSTANDARD SSTL135 [get_ports ddr3_we_n]
set_property IOSTANDARD SSTL135 [get_ports ddr3_reset_n]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_cke[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_odt[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_cs_n[0]}]


set_property PACKAGE_PIN K5 [get_ports ddr3_dq[0]]
set_property PACKAGE_PIN L3 [get_ports ddr3_dq[1]]
set_property PACKAGE_PIN K3 [get_ports ddr3_dq[2]]
set_property PACKAGE_PIN L6 [get_ports ddr3_dq[3]]
set_property PACKAGE_PIN M3 [get_ports ddr3_dq[4]]
set_property PACKAGE_PIN M1 [get_ports ddr3_dq[5]]
set_property PACKAGE_PIN L4 [get_ports ddr3_dq[6]]
set_property PACKAGE_PIN M2 [get_ports ddr3_dq[7]]
set_property PACKAGE_PIN V4 [get_ports ddr3_dq[8]]
set_property PACKAGE_PIN T5 [get_ports ddr3_dq[9]]
set_property PACKAGE_PIN U4 [get_ports ddr3_dq[10]]
set_property PACKAGE_PIN V5 [get_ports ddr3_dq[11]]
set_property PACKAGE_PIN V1 [get_ports ddr3_dq[12]]
set_property PACKAGE_PIN T3 [get_ports ddr3_dq[13]]
set_property PACKAGE_PIN U3 [get_ports ddr3_dq[14]]
set_property PACKAGE_PIN R3 [get_ports ddr3_dq[15]]
set_property PACKAGE_PIN L1 [get_ports ddr3_dm[0]]
set_property PACKAGE_PIN U1 [get_ports ddr3_dm[1]]
set_property PACKAGE_PIN N2 [get_ports ddr3_dqs_p[0]]
set_property PACKAGE_PIN N1 [get_ports ddr3_dqs_n[0]]
set_property PACKAGE_PIN U2 [get_ports ddr3_dqs_p[1]]
set_property PACKAGE_PIN V2 [get_ports ddr3_dqs_n[1]]
set_property PACKAGE_PIN T8 [get_ports ddr3_addr[13]]
set_property PACKAGE_PIN T6 [get_ports ddr3_addr[12]]
set_property PACKAGE_PIN U6 [get_ports ddr3_addr[11]]
set_property PACKAGE_PIN R6 [get_ports ddr3_addr[10]]
set_property PACKAGE_PIN V7 [get_ports ddr3_addr[9]]
set_property PACKAGE_PIN R8 [get_ports ddr3_addr[8]]
set_property PACKAGE_PIN U7 [get_ports ddr3_addr[7]]
set_property PACKAGE_PIN V6 [get_ports ddr3_addr[6]]
set_property PACKAGE_PIN R7 [get_ports ddr3_addr[5]]
set_property PACKAGE_PIN N6 [get_ports ddr3_addr[4]]
set_property PACKAGE_PIN T1 [get_ports ddr3_addr[3]]
set_property PACKAGE_PIN N4 [get_ports ddr3_addr[2]]
set_property PACKAGE_PIN M6 [get_ports ddr3_addr[1]]
set_property PACKAGE_PIN R2 [get_ports ddr3_addr[0]]
set_property PACKAGE_PIN P2 [get_ports ddr3_ba[2]]
set_property PACKAGE_PIN P4 [get_ports ddr3_ba[1]]
set_property PACKAGE_PIN R1 [get_ports ddr3_ba[0]]
set_property PACKAGE_PIN U9 [get_ports ddr3_ck_p[0]]
set_property PACKAGE_PIN V9 [get_ports ddr3_ck_n[0]]
set_property PACKAGE_PIN P3 [get_ports ddr3_ras_n]
set_property PACKAGE_PIN M4 [get_ports ddr3_cas_n]
set_property PACKAGE_PIN P5 [get_ports ddr3_we_n]
set_property PACKAGE_PIN K6 [get_ports ddr3_reset_n]
set_property PACKAGE_PIN N5 [get_ports ddr3_cke[0]]
set_property PACKAGE_PIN R5 [get_ports ddr3_odt[0]]
set_property PACKAGE_PIN U8 [get_ports ddr3_cs_n[0]]


#create_clock -period 50.000 -name VIRTUAL_clk_out3_mmcm -waveform {0.000 25.000}
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 10.000 [get_ports {GPI[*]}]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports {GPI[*]}]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 10.000 [get_ports SDCCD]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports SDCCD]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 10.000 [get_ports SDCIn]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports SDCIn]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 10.000 [get_ports SDCWP]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports SDCWP]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 10.000 [get_ports UARTSin]
#set_input_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports UARTSin]
#create_clock -period 12.000 -name VIRTUAL_clk_pll_i -waveform {0.000 6.000}
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 0.000 [get_ports {GPO[*]}]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports {GPO[*]}]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 0.000 [get_ports SDCCLK]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 0.000 [get_ports SDCCLK]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 0.000 [get_ports SDCCS]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports SDCCS]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 0.000 [get_ports SDCCmd]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports SDCCmd]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -min -add_delay 0.000 [get_ports UARTSout]
#set_output_delay -clock [get_clocks VIRTUAL_clk_out3_mmcm] -max -add_delay 10.000 [get_ports UARTSout]
#set_output_delay -clock [get_clocks VIRTUAL_clk_pll_i] -min -add_delay 0.000 [get_ports ddr3_reset_n]
#set_output_delay -clock [get_clocks VIRTUAL_clk_pll_i] -max -add_delay 80.000 [get_ports ddr3_reset_n]
