remove_route_by_type -signal_detail_route -clock_tie_off

foreach_in_collection fb_drv_pin [get_pins -hierarchical -filter "full_name =~ *FB_L3_DRIVE01/Z" ] {
	set fb_net [get_attribute [get_nets -top_net_of_hierarchical_group -segments -of_objects $fb_drv_pin ] full_name]
	foreach_in_collection shape [get_net_shapes -of_objects [get_net $fb_net]] {
		set_attribute $shape route_type "User Enter"
	}
	foreach_in_collection via [get_vias -of_objects [get_net $fb_net]] {
		set_attribute $via route_type "User Enter"
	}
}
