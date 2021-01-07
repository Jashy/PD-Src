proc iso_mem { rpt_file } {
	set rpt [open $rpt_file w]
	set all_mems [filter_collection [get_cells * -hier -filter "ref_name =~ RF* || ref_name =~ SRAM*"]  "is_hierarchical == false"]
	foreach_in_collection mem $all_mems {
		set all_pins [get_pins -of_object $mem -filter "pin_direction == in"]
		foreach_in_collection pin $all_pins {
			set name [get_attribute $pin full_name]
			set cell [all_fanin -to $name -levels 1 -only_cells]
			foreach_in_collection iso $cell {
				set iso_name [get_attribute $iso full_name]
				if { [regexp {.*ISO.*} $iso_name] } {
					puts $rpt $iso_name
				}
			}
		}
	}
	close $rpt
}
