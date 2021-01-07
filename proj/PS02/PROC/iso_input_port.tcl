proc iso_input_port { rpt_file } {
	set rpt [open $rpt_file w]
	set all_input [all_inputs]
	foreach_in_collection input $all_input {
		set name [get_attribute $input full_name]
		puts $rpt $name
	}
	close $rpt
}
