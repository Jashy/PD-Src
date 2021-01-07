########################################################################
# plcace_opt
#
create_bounds  -name "center_ccx" -coordinate {0 0 500 500} -type soft [get_cells ccx]

####memory keeput############
#set_keepout_margin -type hard -all_macros -outer {5 5 5 5}

set_delay_estimation_options -max_unit_horizontal_capacitance_scaling_factor $CAPACITANCE_SCALING_FACTOR \
			 -max_unit_vertical_capacitance_scaling_factor  $CAPACITANCE_SCALING_FACTOR \
			 -max_via_resistance_scaling_factor $RESISTANCE_SCALING_FACTOR \
			 -max_unit_vertical_resistance_scaling_factor $RESISTANCE_SCALING_FACTOR \
			 -max_unit_horizontal_resistance_scaling_factor $RESISTANCE_SCALING_FACTOR 

set_max_capacitance $MAX_CAPACITANCE [current_design]
set_max_transition  $MAX_TRANSITION  [current_design]
set_max_fanout      $MAX_FANOUT      [current_design]
set_max_net_length  $MAX_NET_LENGTH  [current_design]
#
set_fix_multiple_port_nets -all -buffer_constants 
#
set_auto_disable_drc_nets -constant false
set_si_option -delta_delay true -static_noise true
set_si_option -timing_window false
set_si_option -analysis_effort medium
set_delay_calculation -arnoldi
set si_use_partial_grounding_for_min_analysis true
set si_filter_per_aggr_noise_peak_ratio 0.01
set si_filter_accum_aggr_noise_peak_ratio 0.03
#
set_xtalk_route_options -groute_minimize_xtalk true -groute_xtalk_weight 10 -track_assign_minimize_xtalk true -track_assign_noise_threshold 0.35
set_extraction_options -min_res_scale 0.9 -max_res_scale 1.1 -min_cap_scale 0.9 -max_cap_scale 1.1 -min_ccap_scale 1.5000 \
	-max_ccap_scale 1.50000 -min_process_scale 1.00000 -max_process_scale 1.00000 -min_net_ccap_thres 0.003 -max_net_ccap_thres $max_net_ccap_thres  \
	-min_net_ccap_ratio 0.03 -max_net_ccap_ratio $max_net_ccap_ratio -min_net_ccap_avg_ratio 0 -max_net_ccap_avg_ratio 0 -no_break_segments \
	-virtual_shield_extraction false -fan_out_thres 1000 -real_metalfill_extraction none
set_si_options -delta_delay true -static_noise true -timing_window false -min_delta_delay false -static_noise_threshold_above_low 0.35 \
	-static_noise_threshold_below_high 0.35 -route_xtalk_prevention true -route_xtalk_prevention_threshold 0.35 \
	-analysis_effort low -max_transition_mode normal_slew
save_mw_cel  -over  -as ${TOP}_pre_opt
save_mw_cel  -design $TOP
##########
foreach_in_collection bufb [get_lib_cells */BUF*B_*] {
  set_dont_use $bufb
}
###########
#
set_pnet_options -min_width 2 -partial -density 0.7 M4
report_pnet_options                        > ${SESSION}.run/pre_physopt.pnet_options.rpt
set place_opt_enable_new_hfs false
set_ahfs_options -hf_threshold 30 -default_reference  { INV_X13M_A12TL  INV_X16M_A12TL }
source /proj/NSP2/CURRENT/STA/robinsu/CENTER_CCX/ICC/set_dont_use2.tcl
#set_ahfs_options -enable_port_punching false -preserve_boundary_phase true

# avoid delete FF or other output floating cell
set physopt_delete_unloaded_cells false
#set_dont_touch [get_cell ISO_IN_clk_GTD_ECO_1 ]
if { ${DONT_TOUCH_FILE} != "" } {
  set DONT_TOUCH_LIST [open $DONT_TOUCH_FILE r]
  while { [get $DONT_TOUCH_LIST dont_cell_name] >= 0 ] } {
	set_dont_touch $dont_cell_name
  }
  close $DONT_TOUCH_LIST
}
#set target_library $target_library_sz
#place_opt -congestion  
place_opt -congestion -area_recovery
derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS
save_mw_cel $TOP
### option : -lib_cell_class_opto_only ???? for same lib class , such as avoid buf replaced from symmetric clock buf
psynopt -area_recovery -congestion
save_mw_cel $TOP
#
report_timing -max 1000 -net -tran -cap -input  -slack_lesser_than 0 > ${SESSION}.run/place_opt.rpt
#
#set target_library $target_library
## opt power
#set physopt_area_critical_range 0.1
#set physopt_power_critical_range 0.1
#set_max_area 0
#set physopt_area_critical_range 1.5
#set_power_options -leakage true -leakage_effort high -dynamic true
#set_max_dynamic_power 0
#set_max_leakage_power 0
#read_saif -input saif_file -instance path
#psynopt -power -area_recovery -congestion
#derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS
#check_mv_design -level_shifters
#redirect -tee ${SESSION}.run/physical_statistic_place_opt.log { report_design -physical > ${SESSION}.run/physical_statistic_place_opt.rpt }
#save_mw_cel $TOP
#save_mw_cel -as PSYN_OPT
#derive_pg_connection -verbose
#
if { $AC_opt eq "yes"} {
	# set ideal_network and fix the cells on the internal path
	set_ideal_network [all_registers -output_pins]
	set_ideal_network [all_fanin -to [all_registers -data_pins] -flat]
	remove_ideal_network [all_fanin -to [all_outputs] -flat]
	remove_ideal_network [all_fanout -from [all_inputs] -flat ]
	remove_ideal_network [all_fanout -flat -clock_tree]
	set_false_path -from [all_registers -clock_pins]  -to [all_registers -data_pins]
	suppress_message MWUI-031
	set_attribute -class cell  [get_flat_cells -of  [all_ideal_nets]] is_fixed true
	####
	psynopt -area_recovery -congestion

	# recover setting ideal_network and fixing the cells on the internal path
	suppress_message PSYN-040
	set_attribute -class cell [get_flat_cells -of [all_ideal_nets]] is_fixed false
	remove_ideal_network -all
	reset_path -from [all_registers -clock_pins] -to [all_registers -data_pins]

}

