#####################################################################
# start of incremental psynopt(optional)
# this step can be selected based on the
# timing/routing results of initial opt
#
########################################################################
# step
#
set STEP psynopt
set compile_instance_name_suffix "PSYNOPT"              ; # default = ""

########################################################################
# DESIGN CONSTRAINTS
#
source ${TCL_SRC}/set_design_constrain.tcl

source ${TCL_SRC}/create_scenarios.tcl

########################################################################
# place_opt options
set_fix_multiple_port_nets -all -buffer_constants
set_auto_disable_drc_nets -constant false
set_cbt_options -threshold $MAX_FANOUT -references $CBT_BUFFER
set_ahfs_options -hf_threshold $MAX_FANOUT -mf_threshold -1 -enable_port_punching false -default_reference $CBT_BUFFER -optimize_buffer_trees false
set_buffer_opt_strategy -effort medium

#set place_opt_enable_new_hfs true
set placer_enable_enhanced_router true
##################################################################### 
# start of opt
echo "INFO: start of $STEP"
echo [exec date]
set physopt_new_fix_constants true
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL1 dont_touch
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL1 dont_use
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL0 dont_touch
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL0 dont_use

set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL1/Z max_fanout 10
set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL0/Z max_fanout 10
set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL1/Z max_capacitance 0.2 -type float
set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL0/Z max_capacitance 0.2 -type float


#set_false_path -from [all_inputs]
#set_false_path -to   [all_outputs]
#set all_clock_inputs ""
#foreach_in_collection clock [ all_clocks ] {
#  foreach_in_collection source [ get_attribute $clock sources ] {
#    set all_clock_inputs [ add_to_collection $all_clock_inputs $source ]
#  }
#}
#set all_data_inputs [ remove_from_collection [ all_inputs ] $all_clock_inputs ]
#set all_data_outputs [ remove_from_collection [ all_outputs ] $all_clock_inputs ]
#set_false_path -from $all_data_inputs
#set_false_path -to $all_data_outputs

#source /proj/Garnet/WORK/marshals/ICC/20090909b/tcl/set_dont_usehvt.tcl

#psynopt -effort high -power -area_recovery
psynopt -effort high
echo "INFO: end of ${STEP}"
report_cpu_usage

########################################################################
# export
source ${TCL_SRC}/export_des.tcl

