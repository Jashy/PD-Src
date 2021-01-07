proc rewire_lvl_in_window { cells { r 30 } } {
	foreach cel $cells {
		set i 0
		set loc_x [ lindex [get_location [get_cells $cel]] 0 ]
		set loc_y [ lindex [get_location [get_cells $cel]] 1 ]
		set window [list [ expr $loc_x - $r ] [ expr $loc_y - $r ] [ expr $loc_x + $r ] [ expr $loc_y + $r ]]
		#get_cells -filter "ref_name == LVLUO*" -within {[expr $loc_x - $r] [ expr $loc_y - $r ] [ expr $loc_x + $r ] [ expr $loc_y + $r ]}
		set cells [get_object_name [get_cells -within $window -fil "ref_name == LVLUO_X4M_A8TR"]]
		puts "$cells is in window"
		set driver [lindex $cells 0]
		puts "$driver is selected as driver"
		connect_pin -from $driver/Y -to $cel/ENB -port_name new_lvl_jasons_0219_$i -verbose
}
}
