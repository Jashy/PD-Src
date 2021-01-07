proc iso_output_port { rpt_file } {
	set rpt [open $rpt_file w]
	set all_output [all_outputs]
	foreach_in_collection output $all_output {
		set name [get_attribute $output full_name]
		puts $rpt $name
	}
	close $rpt
}
