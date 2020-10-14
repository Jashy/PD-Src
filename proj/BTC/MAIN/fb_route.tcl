source -e ~/m_scripts/THP7312/Fishbone/include.tcl
set_host_options -max_cores $num_cpus 
set compile_instance_name_suffix   "_FBROUTE"

################################################################################
#FB routing option
set_route_mode_options -zroute true
set_route_options -same_net_notch check_and_fix
set_si_options -route_xtalk_prevention false
set_route_zrt_global_options -crosstalk_driven false -timing_driven false
set_route_zrt_track_options  -crosstalk_driven false -timing_driven false
set_route_zrt_detail_options -timing_driven false
#-#-  set_si_options -route_xtalk_prevention_threshold  0.30

set FB_MIN_ROUTING_LAYER M1
set FB_MAX_ROUTING_LAYER M6
set_ignored_layers -min_routing_layer $FB_MIN_ROUTING_LAYER  -max_routing_layer $FB_MAX_ROUTING_LAYER

set_parameter -name doAntennaConx -value 4
set_delay_calculation -clock_arnoldi
set_route_zrt_common -clock_topology comb -comb_distance 1
#-#-  set_route_zrt_global -clock_topology comb -comb_distance 1 -comb_max_connections -1
set_route_zrt_common_option -clock_topology comb -comb_distance 1 
###########################################################################
#Mark FB as ckock 
set fbnets [ get_nets -of [ get_pins -of [ get_cells * -hier -filter "full_name =~ *FB_L3*" ] -filter "direction == out" ] ]
foreach_in_collection fbnet $fbnets {
        set clock_net_name [get_attribute $fbnet full_name]
        set_attribute $fbnet net_type clock
        set_route_type -clock Strap  [ get_net_shapes -of_objects $fbnet ]
        set_route_type -clock Strap  [ get_vias -of_objects $fbnet ]
	echo "Information(arckeonw): clock & User Enter attribute are applied on Net & shapes(vias): $clock_net_name"
}

###########################################################################
#Change fishbone trunk and via names

foreach_in_collection fbnet $fbnets {
	set net_name [ get_attr $fbnet full_name ]
	create_net ${net_name}_tmp_driver_connection
	foreach_in_collection drive [ get_drivers $net_name ] {
		disconnect_net $net_name $drive
		connect_net ${net_name}_tmp_driver_connection $drive
	}
	set vias [ get_vias -of $fbnet -quiet ]
	set shapes [ get_net_shapes -of $fbnet -quiet -filter "width != 1 && width != 2 "]
	set_attr $shapes owner_net ${net_name}_tmp_driver_connection
	set_attr $vias   owner_net ${net_name}_tmp_driver_connection
}

################################################################################
#Route fishbone

set_net_routing_rule $fbnets -rule DSDV_routing_rule
route_zrt_group -max_detail_route_iterations 10 -nets $fbnets

#######################################################
#Recover fishbone trunk and via names
set tmp_nets [ get_nets * -hier -filter "full_name =~ *_tmp_driver_connection " ]
foreach tmp_net [ get_object_name $tmp_nets ] {
	set shapes [ get_net_shapes -of $tmp_net ]
	set vias   [ get_vias -of $tmp_net ]
	set owner_net [ lindex [ get_attr $shapes owner_net ] 0 ]
	regexp {^(\S+)_tmp_driver_connection$} $owner_net "" owner_net
	set_attr $shapes owner_net ${owner_net}
	set_attr $vias   owner_net ${owner_net}

 	set net_name [ get_attr $tmp_net full_name ]
	regexp {^(\S+)_tmp_driver_connection$} $net_name "" net_name
	foreach_in_collection drive [ get_drivers $tmp_net ] {
		disconnect_net $tmp_net $drive
		connect_net $net_name $drive
		}
	remove_net $tmp_net
}

save_mw_cel -as Route_FB
save_mw_cel
