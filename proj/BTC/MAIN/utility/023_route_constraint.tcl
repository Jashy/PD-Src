######################################################################
# CLOCK ROUTING OPTION
#
set_route_options -same_net_notch check_and_fix
set_route_options  -groute_clock_routing balanced
set_si_options -delta_delay true \
	-static_noise true \
      	-timing_window false \
      	-min_delta_delay true \
      	-static_noise_threshold_above_low 0.35 \
        -static_noise_threshold_below_high 0.35 \
      	-route_xtalk_prevention true \
      	-route_xtalk_prevention_threshold 0.35 \
        -analysis_effort low \
      	-max_transition_mode normal_slew

set_route_mode_options -zroute true
set_route_zrt_global_options -crosstalk_driven true
set_route_zrt_track_options  -crosstalk_driven true
set_route_zrt_common_options -connect_tie_off true
set_route_zrt_detail_options -generate_extra_off_grid_pin_tracks true -check_pin_min_area_min_length true -timing_driven false
#-#-  set_route_zrt_common_options -min_layer_mode allow_pin_connection ; No such option now
set_route_zrt_detail_options -repair_shorts_over_macros_effort_level low
set_route_zrt_common_options -clock_topology normal 
remove_ignored_layers -all
set_ignored_layers -min_routing_layer M2 -max_routing_layer C7
set_route_zrt_common_options -connect_within_pins_by_layer_name {{M1 via_wire_standard_cell_pins}}

######DPT setting 
enable_double_patterning_rules -verbose
is_double_patterning_enabled
####### by henryz, recommanded by iccag(synopsys)
set_route_zrt_common_options -global_min_layer_mode allow_pin_connection -net_min_layer_mode allow_pin_connection ;#disabling routing on the metal1 layer
set_route_zrt_global_options -double_pattern_utilization_by_layer_name {{M2 60.0} {M3 60.0}} ;#setting the globale routing track utilization
set_route_opt_strategy -search_repair_loops 40 -eco_route_search_repair_loops 20 ;#increasing the number of routing iterations
set_route_zrt_common_options -report_local_double_pattern_odd_cycles true

set_route_zrt_common_options -number_of_vias_under_global_min_layer 1
set_route_zrt_common_options -number_of_vias_under_net_min_layer 0
set_route_zrt_common_options -single_connection_to_pins standard_cell_pins
set_route_zrt_detail_options -var_spacing_to_same_net true
set_route_zrt_common_options -min_edge_offset_for_macro_pin_connection_by_layer_name {{M2 0} {M3 0} {C4 0}}
set_route_zrt_detail_options -antenna true

################################################################################
#Added by arm
source -e /proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/milkyway/8M_3Mx_4Cx_1Gx_LB/antenna_rules.tcl
source -e /proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/milkyway/8M_3Mx_4Cx_1Gx_LB/icc_route_options.tcl

