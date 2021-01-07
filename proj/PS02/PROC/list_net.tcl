proc list_net { rpt_file } {
	set rpt [open $rpt_file w]
	set all_nets [get_nets * -hier -filter "full_name =~ *INPUTPORT*"]
	foreach_in_collection net $all_nets {
		set name [get_attribute $net full_name]
		puts $rpt $name
	}
	close $rpt
}
