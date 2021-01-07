proc list_net { rpt_file } {
	set rpt [open $rpt_file w]
	set all_nets [get_nets -of_objects [get_pins -of_objects [get_cells *ISO_PORT*] -filter "pin_direction == in"]]
	foreach_in_collection net $all_nets {
		set name [get_attribute $net full_name]
		puts $rpt $name
	}
	close $rpt
}
