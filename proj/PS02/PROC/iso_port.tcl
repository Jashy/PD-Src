proc iso_port { rpt_file } {
	set rpt [open $rpt_file w]
	set all_port [get_ports *]
	set top [get_attribute [current_design] full_name]
	foreach_in_collection port $all_port {
		set name [get_attribute $port full_name]
		puts $rpt "ISO_PORT $top $name BUFX16"
	}
	close $rpt
}
