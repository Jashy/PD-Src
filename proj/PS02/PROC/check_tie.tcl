proc check_tie {} {
	set list ""
	foreach_in_collection a  [all_tieoff_cells ]  { 
		set cell [get_cells $a] 
		set pin [get_pins -of  [get_cells $cell]] 
		if { ![sizeof_collection [get_nets -of [get_pins $pin] -q]]} {
			set list [add_to_collection [get_cells $list]   [get_cells $cell]]
		}
	}
	puts $list
}
