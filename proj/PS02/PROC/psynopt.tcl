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
# PATH GROUP
#
  set_critical_range 10 [current_design]
  group_path -default      -weight 1.0 -critical_range 9.999
  group_path -name from_in -weight 1.0 -critical_range 15 -from [all_inputs]
  group_path -name to_out  -weight 1.0 -critical_range 15 -to   [all_outputs]
  group_path -name ARMCLK  -weight 2.0 -critical_range 10 -from [get_clocks ARMCLK]
  group_path -name ARMCLK  -weight 2.0 -critical_range 10 -to [get_clocks ARMCLK]
  group_path -name MICLK   -weight 2.0 -critical_range 10 -to [get_clocks MICLK]

#  report_path_group >      ${SESSION}.run/path_group.rpt

########################################################################
# DESIGN CONSTRAINTS
#
if { $SETUP_MARGIN != 0 } { set_clock_uncertainty -setup $SETUP_MARGIN [ all_clocks ] }
if { $HOLD_MARGIN  != 0 } { set_clock_uncertainty -hold  $HOLD_MARGIN  [ all_clocks ] }

set_max_net_length 	$MAX_NET_LENGTH    [current_design]
set_max_capacitance 	$MAX_CAPACITANCE   [current_design]
set_max_transition 	$MAX_TRANSTION     [current_design]
set_max_fanout      	$MAX_FANOUT        [current_design]

if { $DERATE     != "" } { source $DERATE }
if { $DONT_USE   != "" } { source $DONT_USE }
if { $DONT_TOUCH != "" } { source $DONT_TOUCH }
if { $KEEP_LIST  != "" } { source $KEEP_LIST }

set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER -max_routing_layer $MAX_ROUTING_LAYER
set_operating_conditions $operating_cond -analysis_type on_chip_variation -lib $operating_cond_lib

########################################################################
# plcace_opt options
set_fix_multiple_port_nets -all -buffer_constants
set_auto_disable_drc_nets -constant false
set_cbt_options -threshold 20 -references $CBT_BUFFER
set_ahfs_options -hf_threshold 110 -mf_threshold 32 -enable_port_punching false
set_buffer_opt_strategy -effort medium

set place_opt_enable_new_hfs true
set placer_enable_enhanced_router true
##################################################################### 
# start of opt
echo "INFO: start of $STEP"
echo [exec date]

psynopt -congestion -area_recovery
echo "INFO: end of ${STEP}"
report_cpu_usage

########################################################################
# change name
define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} \
 -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose        

##################################################################### 
# save and reports
save_mw_cel 
save_mw_cel -as ${STEP}

write_verilog -no_physical_only_cells      	  	${SESSION}.run/${STEP}.v
exec touch 						./${SESSION}.run/${STEP}.ready
get_ideal_nets 40 					> ${SESSION}.run/${STEP}_ideal_nets.cmd
report_utilization					> ${SESSION}.run/${STEP}_utilization.rpt
report_design -physical			 		> ${SESSION}.run/${STEP}_pr_summary.rpt
check_legality -verbose			 		> ${SESSION}.run/${STEP}_check_legality.rpt
report_net_fanout -threshold  40 -nosplit      		> ${SESSION}.run/${STEP}_net_fanout.rpt
report_constraint -all                         		> ${SESSION}.run/${STEP}_constraints.rpt
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STEP}_setup.rep
exec ${TCL_SRC}/PT/check_violation_summary.pl   ${SESSION}.run/${STEP}_setup.rep >  ${SESSION}.run/${STEP}_setup.rep.summary

