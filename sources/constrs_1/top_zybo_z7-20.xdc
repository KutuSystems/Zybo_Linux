set_property PACKAGE_PIN K18 [get_ports {btns_4bits_tri_i[0]}]
set_property PACKAGE_PIN P16 [get_ports {btns_4bits_tri_i[1]}]
set_property PACKAGE_PIN K19 [get_ports {btns_4bits_tri_i[2]}]
set_property PACKAGE_PIN Y16 [get_ports {btns_4bits_tri_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns_4bits_tri_i[*]}]

set_property PACKAGE_PIN M14 [get_ports {leds_4bits_tri_o[0]}]
set_property PACKAGE_PIN M15 [get_ports {leds_4bits_tri_o[1]}]
set_property PACKAGE_PIN G14 [get_ports {leds_4bits_tri_o[2]}]
set_property PACKAGE_PIN D18 [get_ports {leds_4bits_tri_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_4bits_tri_o[*]}]

set_property PACKAGE_PIN G15 [get_ports {sws_4bits_tri_i[0]}]
set_property PACKAGE_PIN P15 [get_ports {sws_4bits_tri_i[1]}]
set_property PACKAGE_PIN W13 [get_ports {sws_4bits_tri_i[2]}]
set_property PACKAGE_PIN T16 [get_ports {sws_4bits_tri_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sws_4bits_tri_i[*]}]

set_property PACKAGE_PIN N18 [get_ports iic_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_scl_io]
set_property PACKAGE_PIN N17 [get_ports iic_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_sda_io]

#SPI ADC7193
##Pmod Header JE
set_property PACKAGE_PIN V12 [get_ports clk_100MHz]
set_property PACKAGE_PIN W16 [get_ports clk_148MHz]
set_property PACKAGE_PIN U17 [get_ports clk_200MHz]
set_property PACKAGE_PIN V13 [get_ports clk_video]

set_property IOSTANDARD LVCMOS33 [get_ports clk_*]

#
set_property PACKAGE_PIN H17 [get_ports HDMI_CLK_N]
set_property PACKAGE_PIN H16 [get_ports HDMI_CLK_P]
set_property PACKAGE_PIN D20 [get_ports HDMI_D0_N]
set_property PACKAGE_PIN D19 [get_ports HDMI_D0_P]
set_property PACKAGE_PIN B20 [get_ports HDMI_D1_N]
set_property PACKAGE_PIN C20 [get_ports HDMI_D1_P]
set_property PACKAGE_PIN A20 [get_ports HDMI_D2_N]
set_property PACKAGE_PIN B19 [get_ports HDMI_D2_P]

set_property IOSTANDARD TMDS_33 [get_ports HDMI_CLK_*]
set_property IOSTANDARD TMDS_33 [get_ports HDMI_D*]

set_property PACKAGE_PIN F17 [get_ports {HDMI_OEN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HDMI_OEN[0]}]



####################
# Generated Clocks #
####################

# clocks for hdmi output

create_clock -period 1.667 -name clk_mmcm [get_pins system_bd_wrapper_1/system_bd_i/hdmi_display_0/U0/hdmi_tx_1/clock_gen_1/MMCME2_BASE_inst/CLKOUT1]

create_clock -period 6.667 -name clk_hdmi [get_pins system_bd_wrapper_1/system_bd_i/hdmi_display_0/U0/hdmi_tx_1/clock_gen_1/BUFR_inst/O]
create_clock -period 1.667 -name clk_hdmi_5x [get_pins system_bd_wrapper_1/system_bd_i/hdmi_display_0/U0/hdmi_tx_1/clock_gen_1/BUFIO_inst/O]

################
# Clock Groups #
################

set_clock_groups -name async_clks -asynchronous -group {clk_fpga_0} -group {clk_fpga_1} -group {clk_fpga_2} -group {clk_hdmi} -group {clk_hdmi_5x} -group {clk_mmcm}
