########################################################################
# SETUP MW
#

suppress_message { PSYN-040 PSYN-651 PSYN-650 ZRT-039}

source ${db_setup_file}
set mw_design_library ${MDB_LIB_NEW}
#bus type defination cmd: create_mw_lib -tech $mw_tech_file -bus_naming_style {\[%d\]} $lib_name
create_mw_lib -tech $TECH_FILE ${MDB_LIB_NEW} 
set_mw_lib_reference -mw_reference_library $mw_reference_library ./${MDB_LIB_NEW}
open_mw_lib ${MDB_LIB_NEW}
set mw_power_net   VDD
set mw_ground_net  VSS
set mw_power_port  VDD
set mw_ground_port VSS
set mw_logic1_net  VDD
set mw_logic0_net  VSS
#set_attribute [ get_lib_cells sc12_cln65gplus_base_lvt_ss_typical_max_0p90v_125c_big_buf/INV* ] dont_use false
#set_attribute [ get_lib_cells sc12_cln65gplus_base_lvt_ss_typical_max_0p90v_125c_big_buf/INV* ] dont_touch false
########################################################################
# READ DESIGN
#
#remove_design -all > /dev/null
sh rm -f ${SESSION}.run/read_verilog.log
import_designs -format verilog -top $TOP -cel $TOP  $VNET_LIST
uniquify_fp_mw_cel -verbose
set auto_restore_mw_cel_lib_setup true
#open_design
current_design ${TOP}
set_tlu_plus_files -max_tluplus $TlUP_WORST -tech2itf_map $MAP_FILE
# if use ilm , block lvl cmd: set enable_hier_si true
#		create_ilm -include_xtalk
#	top lvl cmd: 	set enable_hier_si true
#		link ilm 
#		set propagate_ilm 

#uniquify
#set_cbt_options -threshold $MAX_FANOUT -references {sc12_cln65gplus_base_lvt_ss_typical_max_0p90v_125c_big_buf/BUFH_X32M_A12TL sc12_cln65gplus_base_lvt_ss_typical_max_0p90v_125c_big_buf/INV_X32B_A12TL}
link > ${SESSION}.run/link.log
source ${db_setup_file}
#remove_buffer_tree -all
########################################################################
# FLOORPLAN
#
#set unit tile cmd : set_fp_options -unit_tile_name {core bcore}
#set mw_site_name_mapping "core unit"
derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vdd -ground_pin vss
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDDA -ground_pin VSSA
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vdda -ground_pin vssa
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDDQ -ground_pin VSSQ
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vddta -ground_pin vssa
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vddha -ground_pin vssa
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vdd_dig -ground_pin vss_dig

derive_pg_connection -power_net VDD -ground_net VSS -tie
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vdd -ground_pin vss -tie
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDDA -ground_pin VSSA -tie
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vdda -ground_pin vssa -tie
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDDQ -ground_pin VSSQ -tie
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vddta -ground_pin vssa -tie
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vddha -ground_pin vssa -tie
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin vdd_dig -ground_pin vss_dig -tie


if { ${DEF} != "" } {
  current_design ${TOP}
  read_def -enforce_scaling ${DEF} -lef ${LEF} > ${SESSION}.run/read_def.log
}
unset_preferred_routing_direction -layer AP
remove_track -layer AP -dir Y
remove_track -layer AP -dir X
set_preferred_routing_direction -layer AP -dir vertical

#write_floorplan ./fp.tcl -placement {io hard_macro soft_macro} -row -track


#read_floorplan ./fp.tcl              > ${SESSION}.run/read_fp.log
########## example for FP block
### pin constraints (optional)
# read_io_constraints <tdf_file>
### create block shape, size, and placement rows 
# initialize_floorplan
### for rectilinear blocks, use
# initialize_rectilinear_block
### preplacehard macros, if needed choose placement strategy(ies)
# set_fp_placement_strategy "load_pin_assignment_constraints" -value 1
# create_fp_placement
### create additional pin constraints (optional)
# set_fp_pin_constraints/ create_pin_guide/
# create_placement_blockage -type pin
### place block pins
# place_fp_pins -block_level
###disable pin constraint aware placement
#set_fp_placement_strategy -name "load_pin_assignment_constraints" -value 0
### re-place cells (optional)
#create_fp_placement
### PNS/PNA to create and analyze power network 
# set_fp_rail_constraint/synthesize_fp_rail 
# commit_fp_rail
#### assign and optimize block pins
# set_fp_pin_constraints-block_level
# place_fp_pins -block_level
##### spare cell
# set_attribute [get_cells spares*} is_spare_cell true 
# spread_spare_cells [get_cells spare*] -bbox {{5 5} {2000 2000}}
# place_opt
# spread_spare_cells [get_cells spare*] -bbox {{20 20} {999 999}} 
#legalize_placement -incr
#############################
# special cell placement cmd: 
# 	set_lib_cell_spacing_label -names {list_of_label_names} [-left_lib_cells \
#	{lib_cell_collection}] [-right_lib_cells {lib_cell_collection}]
#	set_spacing_label_rule -labels {list_of_label_names} {min max}
#remove_placement_keepout -all
#source $BLOCKAGE
#redirect -tee ${SESSION}.run/physical_statistic_FP.log { report_design -physical > ${SESSION}.run/physical_statistic_FP.rpt }
#
#set_attribute [get_nets -all peu_serdes/SNPS_LOGIC1] net_type power
#
#save_mw_cel  -as ${TOP}_SOC
save_mw_cel  -design $TOP
