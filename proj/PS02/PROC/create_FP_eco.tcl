########################################################################
# SETUP MW
#

open_mw_lib ${MW_LIB}
set mw_power_net   VDD
set mw_ground_net  VSS
set mw_power_port  VDD
set mw_ground_port VSS
set mw_logic1_net  VDD
set mw_logic0_net  VSS
########################################################################
# READ DESIGN
#
#remove_design -all > /dev/null
sh rm -f ${SESSION}.run/read_verilog.log
open_mw_cel ${TOP}
current_design ${TOP}
# if use ilm , block lvl cmd: set enable_hier_si true
#		create_ilm -include_xtalk
#	top lvl cmd: 	set enable_hier_si true
#		link ilm 
#		set propagate_ilm 

update_mw_design_eco -change_verilog ${VNET_LIST} -top_module ${TOP} -freeze_pad_ring
########################################################################
# FLOORPLAN
#
#set unit tile cmd : set_fp_options -unit_tile_name {core bcore}
#set mw_site_name_mapping "core unit"
if { ${ECO_DEF} != "" } {
   current_design ${TOP}
   read_def -enforce_scaling  ${ECO_DEF} > ${SESSION}.run/read_eco_def.log
}
#############################
# special cell placement cmd: 
# 	set_lib_cell_spacing_label -names {list_of_label_names} [-left_lib_cells \
#	{lib_cell_collection}] [-right_lib_cells {lib_cell_collection}]
#	set_spacing_label_rule -labels {list_of_label_names} {min max}
save_mw_cel -as ${TOP}_${ECO_VERSION}

