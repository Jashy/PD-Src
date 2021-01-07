proc list_ports { rpt_file } {
	set rpt [open $rpt_file w]
	set all_ports [get_ports *]
	foreach_in_collection port $all_ports {
		set name [get_attribute $port full_name]
		puts $rpt $name
	}
	close $rpt
}
