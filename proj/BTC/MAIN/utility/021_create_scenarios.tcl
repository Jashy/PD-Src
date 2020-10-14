######################################################################
### # scenarios setting
set scenarios_sdc(normal) 	"/proj/BTC/from_customer/20150815/20150815_top_final_netlist/TOP_FDI/LKB11.sdc"

### Opcond Setting
set operating_cond_max ss_nominal_max_0p59v_125c
set operating_cond_lib_max {sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c sc9mcpp84_ln14lpp_hpk_lvt_c14_ss_nominal_max_0p59v_125c}
set TLUP_MAP    "/proj/BTC/WORK/arckeonw/ICC/btc_unit/floorplan_20150625/template/8M_3Mx_4Cx_1Gx_LB_tluplus.map"
set TLUP_MAX 	"/proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/synopsys_tluplus/8M_3Mx_4Cx_1Gx_LB/SigCmaxDP_ErPlus.tluplus"
set TLUP_MIN 	"/proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/synopsys_tluplus/8M_3Mx_4Cx_1Gx_LB/SigRCminDP_ErMinus.tluplus"

### Margin Setting
set SETUP_MARGIN	"0.35"
set CKGATE_SETUP_MARGIN	"0.40"
set MAX_NET_LENGTH	"100"
set MAX_CAPACITANCE	""
set MAX_FANOUT		"16"
set MAX_TRANSITION	"0.20"
set CRITICAL_RANGE	"0.5"
set DERATE		""
set DONT_USE		"./flow_btc/tcl/btc_dont_use.tcl"
set DONT_TOUCH		"./flow_btc/20150815_dont_touch.list"
set KEEP_LISTS		"./flow_btc/dont_touch_net.tcl"

####
remove_sdc -keep_parasitics
remove_scenario -all

foreach mode [ array name scenarios_sdc ] {
	puts "*INFO Create scenario: $mode*"
	create_scenario $mode
	foreach sdc $scenarios_sdc($mode) {
		source -echo $sdc >> ${SESSION}.run/read_sdc.${mode}.log
		echo "arckeonw check " >> ${SESSION}.run/read_sdc.${mode}.log
	}
	#-#-  set_operating_conditions -max $operating_cond_max -max_library $operating_cond_lib_max  -analysis_type on_chip_variation
	source -e ./flow_btc/UPF/set_operating_condition.tcl
	set_tlu_plus_files -tech2itf_map $TLUP_MAP -max_tluplus $TLUP_MAX -min_tluplus $TLUP_MIN
	
	if { $SETUP_MARGIN != 0 } { set_clock_uncertainty -setup $SETUP_MARGIN [ all_clocks ] }
 	if { $CKGATE_SETUP_MARGIN != 0  } {set_clock_gating_check -setup $CKGATE_SETUP_MARGIN [get_cells -hier -filter ref_name=~PREICG*]} ; # Need edit case by case
	if { $MAX_NET_LENGTH	!= "" } { set_max_net_length	$MAX_NET_LENGTH		[current_design] }
	if { $MAX_CAPACITANCE	!= "" } { set_max_capacitance 	$MAX_CAPACITANCE	[current_design] }
	if { $MAX_FANOUT	!= "" } { set_max_fanout	$MAX_FANOUT		[current_design] }
	if { $MAX_TRANSITION	!= "" } { set_max_transition	$MAX_TRANSITION		[current_design] }
	if { $CRITICAL_RANGE	!= "" } { set_critical_range	$CRITICAL_RANGE		[current_design] }
	if { $DERATE     != "" } { source -e  $DERATE }
	
	propagate_constraints -case_analysis
	########################################################################
	# PATH GROUP
	set weight_default 5
	set weight_AC      10
	group_path -critical_range 0.6 -weight $weight_default -default
	group_path -critical_range 0.5 -weight $weight_AC -name from_in -from [all_inputs]
	group_path -critical_range 0.5 -weight $weight_AC -name to_out  -to   [all_outputs]
}

if { $DONT_USE   != "" } { source -e  $DONT_USE }
if { $DONT_TOUCH != "" } { source -e  $DONT_TOUCH }
if { $KEEP_LISTS  != "" } { foreach KEEP_LIST $KEEP_LISTS { source -e  $KEEP_LIST } }

#################################################################
if { [ info exists STEP] == 0 } { set STEP "check" }



set_scenario_options -leakage_power true -dynamic_power true -scenarios [ array name scenarios_sdc ]
report_scenario_options -scenarios [all_scenarios] > ${SESSION}.run/scenario_options_all.${STEP}.rpt
  
set_active_scenario -all
report_scenario  > ${SESSION}.run/initial_all.scenario.${STEP}.rpt
current_scenario normal
