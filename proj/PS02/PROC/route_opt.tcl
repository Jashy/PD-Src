########################################################################
### ISO legalize
#
set isocells [get_cells "*ISO*" -hier]
foreach_in_collection isocell $isocells {
  remove_dont_touch_placement  [get_cells $isocell]
  set_attribute -quiet [get_cells $isocell] is_fixed false
}
legalize_placement
foreach_in_collection isocell $isocells {
  set_dont_touch_placement  [get_cells $isocell]
  set_attribute -quiet [get_cells $isocell] is_fixed false
}
###
################
## route
# route area cmd: route_area
# route shielding cmd: create_auto_shield
#
#set_net_routing_layer_constraints * -min_layer M1 -max_layer M7
set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER
set_droute_options -name hardMaxLayerConx -value 2
set_route_opt_strategy -xtalk_reduction_loops 5 -search_repair_loops 15 -eco_route_search_repair_loops 10
set_separate_process_options -routing false -extraction false  -placement false

set routeopt_xtalk_reduction_setup_threshold 0.02
set_si_option -delta_delay true -static_noise true
set_si_option -timing_window false
set_si_option -analysis_effort medium
set_delay_calculation -arnoldi
set si_use_partial_grounding_for_min_analysis true

set si_filter_per_aggr_noise_peak_ratio 0.01
set si_filter_accum_aggr_noise_peak_ratio 0.03
set_route_options  -groute_timing_driven false  -groute_skew_control false  -groute_congestion_weight 4  -groute_clock_routing balanced \
	-groute_incremental false  -track_assign_timing_driven false  -droute_connect_tie_off true  -droute_connect_open_nets true  \
	-droute_reroute_user_wires false  -droute_CTS_nets minor_change_only  -droute_single_row_column_via_array center  \
	-droute_stack_via_less_than_min_area add_metal_stub  -droute_stack_via_less_than_min_area_cost 0  \
	-poly_pin_access auto  -drc_distance diagonal  -same_net_notch ignore  -fat_wire_check merge_then_check  

set_xtalk_route_options -groute_minimize_xtalk true -groute_xtalk_weight 10 -track_assign_minimize_xtalk true -track_assign_noise_threshold 0.35
set_extraction_options -min_res_scale 0.9 -max_res_scale 1.1 -min_cap_scale 0.9 -max_cap_scale 1.1 -min_ccap_scale 1.5000 \
	-max_ccap_scale 1.50000 -min_process_scale 1.00000 -max_process_scale 1.00000 -min_net_ccap_thres 0.003 -max_net_ccap_thres 0.003 \
	-min_net_ccap_ratio 0.03 -max_net_ccap_ratio 0.03 -min_net_ccap_avg_ratio 0 -max_net_ccap_avg_ratio 0 -no_break_segments \
	-virtual_shield_extraction false -fan_out_thres 1000 -real_metalfill_extraction none
set_si_options -delta_delay true -static_noise true -timing_window false -min_delta_delay false -static_noise_threshold_above_low 0.35 \
	-static_noise_threshold_below_high 0.35 -route_xtalk_prevention true -route_xtalk_prevention_threshold 0.35 \
	-analysis_effort low -max_transition_mode normal_slew
# rule define
#define_routing_rule  -default_reference_rule  -taper_level 0  \
#	-widths         { M1 0.09 M2 0.1 M3 0.1 M4 0.1 M5 0.1 M6 0.1 M7 0.4 M8 0.4 }   \
#	-spacing        { M1 0.09 M2 0.2 M3 0.2 M4 0.2 M5 0.2 M6 0.2 M7 0.4 M8 0.4 }   \
#	{rule_double_space}
#define_routing_rule  -default_reference_rule  -taper_level 0  \
#	-widths         { M1 0.09 M2 0.1 M3 0.2 M4 0.2 M5 0.2 M6 0.2 M7 0.4 M8 0.4 }   \
#	-spacing        { M1 0.09 M2 0.2 M3 0.2 M4 0.2 M5 0.2 M6 0.2 M7 0.4 M8 0.4 }   \
#	{rule_all_double}
set M2S [expr ([get_layer_attribute -layer M2 minSpacing]*1.5)]
set M3S [expr ([get_layer_attribute -layer M3 minSpacing]*1.5)]
set M4S [expr ([get_layer_attribute -layer M4 minSpacing]*1.5)]
set M5S [expr ([get_layer_attribute -layer M5 minSpacing]*1.5)]
set M6S [expr ([get_layer_attribute -layer M6 minSpacing]*1.5)]
set M7S [expr ([get_layer_attribute -layer M7 minSpacing]*1.5)]
set M8S [expr ([get_layer_attribute -layer M8 minSpacing]*1.5)]
set M9S [expr ([get_layer_attribute -layer M9 minSpacing]*1.5)]

