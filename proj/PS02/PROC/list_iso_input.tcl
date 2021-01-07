proc iso_input { rpt_file } {
	set rpt [open $rpt_file w]

	set all_input [all_inputs]
	foreach_in_collection input $all_input {
		set iso_cells [all_fanout -from $input -levels 1 -only_cells]
		foreach_in_collection iso_cell $iso_cells {
			set name [get_attribute $iso_cell full_name]
			puts $rpt $name
		}
	}
	close $rpt
}
