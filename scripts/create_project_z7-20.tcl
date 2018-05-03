
# Set the original project directory path for adding/importing sources in the new project
set orig_proj_dir "."

# Create project
create_project -force Zybo_Linux ../Zybo_Linux

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects Zybo_Linux]
set_property part xc7z020clg400-1 [current_project]
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "VHDL" $obj

add_files -norecurse sources/sources_1/top_zybo/top_zybo.vhd
add_files -norecurse sources/sources_1/test/axi4_lite_test.vhd
add_files -norecurse sources/sources_1/ad7193/ad7193.vhd
add_files -norecurse sources/sources_1/packages/counter_pkg.vhd
add_files -norecurse sources/sources_1/fifos/sync_srl_fifo.vhd
add_files -norecurse sources/sources_1/uart/uart.vhd
add_files -norecurse sources/sources_1/uart/uart_rx_module.vhd
add_files -norecurse sources/sources_1/uart/uart_tx_module.vhd

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "top_zybo" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Add files to 'constrs_1' fileset
add_files -norecurse sources/constrs_1/top_zybo.xdc

# Set 'constrs_1' fileset file properties for remote files
# None


# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets sim_1] ""]} {
  create_fileset -simset sim_1
}

# Add files to 'sim_1' fileset
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "top_zybo" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs synth_1] ""]} {
  create_run -name synth_1 -part xc7z010clg400-2 -flow {Vivado Synthesis 2013} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
}
set obj [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs impl_1] ""]} {
  create_run -name impl_1 -part xc7z010clg400-2 -flow {Vivado Implementation 2013} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
}
set obj [get_runs impl_1]


puts "INFO: Project created:Zybo_Linux"

# Add IP location
set_property ip_repo_paths  {../XilinxIP } [current_fileset]
update_ip_catalog

# Create block diagram
source scripts/system_bd_z7-20.tcl

# Create block diagram wrapper
make_wrapper -files [get_files ./Zybo_Linux.srcs/sources_1/bd/system_bd/system_bd.bd] -top
add_files -norecurse ./Zybo_Linux.srcs/sources_1/bd/system_bd/hdl/system_bd_wrapper.vhd
update_compile_order -fileset sources_1

# generate output products
update_compile_order -fileset sources_1
generate_target all [get_files  ./Zybo_Linux.srcs/sources_1/bd/system_bd/system_bd.bd]