set M2W [expr ([get_layer_attribute -layer M2 minWidth]*1.5)]
set M3W [expr ([get_layer_attribute -layer M3 minWidth]*1.5)]
set M4W [expr ([get_layer_attribute -layer M4 minWidth]*1.5)]
set M5W [expr ([get_layer_attribute -layer M5 minWidth]*1.5)]
set M6W [expr ([get_layer_attribute -layer M6 minWidth]*1.5)]
set M7W [expr ([get_layer_attribute -layer M7 minWidth]*1.5)]
set M8W [expr ([get_layer_attribute -layer M8 minWidth]*1.5)]
set M9W [expr ([get_layer_attribute -layer M9 minWidth]*1.5)]

define_routing_rule \
-snap_to_track -default_reference_rule \
-widths "M3 $M3W M4 $M4W M5 $M5W M6 $M6W M7 $M7W M8 $M8W M9 $M9W" \
DSDW_routing_rule


define_routing_rule \
-snap_to_track -default_reference_rule \
-widths "M2 $M2W M3 $M3W M4 $M4W M5 $M5W M6 $M6W M7 $M7W M8 $M8W M9 $M9W" \
DS_routing_rule

define_routing_rule \
-snap_to_track -default_reference_rule \
-spacings "M7 $M7S M8 $M8S" \
DSM78_routing_rule
#
#set f [open /proj/NSP/CURRENT/PNR/ives/ICC/common/net_xtalk78.list_u r]
#while { [gets $f line] >=0 } {
#        set hotnet [get_attribute [get_net $line] full_name]
#        set_net_routing_rule $hotnet -rule DSDW_routing_rule
##	set_net_routing_layer_constraints $hotnet  -min_layer M7  -max_layer M8 > /dev/null
#      }
#close $f
#define_routing_rule  -default_reference_rule  -taper_level 0  \
#	-widths  { MET1 0.14 MET2 0.21 MET3 0.21 MET4 0.21 MET5 0.21 MET6 0.28 METG1 0.42 METTOP 0.9 }   \
#	-spacing  { MET1 0.12 MET2 0.14 MET3 0.14 MET4 0.14 MET5 0.14 MET6 0.28 METG1 0.42 METTOP 0.9 }  \
#	-shield_width  { MET1 0.14 MET2 0.14 MET3 0.14 MET4 0.14 MET5 0.14 MET6 0.28 METG1 0.42 METTOP 0.9 }   \
#	-shield_spacing  { MET1 0.12 MET2 0.14 MET3 0.14 MET4 0.14 MET5 0.14 MET6 0.28 METG1 0.42 METTOP 0.9 }   \
#	-via_cuts  { VIA12_HV 1x1 VIA23_VH 1x1 VIA34_HV 1x1 VIA45_VH 1x1 VIA56 1x1 VIAG1 1x1 VIATOP 1x1 }   {double_rule}
# dont route identical net cmd: define_routing_rule -default_reference_rule rule_name
#		  set_net_routing_rule -rule rule_name  -reroute freeze [get_nets dont_reroute_nets]
################
# clock route 

