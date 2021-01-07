foreach_in_collection  cell [get_cells whydra_0/whclkgen_0/*] {
        set cell_name [get_attribute $cell full_name]
        set fix_status [get_attr $cell is_fixed]
	# filter out fixed cell
        if {$fix_status =="true" } {
                 continue
         }
        set loc [get_attribute $cell origin ]
        set x [lindex $loc 0]
        set y  [lindex $loc 1]
        if { [expr $x > 1130] && [expr $x < 1250] && [expr $y > 4820 ] && [expr $y < 4910] } {
	        puts $cell_name
        } else {
		# filter out out of clkgen cell
		continue
	}

}

