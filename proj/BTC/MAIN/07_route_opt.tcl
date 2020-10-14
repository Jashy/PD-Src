###########route_opt options#######################################################
set STEP route_opt
set compile_instance_name_suffix   "_ROUTEOPT"              ; # default = ""
########################################################################
# route settings
source ./flow_btc/tcl/set_route_constrain.tcl

set_ignored_layers -min_routing_layer M1 -max_routing_layer M6
set_route_mode_options -zroute true
set_route_zrt_common_options -clock_topology normal
set_route_zrt_common_options -enforce_voltage_areas off
set_route_zrt_global_options -crosstalk_driven true -timing_driven true 
set_route_zrt_track_options  -crosstalk_driven true -timing_driven true
set_route_options -same_net_notch check_and_fix
set_route_zrt_detail_options -repair_shorts_over_macros_effort_level low -timing_driven true
set_delay_calculation -clock_arnoldi

echo [sh date] > ./Runtime/${STEP} 
route_opt -skip_initial_route
save_mw_cel -as ${STEP}
route_opt -incremental 
echo [sh date] >> ./Runtime/${STEP} 
save_mw_cel -as ${STEP}

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

save_mw_cel
save_mw_cel -as ${STEP}

########################################################################
# export
source -e ./flow_btc/tcl/export_des.tcl