################
# zroute
# set_route_zrt_detail_options
# set_route_zrt_common_options -verbose_level 1
foreach_in_collection clock [ all_clocks ] {
  if { [get_attribute $clock sources] != "" } {
    set_dont_touch_network $clock
  }
  set_clock_transition 0.3 $clock
}
if { ${CLOCK_MODE} == "ideal" } {
  set_clock_uncertainty -setup 0.150 [ all_clocks ]
  set_clock_uncertainty -hold 0.100 [ all_clocks ]
  set default_clock_transition 0.300
  set pins {}
  foreach_in_collection clock [ all_clocks ] {
    set pp [get_attribute $clock full_name]
    echo $pp
    foreach_in_collection source [ get_attribute $clock sources ] {
      #set pins [ add_to_collection $pins [ filter_collection [ all_fanout -flat -from $source ] "is_clock_pin == true" ] ]
      set_ideal_network $source
    }
  }
}

#
set_route_mode_options -zroute true
set_route_zrt_common_options -max_number_of_threads 4
set_route_zrt_global_options  -crosstalk_driven true -clock_topology normal
set_route_zrt_track_options  -crosstalk_driven true
set_route_zrt_common_options -connect_tie_off true 
set_route_zrt_common_options -post_detail_route_redundant_via_insertion off
set_route_zrt_detail_options  -generate_extra_off_grid_pin_tracks true -check_pin_min_area_min_length true
#set_route_zrt_common_options  -connect_within_pins { {m1 via_all_pins} {m2 via_all_pins} {m3 via_all_pins} {m4 via_all_pins}\
#	 {m5 via_all_pins} {m6 via_all_pins} {m7 via_all_pins} {m8 via_all_pins} }
set_route_zrt_common_options  -connect_within_pins {{m1 via_all_pins}}
#
set_extraction_options -min_res_scale 0.9 -max_res_scale 1.1 -min_cap_scale 0.9 -max_cap_scale 1.1 -min_ccap_scale 2.000 \
	-max_ccap_scale 2.000 -min_process_scale 1.00000 -max_process_scale 1.00000 -min_net_ccap_thres 0.003 -max_net_ccap_thres 0.003 \
	-min_net_ccap_ratio 0.03 -max_net_ccap_ratio 0.03 -min_net_ccap_avg_ratio 0 -max_net_ccap_avg_ratio 0 -no_break_segments \
	-virtual_shield_extraction false -fan_out_thres 1000 -real_metalfill_extraction none
set routeopt_xtalk_reduction_setup_threshold 0.02

set_route_zrt_global_options -clock_topology normal
set_route_zrt_detail_options -check_pin_min_area_min_length true
set_si_options -delta_delay true
route_zrt_auto
save_mw_cel -as route_detail
save_mw_cel $TOP
#
# re opt noise
set_route_zrt_common_options  -post_detail_route_redundant_via_insertion off
set routeopt_xtalk_reduction_setup_threshold 0.02
set_si_option -delta_delay true -static_noise true
set_si_option -timing_window false
set_si_option -analysis_effort medium
set_delay_calculation -arnoldi
set si_use_partial_grounding_for_min_analysis true
set_extraction_options -min_res_scale 0.9 -max_res_scale 1.1 -min_cap_scale 0.9 -max_cap_scale 1.1 -min_ccap_scale 2.000 \
	-max_ccap_scale 2.000 -min_process_scale 1.00000 -max_process_scale 1.00000 -min_net_ccap_thres 0.003 -max_net_ccap_thres 0.003 \
	-min_net_ccap_ratio 0.03 -max_net_ccap_ratio 0.03 -min_net_ccap_avg_ratio 0 -max_net_ccap_avg_ratio 0 -no_break_segments \
	-virtual_shield_extraction false -fan_out_thres 1000 -real_metalfill_extraction none

route_opt -only_xtalk_reduction

derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS
save_mw_cel $TOP
save_mw_cel -as route_detail

redirect -tee ${SESSION}.run/physical_statistic_route_opt.log { report_design -physical > ${SESSION}.run/physical_statistic_route_opt.rpt }
############## 
# zroute verify; 
#set_zrt_common_route_option -reroute_user_wire true 
#verify_zrt_route
# hold fixing cell defination cmd : set_prefer -min {bufbd1 invbd2}
#		      set_fix_hold_options -preferred_buffer


