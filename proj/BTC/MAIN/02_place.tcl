########################################################################
# step
set STEP place_opt
set compile_instance_name_suffix   "_PLCOPT"              ; # default = ""
set_host_options -max_cores $num_cpus 
set_attribute [all_macro_cells] is_fixed true
set_attribute [all_physical_only_cells ] is_fixed true
########################################################################
#Report initial statics
################################################################################
#scenarios setup

source -e flow_btc/tcl/021_create_scenarios.tcl
################################################################################
# Keepout margin
foreach_in_collection cell [filter_collection [get_flat_cells *  -filter "mask_layout_type == std" ] "number_of_pins >= 4  && width < 1.5" ] {
	set_keepout_margin -type hard -outer {0.252 0 0.252 0}  $cell
}
foreach_in_collection cell [get_flat_cells -filter "ref_name =~ *DF*"] {
	set_keepout_margin -type hard -outer {0.252 0 0.252 0}  $cell
}
foreach_in_collection cell [get_flat_cells -filter "ref_name =~ *PREICG*"] {
	set_keepout_margin -type hard -outer {0.504 0.5 0.504 0.5}  $cell
}

remove_keepout_margin -type hard [get_flat_cells u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_*__u_icg/u_sc_icg]
######################################ensure all macro cells is fixed
#step pre place
source -e flow_btc/tcl/022_place_constraint.tcl
source -e flow_btc/tcl/023_route_constraint.tcl

set power_cg_auto_identify true  ; # For ICC version 2012(replace cmd identify_clock_gating)
identify_clock_gating   ;# Not recommended in version 2012& new
#####################################################################
##remove pre-exist tie cell
remove_tie_cells -use_default_tie_net [all_tieoff_cells] 

########################################################################
# Remove all buffer tree

remove_buffer_tree  -all
if { [all_scenarios  ] != "" } {
	foreach mode [all_scenarios ] {
		current_scenario [get_scenarios $mode]
		remove_clock_tree -clock_trees [all_clocks] -honor_dont_touch
	} 
} else {
	remove_clock_tree -clock_trees [all_clocks] -honor_dont_touch
}
current_scenario normal


#################################################################
## ensure clock is ideal
source -e flow_btc/tcl/024_set_clock_idea.tcl
###############################################################
##start place
printvar >  ${SESSION}.run/printvar.log 
report_si_options > ${SESSION}.run/si_option.log 
report_route_options > ${SESSION}.run/route_option.log 
report_dont_touch > ${SESSION}.run/dont_touch.log

source -e ./flow_btc/change_icg.tcl

save_mw_cel -as b4_place

echo "ICC_version : $sh_product_version" > ./Runtime/${STEP}
echo [sh date] >> ./Runtime/${STEP}
echo "INFO: start ${STEP}"
place_opt -area_recovery -congestion -continue_on_missing_scandef -power
echo [sh date] >> ./Runtime/${STEP}
save_mw_cel -as ${STEP}

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

save_mw_cel 
save_mw_cel -as ${STEP}

########################################################################
# export
source -e flow_btc/tcl/export_des.tcl

