#######################################################################
# step
set_host_options -max_cores $num_cpus 
set compile_instance_name_suffix   "_CTSROUTE"

################################################################################
# Mark clock tree
echo [date] > Runtime/mark_clock_tree
foreach mode [all_scenarios ] {
	current_scenario $mode
	mark_clock_tree -clock_trees [all_clocks ] -clock_synthesized -fix_sinks 
	mark_clock_tree -clock_trees [all_clocks ] -clock_net 
	mark_clock_tree -clock_trees [all_clocks ] -routing_rule DSDV_routing_rule -use_default_routing_for_sinks 1 
	set_ideal_network [all_fanout -flat -clock_tree]
	remove_propagated_clock -all
	}
echo [date] >> Runtime/mark_clock_tree

source -e	/proj/THP7312/WORK/samh/clock_final/write_clock_pin_net/0729/DSDV.list 
set_attribute [get_nets $DSDV_nets ] net_type clock
set_net_routing_rule [get_nets $DSDV_nets]  -rule DSDV_routing_rule


######################################################################
# CTS routing option

set_route_options -same_net_notch check_and_fix
set_route_options  -groute_clock_routing balanced
set_si_options -delta_delay true \
	-static_noise true \
	-timing_window false \
	-min_delta_delay true \
	-static_noise_threshold_above_low 0.3 \
	-static_noise_threshold_below_high 0.3 \
	-route_xtalk_prevention true \
	-route_xtalk_prevention_threshold 0.25 \
	-analysis_effort medium \
	-max_transition_mode normal_slew

set_route_mode_options -zroute true
set_route_zrt_global_options -crosstalk_driven true -timing_driven false
set_route_zrt_track_options  -crosstalk_driven true -timing_driven false
#  set_route_zrt_common_options -connect_tie_off true
#  set_route_zrt_common_options -max_number_of_threads 8
set_route_zrt_detail_options -generate_extra_off_grid_pin_tracks true -check_pin_min_area_min_length true -timing_driven false
set_route_zrt_common_options -min_layer_mode allow_pin_connection
set_route_zrt_detail_options -repair_shorts_over_macros_effort_level low
set_route_zrt_common_options -clock_topology normal 
set_ignored_layers  -min_routing_layer M1 -max_routing_layer M6
set_route_zrt_common_options -enforce_voltage_areas off
remove_pnet_options

################################################################################
#Route clocks
echo [sh date ] > ./Runtime/Route_CTS
route_zrt_group -all_clock_nets
echo [sh date ] >> ./Runtime/Route_CTS
save_mw_cel -as Route_CTS

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

save_mw_cel -as Route_CTS

