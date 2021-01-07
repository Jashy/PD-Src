proc rep_nets { pattern rpt_file } {
	set rpt_file [open $rpt_file w]

	set nets [get_nets * -hier -filter "full_name =~ *$pattern*"]
	foreach_in_collection each_net $nets {
		set net_name [get_attribute $each_net full_name]
		puts $rpt_file "netWeight $net_name 12 12"
	}
	close $rpt_file
}
