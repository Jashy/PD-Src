set cells {
}

gui_change_highlight -remove -all_colors
foreach cel $cells {
	set bbox [get_attr [get_cell $cel] bbox]
	set cel_y1 [ lindex [lindex $bbox 0 ] 1 ]
	set cel_y2 [ lindex [lindex $bbox 1 ] 1 ]
	set cel_height [ expr $cel_y2 - $cel_y1 ]
	set input_pin_number [sizeof_collection [get_pins -of [get_cell $cel] -fil "direction==in" ]]
	set output_pin_number [sizeof_collection [get_pins -of [get_cell $cel] -fil "direction==out" ]]
	set height [ expr $input_pin_number * 1.6 + $output_pin_number * 0.4 ]
	set value [ expr $height / $cel_height ]
	if { $value < 1 } { 
		set new_width 2.7
		hilight_collection orange [get_cell $cel]
           } elseif { $value < 2 } {
	        set new_width 5.4
		hilight_collection yellow [get_cell $cel]
           } elseif { $value < 3 } {
	        set new_width 8.1
		hilight_collection blue [get_cell $cel]
           } elseif { $value < 4 } {
	        set new_width 10.8
		hilight_collection green [get_cell $cel]
           } elseif { $value < 5 } {
	        set new_witdh 13.5
		hilight_collection red [get_cell $cel]
           }
	echo "$cel $cel_height $pin_number $value $new_width " >> info_change
}
