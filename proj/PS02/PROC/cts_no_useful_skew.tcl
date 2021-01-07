

########################################################################
# DESIGN CONSTRAINTS
#

source ${TCL_SRC}/set_design_constrain.tcl

########################################################################
# place_opt options
set_fix_multiple_port_nets -all -buffer_constants
set_auto_disable_drc_nets -constant false
set_cbt_options -threshold 20 -references $CBT_BUFFER
set_ahfs_options -hf_threshold $MAX_FANOUT -mf_threshold -1 -enable_port_punching false -default_reference $CBT_BUFFER -optimize_buffer_trees false -remove_effort none
set_buffer_opt_strategy -effort medium

set place_opt_enable_new_hfs true
set placer_enable_enhanced_router true

#####################################################################
# start of opt
echo "INFO: start of $STEP"
echo [exec date]
set physopt_new_fix_constants true

set physopt_new_fix_constants true
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL1 dont_touch
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL1 dont_use
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL0 dont_touch
remove_attr scc090ng_hs_rvt_v0p9_ss125/PULL0 dont_use

set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL1/Z max_fanout 10
set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL0/Z max_fanout 10
set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL1/Z max_capacitance 0.2 -type float
set_attribute scc090ng_hs_rvt_v0p9_ss125/PULL0/Z max_capacitance 0.2 -type float

##remove pre-exist tie cell
#remove_tie_cells -use_default_tie_net [all_tieoff_cells]

########################################################################
## HIGH FANOUT NET
set target_library $target_library
set_distributed_route
set_route_mode_options -zroute true

remove_route_by_type -signal_detail_route -clock_tie_off -pg_tie_off

set timing_seperate_clock_gating_group true

#set_clock_gating_check -setup 0.2
#set_inter_clock_delay_options -balance_group "EXTMEMCLK MCLK PCLK"

source ${TCL_SRC}/create_scenarios.tcl
current_scenario normal

##################################
## clock tree settings
##
source ${TCL_SRC}/cts_setting.tcl

##################################
## start clock opt
##
source ./tcl/check_report_clock_timing_latency.tcl

## generate_clock
set STEP generate_clock_opt
remove_clock_tree_exceptions -all
source ../script/set_block_expection_normal.tcl
set clocks [ get_generated_clocks * ]
compile_clock_tree -sync_phase both -clock_tree [ get_generated_clocks * ]
optimize_clock_tree -clock_tree [ get_generated_clocks * ]
optimize_clock_tree -clock_tree [ get_generated_clocks * ]


check_report_clock_timing_latency
report_net_fanout -threshold  40 -nosplit               > ${SESSION}.run/${STEP}_net_fanout.rpt
save_mw_cel -as ${STEP}

## root clock
set STEP root_clock_opt
remove_clock_tree_exceptions -all
source ../script/set_block_expection_normal.tcl
set clocks [ get_generated_clocks * ]
source ./tcl/annotate_generated_clock_delay.tcl

source ${TCL_SRC}/create_scenarios.tcl
current_scenario normal
source ./tcl/cts_setting.tcl

compile_clock_tree -sync_phase both -clock_tree [ remove_from_collection  [ get_clock * ] [ get_generated_clocks * ] ]
optimize_clock_tree -clock_tree [ remove_from_collection  [ get_clock * ] [ get_generated_clocks * ] ]
optimize_clock_tree -clock_tree [ remove_from_collection  [ get_clock * ] [ get_generated_clocks * ] ]

set_propagated_clock [ get_clocks * ]
check_report_clock_timing_latency
report_net_fanout -threshold  40 -nosplit               > ${SESSION}.run/${STEP}_net_fanout.rpt
save_mw_cel -as ${STEP}

## scan clock
set STEP scan_clock_opt

#icc_shell> get_loads bsc_MIREFCLK_163/U4/Z
#{CLKBUFV20_G3B1I1/I bsc_MIREFCLK_163/CLKBUFV12_G3IP/I}
create_cell MIREFCLK_eco_buf_U0 [get_model CLKBUFV4]
create_cell MIREFCLK_eco_mux_U1 [get_model CKMUX2V2 ]
create_net MIREFCLK_eco_n1
create_net MIREFCLK_eco_n2
connect_net MIREFCLK_eco_n1 MIREFCLK_eco_mux_U1/I1
connect_net MIREFCLK_eco_n2 MIREFCLK_eco_mux_U1/Z
disconnect_net [ get_nets -of bsc_MIREFCLK_163/CLKBUFV12_G3IP/I ] bsc_MIREFCLK_163/CLKBUFV12_G3IP/I
disconnect_net MIREFCLK_pad_C CLKBUFV20_G3B1I1/I
connect_net MIREFCLK_eco_n2 CLKBUFV20_G3B1I1/I
connect_net MIREFCLK_pad_C MIREFCLK_eco_mux_U1/I0
connect_net MIREFCLK_pad_C MIREFCLK_eco_buf_U0/I
connect_net MIREFCLK_eco_n1 MIREFCLK_eco_buf_U0/Z
connect_pin -from MIREFCLK_eco_buf_U0/Z -to bsc_MIREFCLK_163/CLKBUFV12_G3IP/I -port_name MIREFCLK_eco_n1
connect_pin -from UUruby_dft/ruby_core/sys/sys_ctrl/U_MEMCLKPLL_SCANCLK_ECO_0830_20_SCAN_DC_ECO_51/S -to MIREFCLK_eco_mux_U1/S -port_name MIREFCLK_eco_mux_U1_S
move_object MIREFCLK_eco_buf_U0 -to [ lindex [ get_attr [get_pins bsc_MIREFCLK_163/U4/Z] bbox ] 0 ]
move_object MIREFCLK_eco_mux_U1 -to [ lindex [ get_attr [get_pins bsc_MIREFCLK_163/U4/Z] bbox ] 0 ]


