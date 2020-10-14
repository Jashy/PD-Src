#######################################################################
#PSYN OPT
set STEP psynopt
set compile_instance_name_suffix "_PSYNOPT"              ; # default = ""

################################################################
###start psyn 
foreach mode [all_scenarios  ] {
	set physopt_area_critical_range 0.3
  	current_scenario $mode
  	group_path -name from_in  -critical_range 1 -from [all_inputs]
	group_path -name to_out   -critical_range 1 -to   [all_outputs]
}
current_scenario normal


####icc version G-2012.06-ICC
# start of opt
echo "INFO: start of $STEP"
echo [sh date] >> ./Runtime/${STEP}
psynopt -area_recovery -congestion -continue_on_missing_scandef -power
echo "INFO: end of ${STEP}"
echo [sh date ] >> ./Runtime/${STEP}
save_mw_cel -as ${STEP}

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

save_mw_cel 
save_mw_cel -as ${STEP}

########################################################################
# export
source -e ./flow_btc/tcl/export_des.tcl
