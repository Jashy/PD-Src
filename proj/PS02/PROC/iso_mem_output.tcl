proc iso_mem_output { rpt_file } {
	set rpt [open $rpt_file w]
	set all_mems [filter_collection [get_cells * -hier -filter "ref_name =~ RF* || ref_name =~ SRAM*"]  "is_hierarchical == false"]
	foreach_in_collection mem $all_mems {
		set all_pins [get_pins -of_object $mem -filter "direction == out"]
		foreach_in_collection pin $all_pins {
			set name [get_attribute $pin full_name]
			if { [regexp {(.*)\/(.*)} $name tmp ins pin ] } {
				puts $rpt "INSERT_BUFFER $ins $pin BUFX16"
			}
		}
	}
	close $rpt
}