#CHANGE_CELL UUruby_dft/ruby_core/sys/sys_ctrl/uRegWrclk_gate/alcp_U1PLCOPT CLKBUFV8
#move_objects UUruby_dft/ruby_core/sys/sys_ctrl/uRegWrclk_gate/alcp_U1PLCOPT -to [lindex [ get_attr [ get_pins UUruby_dft/ruby_core/image_proc/uRegWrSrc] bbox ] 0 ]
#move_objects UUruby_dft/ruby_core/sys/sys_ctrl/uRegWrclk_gate/lib_icgcell_SCAN_DC_ECO_10 -to [lindex [ get_attr [ get_pins UUruby_dft/ruby_core/image_proc/uRegWrSrc] bbox ] 0 ]
#CHANGE_CELL UUruby_dft/ruby_core/sys/sys_ctrl/uRegWrclk_gate/lib_icgcell CLKLANQV2


set scenarios_sdc(scan_capture_ac) "/proj/Garnet/WORK/marshals/ICC/sdc/scan/Garnet_scan_capture_ac_cts.sdc"
source ${TCL_SRC}/create_scenarios.tcl
current_scenario scan_capture_ac
source ./tcl/cts_setting.tcl

remove_clock_tree_exceptions -all
source ../script/set_block_expection_scan_capture_ac.tcl
source ./tcl/annotate_generated_clock_delay_scan.tcl

source ${TCL_SRC}/create_scenarios.tcl
current_scenario scan_capture_ac
source ./tcl/cts_setting.tcl

compile_clock_tree -sync_phase both
optimize_clock_tree

set_propagated_clock [ get_clocks * ]
check_report_clock_timing_latency
report_net_fanout -threshold  40 -nosplit               > ${SESSION}.run/${STEP}_net_fanout.rpt
save_mw_cel -as ${STEP}

set scenarios_sdc(scan_capture_ac) "/proj/Garnet/WORK/marshals/ICC/sdc/scan/Garnet_scan_capture_ac.sdc"

#### mbist clock
##set STEP mbist_clock_opt
##
##remove_clock_tree_exceptions -all
##source ./tcl/set_clock_tree_exceptions.tcl
##source ./tcl/annotate_generated_clock_delay_mbist.tcl
##
##remove_sdc
##source ./mbist.sdc >> ${SESSION}.run/read_sdc_mbist.log
##
##compile_clock_tree -sync_phase both
##optimize_clock_tree
##
##set_propagated_clock [ get_clocks * ]
##check_report_clock_timing_latency
##report_net_fanout -threshold  40 -nosplit               > ${SESSION}.run/${STEP}_net_fanout.rpt
##save_mw_cel -as ${STEP}
##
##
##
##
##report_clock_tree -summary > ${SESSION}.run/report_clk_tree_summary.rpt
##report_qor > ${SESSION}.run/clock_opt_qor.rpt
##report_timing -max_path 100 -slack_lesser_than 0 -input -net -nosplit > ${SESSION}.run/clock_opt_timing.${STEP}.rpt
##exec ${TCL_SRC}/PT/check_violation_summary.pl    ${SESSION}.run/clock_opt_timing.${STEP}.rpt > ${SESSION}.run/clock_opt_timing.rpt.${STEP}.summary
##
##save_mw_cel -as $STEP
##
##report_clock_tree -summary > ${SESSION}.run/report_clk_tree_summary.rpt
##report_qor > ${SESSION}.run/clock_opt_qor.rpt
##report_timing -max_path 100 -slack_lesser_than 0 -input -net -nosplit > ${SESSION}.run/clock_opt_timing.rpt
##exec ${TCL_SRC}/PT/check_violation_summary.pl    ${SESSION}.run/clock_opt_timing.rpt > ${SESSION}.run/clock_opt_timing.rpt.summary
##
##optimize_clock_tree -buffer_sizing -gate_sizing -routed_clock_stage detail_with_signal_routes
###exit

source ${TCL_SRC}/create_scenarios.tcl
current_scenario normal

source ./tcl/cts_setting.tcl
source ./tcl/route.tcl
source ./tcl/route_opt.tcl


